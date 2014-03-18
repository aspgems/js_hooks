/*jshint nonew:true, jquery:true, curly:true, noarg:true, forin:true, noempty:true, eqeqeq:true, strict:true, undef:true, bitwise:true, browser:true */

(function () {
  'use strict';

  function registerHook(hookClass, hooks) {
    window.JsHooks[hookClass] = hooks;

  }

  function initHooks() {
    var jsHooks = window.JsHooks;

    // Remove all events added by the previous turbolinks page
    if(jsHooks.namespace) {
      $(document).off(jsHooks.namespace);
    }

    var hooks = jsHooks.hooks;
    for (var hookClass in hooks) {
      if(hooks.hasOwnProperty(hookClass)) {
        var hook = jsHooks[hookClass];
        if (!hook) {
          continue;
        }

        var methods = hooks[hookClass];
        if (!$.isArray(methods)) {
          methods = ['']; // invoke the default .init() method
        }

        for (var i = 0; i < methods.length; i++) {
          var method = methods[i];
          if (method === true) {
            method = '';
          } else if (method === false) {
            continue;
          }
          method = 'init' + method;

          if ($.isFunction(hook[method])) {
            // if(console && console.debug) console.debug('Calling ' + hookClass + '.' + method + '();');
            hook[method]();
          }
        }
      }
    }
  }

  // Set initializer only once
  if (!window.JsHooks || !window.JsHooks.initialized) {
    $(document).ready(initHooks).on('page:load', initHooks);
  }

  window.JsHooks = window.JsHooks || {};
  window.JsHooks.initialized = true;
  window.JsHooks.registerHook = registerHook;
})();

