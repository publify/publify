require 'net/http'

begin
  Kernel.require 'sparklines'

  Sparklines # this will throw an exception if the require failed.

  class Typo
    class Textfilter
      class Sparkline < TextFilterPlugin::MacroPost
        plugin_public_action :plot
        plugin_display_name "Sparkline"
        plugin_description "Produce Sparklines"

        def self.help_text
        %{
You can use `<typo:sparkline>` to generate [Sparklines][], which are essentially small inline charts.
Example:

    <typo:sparkline data="5 10 15 20"/>

Options:

* **data** This is the data to be plotted.  You may also include the data between `<typo:sparkline>`
and `</typo:sparkline>` tags.
* **type** This is the type of sparkline to be generated.  Options include `area`, `discrete`, `pie`, and `smooth`.

For other options, see the [Ruby Sparkline][] website.

[Sparklines]: http://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001OR&topic_id=1&topic=
[Ruby Sparkline]: http://nubyonrails.topfunky.com/articles/2005/08/01/sparklines-now-gem-i-fied
}
        end

        def self.opt(attrib,optname)
          if(attrib[optname])
            " #{optname}=\"#{attrib.delete(optname)}\""
          else
            ''
          end
        end

        def self.macrofilter(controller,content,attrib,params,text="")
          img_opts = opt(attrib,'style') + opt(attrib,'alt') + opt(attrib,'title')
          data = text.to_s.split(/\s+/).join(',')

          if(attrib['data'])
            data = attrib.delete('data').to_s.split.join(',')
          end

          url = controller.url_for(
            {:controller => '/textfilter', :action => 'public_action', :filter => 'sparkline',
            :public_action => 'plot', :data => data}.update(attrib))

          "<img #{img_opts} src=\"#{url}\"/>"
        end

        # From the sparkline_controller that comes with sparklines.
        def plot
          ary = params['data'].split(',').collect { |i| i.to_i }
          params.delete('filename')

          if(params['type'] and not ['smooth', 'pie', 'discrete', 'area'].include?(params['type']))
            render :text => 'bad params', :status => 500
            return
          end

          fragmentname = @request.path+'?'+@request.parameters.keys.sort.collect {|k| "#{k}=#{@request.parameters[k]}"}.join('&amp;')
          fragment_cache = read_fragment(fragmentname)

          if(not fragment_cache)
            fragment_cache = Sparklines.plot(ary,params)
            write_fragment(fragmentname,fragment_cache)
          end

          send_data( fragment_cache,
                    :disposition => 'inline',
                    :type => 'image/png',
                    :filename => "spark_#{params[:type]}.png" )
        end

        # This is really just here for the unit test; we try to call it and
        # verify that plugin_public_action won't let the call through.
        def plot2
          render :text => ''
        end
      end
    end
  end
rescue LoadError
  # ignore load errors by not loading any of the library
end
