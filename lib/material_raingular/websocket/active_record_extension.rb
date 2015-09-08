require 'rails'
require 'active_record'
require 'websocket-rails'
module EmittableExtension
  extend ActiveSupport::Concern
  module ClassMethods
    def emittable
      @emittable = true
      after_save :emit_changes
    end
    def emittable?() @emittable || false end
  end
  def emit_changes
    return unless emittable?
    WebsocketRails[websocket_namespace].trigger(:change, websocket_message) if WebsocketRails[websocket_namespace].subscribers.present?
  end
  def websocket_message
    return unless emittable?
    self.to_json
  end
  def websocket_namespace
    return unless emittable?
    self.class.name.underscore.to_sym
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
