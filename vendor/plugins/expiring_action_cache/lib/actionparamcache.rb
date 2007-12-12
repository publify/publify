module ActionController
  class AbstractResponse

    # This isn't just +attr_accessor :lifetime+ because we need to trick components into doing
    # the right thing--it should be possible to do +lifetime = 1.hour+ in a component and have
    # the lifetime carried back to the original response.  Unfortunately, components are called
    # with their own copy of the parent's response object.  Fortunately, the copy uses
    # +dup+, so if we shove the actual lifetime into a hash (or anything even slighty complex),
    # the +dup+ will leave the parent response and the child response sharing the same
    # hash, so the lifetime will become a shared resource and The Right Thing will happen.
    def lifetime
      @lifetime[:time]
    end
    
    def lifetime=(seconds)
      # Only allow the lifetime to be lowered--if one component wants 
      # lifetime=3.hours and another wants lifetime=15.minutes, then
      # the right thing to do is to always use lifetime=15.minutes, no
      # matter which order they're called in.
      return if @lifetime[:time] and @lifetime[:time] < seconds
      @lifetime[:time] = seconds
    end
    
    def initialize
      @body, @headers, @session, @assigns = "", DEFAULT_HEADERS.merge("cookie" => []), [], []
      @lifetime = Hash.new
    end
  end
  
  module Caching
    module ActionParams
      def self.append_features(base) #:nodoc:
        super
        base.extend(ClassMethods)
        base.send(:attr_accessor, :rendered_action_cache)
      end

      module ClassMethods #:nodoc:
        def caches_action_with_params(*actions)
          return unless perform_caching
          prepend_around_filter(ActionParamCacheFilter.new(*actions))
        end
      end

      def expire_action_with_params(options = {})
        return unless perform_caching
        
        if options == {}
          expire_meta_fragment(%r{ACTION_PARAM/.*})
        else
          controller = options[:controller] || '[^/]+'
          action = options[:action] || '[^/]+'
          keys = (options.reject {|k,v| v.blank?}.keys-[:controller,:action]).sort_by {|k| k.to_s}
          param_string = keys.collect { |key| "#{key.to_s}=#{controller.params[key]}"}.join('.*')
          expire_meta_fragment(%r{ACTION_PARAM/[^/]+/#{controller}/#{action}/#{param_string}})
        end
      end

      class ActionParamCacheFilter #:nodoc:
        def initialize(*actions)
          @actions = actions
        end

        def cache_key(controller)
          hostname = controller.request.host_with_port
          keys = (controller.params.reject {|k,v| v.blank?}.keys-['controller','action']).sort
          param_string = keys.collect { |key| "#{key.to_s}=#{controller.params[key]}"}.join('&')
          "ACTION_PARAM/#{hostname}/#{controller.controller_name}/#{controller.action_name}/#{param_string}"
        end

        def before(controller)
          return unless @actions.include?(controller.action_name.intern)
          meta, cache = controller.read_meta_fragment_expire(cache_key(controller))
          
          if cache
            # 304 handling from Tom Fakes,
            # http://craz8.com/svn/trunk/plugins/action_cache/lib/action_cache.rb
            request_time = Time.rfc2822(controller.request.env["HTTP_IF_MODIFIED_SINCE"]).utc rescue nil
            cached_time = meta[:cached_at] rescue nil
            controller.response.headers['Cache-Control'] = 'max-age=1'
            controller.response.headers['Last-Modified'] = meta[:cached_at].httpdate rescue nil
            controller.response.headers['Content-Type'] = meta[:content_type]
                        
            if request_time and cached_time <= (request_time + 1)
              controller.send(:render, :text => "", :status => 304)
            else
              controller.send(:render, :text => cache)
            end
            
            controller.rendered_action_cache = true
            return false
          else
            return true
          end
        end

        def after(controller)
          return true if !@actions.include?(controller.action_name.intern) || controller.rendered_action_cache
          return true if controller.response.headers['Status'] != "200 OK" # without this, we cache errors.  grr

          meta = Hash.new
          if controller.response.lifetime
            meta[:expires] = Time.now + controller.response.lifetime
          end
          meta[:cached_at] = Time.now.utc
          meta[:content_type] = controller.response.headers['Content-Type']
          controller.response.headers['Cache-Control'] = 'max-age=1'
          controller.response.headers['Last-Modified'] = meta[:cached_at].httpdate
          controller.write_meta_fragment(cache_key(controller), meta, controller.response.body)
        end
      end
    end
  end
end

ActionController::Caching::ActionParams.append_features(ActionController::Base)
