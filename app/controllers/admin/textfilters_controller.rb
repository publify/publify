class Admin::TextfiltersController < Admin::BaseController
  def index
    list
    render :action => 'list'
  end

  def list
    @textfilters = TextFilter.find(:all, :order => "id DESC")
    @textfilter_map = TextFilter.filters_map
    @macros = TextFilter.available_filters.select { |filter| TextFilterPlugin::Macro > filter }
  end

  def show
    @textfilter = TextFilter.find(params[:id])
    @textfilters = TextFilter.filters_map
    @help_text = @textfilter.help
  end

  def show_help
    @textfilter = TextFilter.find(params[:id])
    @help_text = @textfilter.help
  end

  def macro_help
    @macro = TextFilter.available_filters.find { |filter| filter.short_name == params[:id] }
    @help_text = BlueCloth.new(@macro.help_text).to_html
  end

  def new
    @textfilter = TextFilter.new(params[:textfilter])
    @textfilter.filters ||= []
    @textfilter.params ||= {}

    setup_defaults

    if request.post?
      @textfilter.attributes = params[:textfilter]
      if params.has_key?(:filter)
        @textfilter.filters = params[:filter].keys.collect {|k| k.to_sym }
      end
      if request.post? and @textfilter.save
        flash[:notice] = 'TextFilter was successfully updated.'
        redirect_to :action => 'show', :id => @textfilter.id
      end
    end
  end

  def edit
    @textfilter = TextFilter.find(params[:id])

    setup_defaults

    if request.post?
      @textfilter.attributes = params[:textfilter]
      if params.has_key?(:filter)
        @textfilter.filters = params[:filter].keys.collect {|k| k.to_sym }
      end
      @textfilter.params = params[:params]
      if request.post? and @textfilter.save
        flash[:notice] = 'TextFilter was successfully updated.'
        redirect_to :action => 'show', :id => @textfilter.id
      end
    end
  end

  def destroy
    @textfilter = TextFilter.find(params[:id])
    if request.post?
      @textfilter.destroy
      redirect_to :action => 'list'
    end
  end

  def preview
    headers["Content-Type"] = "text/html; charset=utf-8"
    @textfilter = params[:textfilter]
    render :layout => false
  end

  private

  def setup_defaults
    types=TextFilter.available_filter_types

    @markup_options = types['markup'].collect {|f| [f.short_name, f.display_name]}.sort_by{|f| f[0]}
    @postprocess_options = types['postprocess'].collect do |f|
      [f.short_name, f.display_name, f.description, @textfilter.filters.include?(f.short_name.to_sym)]
    end.sort_by {|f| f[0]}

    @filterparams = Hash.new
    @filterdescriptions = Hash.new
    @filterhelp = Hash.new
    @filteroptions = Hash.new

    (types['macropre']+types['macropost']+types['postprocess']).each do |f|
      f.default_config.each do |key,value|
        @filterparams[key] = value[:default]
        @filterdescriptions[key] = value[:description]
        @filterhelp[key] = value[:help]
        @filteroptions[key] = value[:options]
      end
    end

    @filterparams.update(@textfilter.params)
  end
end
