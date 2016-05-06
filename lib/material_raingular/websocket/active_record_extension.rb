require 'rails'
require 'active_record'
require 'websocket-rails'
require 'material_raingular/websocket'
module EmittableExtension
  extend ActiveSupport::Concern
  module ClassMethods
    def emittable
      @emittable = true
      after_destroy :emit_destroyed
      after_save    :emit_changes
      def emittable?() @emittable || false end
    end
  end
  def emit_destroyed
    MaterialRaingular::Websocket::Emitter[websocket_namespace].publish(:destroy,destroy_message)
  end
  def emit_changes
    MaterialRaingular::Websocket::Emitter[websocket_namespace].publish(:change,websocket_message)
  end
  def websocket_message() self.to_json end
  def destroy_message() {id: self.id}.to_json end
  def websocket_namespace() self.class.name.underscore.to_sym end
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
