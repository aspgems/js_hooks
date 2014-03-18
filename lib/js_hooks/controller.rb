require 'abstract_controller/helpers'

module JsHooks
  module Controller
    PREFIX = 'init'
    extend ActiveSupport::Concern

    module ClassMethods
      def act_as_js_hookable(options = {})
        before_filter :add_default_js_hooks if :add_default_js_hooks?

        include JsHooks::Controller::LocalInstanceMethods

        helper_method :js_hooks, :add_js_hook
      end
    end

    module LocalInstanceMethods
      # Javascript on demand hooks
      def js_hooks
        @js_hooks ||= {}
      end

      # Add javascript components to execute inside a document ready jquery closure before the body close tag in your
      # templates. For each hook added, an object with the same name is searched and the init method is called.
      # A suffix can be used with the init method to refine the initialization process:
      #
      #     add_js_hook( :users, :clients )
      #       --> Users.init(); Clients.init()
      #
      #     add_js_hook( :users, :clients, users: 'action' )
      #       --> Users.init(); Clients.init(); Users.initAction();
      #
      #     add_js_hook( :clients, users: [:default, 'action1', 'action2'] )
      #       --> Clients.init(); Users.init(); Users.initAction1(); Users.initAction2();
      #
      # Three hooks are added by default: one with 'application' as name, one with the controller as name and one last
      # with the controller as name and template as suffix.
      # So, by default, the following methods will be called if they exist:
      #
      #     GET /users/1 --> Application.init(); Users.init(); Users.initShow()
      #
      # A hook can be deleted by passing a false value as suffix
      #     GET /users/1
      #     add_js_hook( :clients, users: false)
      #       --> Application.init(); Clients.init();
      def add_js_hook(*args)
        opts = args.extract_options!

        # Default init method
        args.each do |hook|
          hook = hook.to_s.camelize
          js_hooks[hook] ||= []
          js_hooks[hook] = (js_hooks[hook] + [PREFIX]).uniq
        end

        # Suffix init method
        opts.each_pair do |hook, methods|
          hook = hook.to_s.camelize
          js_hooks[hook] ||= []
          remove_default = false
          if methods
            methods = [methods].flatten.map! do |m|
              remove_default ||= !m
              m = '' if m == :default
              "#{PREFIX}#{m.to_s.camelize}"
            end
            js_hooks[hook] = (js_hooks[hook] + methods).uniq
            js_hooks[hook].delete(PREFIX) if remove_default
          else
            js_hooks.delete(hook)
          end
        end
      end

      private
      def add_default_js_hooks
        add_js_hook :application
        add_js_hook controller_name
      end

      # Add template as suffix to the controller hook: GET users/1 -> Users.initShow()
      def render_to_body(options = {})
        add_js_hook controller_name => options[:template].to_s.camelize if options[:template] && add_default_js_hooks?
        super
      end

      def add_default_js_hooks?
        request.format.html?
      end
    end
  end
end
