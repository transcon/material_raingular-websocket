WebsocketRails::EventMap.describe do
  Dir.glob(Rails.root.join('app','live_controllers','*.rb')).each do |file|
    class_name = file.split('/').pop.split('.').shift.classify
    klass = class_name.constantize
    name = class_name.gsub('Websocket','').underscore.singularize.to_sym
    namespace name do
      (klass.instance_methods(false) - ['initialize_session'] ).each do |method|
        subscribe method.to_sym, to: klass, with_method: method.to_sym
      end
    end
  end
end
