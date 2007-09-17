require 'action_controller'
module ActionController
  module Resources
    class DatestampedResource < ::ActionController::Resources::Resource
      def path
        @path ||= "#{path_prefix}/#{plural}"
      end

      def member_path
        @member_path ||= path + "/:year/:month/:day/:id"
      end

      def nesting_path_prefix
        @nesting_path_prefix ||=
          "#{path}/:#{singular}_year/:#{singular}_month/:#{singular}_day/:#{singular}_id"
      end

      def install_in(map, &block)
        map.with_options(:controller => controller) do |m|
          install_new_actions_in(m)
          install_collection_actions_in(m)
          install_member_actions_in(m)
        end

        if block_given?
          map.with_options(:path_prefix => nesting_path_prefix) do |res|
            class << res
              def datestamped_resources
                raise "Can't nest datestamped_resources."
              end
            end
            block.call(res)
          end
        end
      end

      def install_new_actions_in(map)
        new_methods.each do |method, actions|
          actions.each do |action|
            map.with_options(action_options_for(action, method)) do |newmap|
              if action == :new
                newmap.named_route("#{name_prefix}new_#{singular}", new_path)
                newmap.named_route("formatted_#{name_prefix}new_#{singular}", new_path + ".:format")
              else
                map.named_route("#{name_prefix}#{action}_new_#{singular}", "#{new_path}/#{action}")
                map.named_route("formatted_#{name_prefix}#{action}_new_#{singular}",
                                "#{new_path}/#{action}.:format")
              end
            end
          end
        end
      end

      BY_YEAR_OPTIONS  = { :year => %r{\d{4}} }
      BY_MONTH_OPTIONS = BY_YEAR_OPTIONS.merge(:month => %r{(?:0?[1-9]|1[012])})
      BY_DAY_OPTIONS   = BY_MONTH_OPTIONS.merge(:day => %r{(?:0?[1-9]|[12]\d|3[01])})
      DATE_OPTIONS     = BY_DAY_OPTIONS

      def install_collection_actions_in(map)
        collection_methods.each do |method, actions|
          actions.each do |action|
            map.with_options(action_options_for(action, method)) do |m|
              m.named_route("#{name_prefix}#{action}_#{plural}",
                            "#{path}/#{action}")
              m.named_route("#{name_prefix}#{action}_#{plural}_by_year",
                            "#{path}/:year/#{action}", BY_YEAR_OPTIONS)
              m.named_route("#{name_prefix}#{action}_#{plural}_by_month",
                            "#{path}/:year/:month/#{action}", BY_MONTH_OPTIONS)
              m.named_route("#{name_prefix}#{action}_#{plural}_by_day",
                            "#{path}/:year/:month/:day/#{action}", BY_DAY_OPTIONS)

              m.named_route("formatted_#{name_prefix}#{action}_#{plural}",
                            "#{path}/#{action}.:format")
              m.named_route("formatted_#{name_prefix}#{action}_#{plural}_by_year",
                            "#{path}/:year/#{action}.:format", BY_YEAR_OPTIONS)
              m.named_route("formatted_#{name_prefix}#{action}_#{plural}_by_month",
                            "#{path}/:year/:month/#{action}.:format", BY_MONTH_OPTIONS)
              m.named_route("formatted_#{name_prefix}#{action}_#{plural}_by_day",
                            "#{path}/:year/:month/:day/#{action}.:format", BY_DAY_OPTIONS)
            end
          end
        end

        map.with_options(action_options_for("index")) do |index|
          index.named_route("#{name_prefix}#{plural}", path)
          index.named_route("#{name_prefix}#{plural}_by_year",
                            path + "/:year", BY_YEAR_OPTIONS)
          index.named_route("#{name_prefix}#{plural}_by_month",
                            path + "/:year/:month", BY_MONTH_OPTIONS)
          index.named_route("#{name_prefix}#{plural}_by_day",
                            path + "/:year/:month/:day", BY_DAY_OPTIONS)

          index.named_route("formatted_#{name_prefix}#{plural}", path + ".:format")
          index.named_route("formatted_#{name_prefix}#{plural}_by_year",
                            path + "/:year.:format", BY_YEAR_OPTIONS)
          index.named_route("formatted_#{name_prefix}#{plural}_by_month",
                            path + "/:year/:month.:format", BY_MONTH_OPTIONS)
          index.named_route("formatted_#{name_prefix}#{plural}_by_day",
                            path + "/:year/:month/:day.:format", BY_DAY_OPTIONS)
        end

        map.with_options(action_options_for("create")) do |create|
          create.connect(path)
          create.connect(path + ".:format")
        end
      end

      def install_member_actions_in(map)
        member_methods.each do |method, actions|
          actions.each do |action|
            map.with_options(action_options_for(action, method).merge(DATE_OPTIONS)) do |newmap|
              newmap.named_route("#{name_prefix}#{action}_#{singular}",
                                 "#{member_path}/#{action}")
              newmap.named_route("formatted_#{name_prefix}#{action}_#{singular}",
                                 "#{member_path}/#{action}.:format")
            end
          end
        end

        map.with_options(action_options_for("show")) do |show|
          show.named_route("#{name_prefix}#{singular}", member_path)
          show.named_route("formatted_#{name_prefix}#{singular}", "#{member_path}.:format")
        end
        %w{update destroy}.each do |value|
          map.with_options(action_options_for(value)) do |m|
            m.connect(member_path)
            m.connect("#{member_path}.:format")
          end
        end
      end

      def conditions_for(method)
        { :conditions => method == :any ? { } : { :method => method  } }
      end

      def action_options_for(action, method=nil)
        default_options = { :action => action.to_s }
        case default_options[:action]
        when "index", "new"; default_options.merge(conditions_for(method || :get))
        when "create"      ; default_options.merge(conditions_for(method || :post))
        when "show", "edit"
          default_options.merge(conditions_for(method || :get)).merge(DATE_OPTIONS)
        when "update"
          default_options.merge(conditions_for(method || :put)).merge(DATE_OPTIONS)
        when "destroy"
          default_options.merge(conditions_for(method || :delete)).merge(DATE_OPTIONS)
        else                 default_options.merge(conditions_for(method))
        end
      end
    end

    def datestamped_resources(*entities, &block)
      options = entities.last.is_a?(Hash) ? entities.pop : { }
      entities.each do |entity|
        resource = DatestampedResource.new(entities, options.dup)
        resource.install_in(self, &block)
      end
    end
  end
end

class ActionController::Routing::RouteSet
  class NamedRouteCollection
    def define_url_helper(route, name, kind, options)
      selector = url_helper_name(name, kind)

      # The segment keys used for positional paramters
      segment_keys = route.segments.collect do |segment|
        segment.key if segment.respond_to? :key
      end.compact
      hash_access_method = hash_access_name(name, kind)

      @module.send :module_eval, <<-end_eval # We use module_eval to avoid leaks
        def #{selector}(*args)
          opts = if args.empty? || Hash === args.first
            args.first || {}
          else
            # allow ordered parameters to be associated with corresponding
            # dynamic segments, so you can do
            #
            #   foo_url(bar, baz, bang)
            #
            # instead of
            #
            #   foo_url(:bar => bar, :baz => baz, :bang => bang)
            o = Hash === args.last ? args.pop : {}
            args.collect(&:to_param).flatten.zip(#{segment_keys.inspect}).inject({}) do |h, (v, k)|
              if Hash === v
                h.merge!(v)
              else
                h.merge!(k => v)
              end
            end.merge!(o)
          end
          url_for(#{hash_access_method}(opts))
        end
      end_eval
      @module.send(:protected, selector)
      helpers << selector
    end
  end
end
