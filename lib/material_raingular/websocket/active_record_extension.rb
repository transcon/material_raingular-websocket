require 'rails'
require 'active_record'
require 'websocket-rails'
module EmittableExtension
  extend ActiveSupport::Concern
  module ClassMethods
    def emittable
      @emittable = true
      after_save :emit_changes
      define_method(:emit_changes) {WebsocketRails.users.each{|user| user.send_message :change, websocket_message, namespace: websocket_namespace}}
      define_method(:websocket_message)   {self.as_json}
      define_method(:websocket_namespace) {"#{self.class.name.underscore}_#{self.id}".to_sym}
    end
    def emittable?() @emittable || false end
  end
  def emittable?() self.class.emittable? end
end
module UserManagerExtension
  def to_active_record() User.where(id: @users.keys.reject(&:blank?)) end
end
module WebsocketExtension
  def connected_users() users.to_active_record end
end
WebsocketRails::UserManager.send(:include, UserManagerExtension)
WebsocketRails.send(:extend, WebsocketExtension)
ActiveRecord::Base.send(:include, EmittableExtension)
