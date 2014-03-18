module JsHooks
  class Railtie < Rails::Railtie
    initializer 'js_hooks.initialize' do
      ActiveSupport.on_load :action_controller do
        require 'js_hooks/controller'
        include JsHooks::Controller
      end

      ActiveSupport.on_load :action_view do
        require 'js_hooks/helpers'
        include JsHooks::Helpers
      end
    end
  end

  # Needed for assets pipeline
  class Engine < Rails::Engine
  end
end
