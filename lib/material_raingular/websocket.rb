require "material_raingular/websocket/version"
require "material_raingular/websocket/active_record_extension"
require "material_raingular/websocket/event_router.rb"

module MaterialRaingular
  module Websocket
    module Rails
      class Engine < ::Rails::Engine
      end
    end
  end
end
