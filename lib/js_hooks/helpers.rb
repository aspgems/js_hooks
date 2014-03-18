module JsHooks
  module Helpers
    # Build the javascript code need to initialize the components js_hooks
    def javascript_hooks_tag
      javascript_tag <<-JS
        window.JsHooks = window.JsHooks || {};
        window.JsHooks.namespace = '.#{Rails.application.class.to_s.split('::').first}';
        window.JsHooks.hooks     = #{js_hooks.to_json};
      JS
    end
  end
end
