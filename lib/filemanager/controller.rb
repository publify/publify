=begin
  controller.rb
  Copyright (C) 2008  Leon Li

  You may redistribute it and/or modify it under the same
  license terms as Ruby.
=end
module Filemanager
  module Controller
		def set_up
	    @lock_path = FM_LOCK_PATH
	    @source = params[:source]
	    @source = decode(@source) unless @source.nil?
	    @path = (params[:path].nil? || ! params[:path].index('..').nil?) ? '' : params[:path]
	    @path = '' if @path == '/'
	    @path = decode(@path)
	    @resource_path = FM_RESOURCES_PATH
	    @current_path = @resource_path + @path
	    @current_file = (File.directory?(@current_path) ? Dir.new(@current_path) : File.new(@current_path))
	    @parent_path = (!@path.blank? && !@path.rindex('/').nil?) ? (@path.rindex('/') == 0 ? '/' : @path[0..(@path.rindex('/')-1)]) : nil
	    @path_suffix = @path.index('.').nil? || @path[-1] == '.' ? '' : @path[@path.index('.')+1..-1].downcase
	    if File.directory?(@current_path)
	      @all_files = Dir.entries(@current_path)
	      @directories = @all_files.map{|f| File.directory?(@current_path + File::SEPARATOR + f) ? f : nil}.compact
	      @files = @all_files.map{|f| File.directory?(@current_path + File::SEPARATOR + f) ? nil : f}.compact
	      @file_total_size = @files.inject(0){|size, f| size + File.size(@current_path + File::SEPARATOR + f)}
	    end
	  end

	  def tear_off
	    @current_file.close unless @current_file.nil?
	  end

	  def index

	  end

	  def view
	    #    respond_to do |wants|
	    #      wants.js {  render :text => File.size(@current_path) > 1000000 ? 'File too big' : File.read(@current_path) }
	    #    end
	  end

	  def file_content
	      File.size(@current_path) > 1000000 ? 'File too big' : File.read(@current_path)
	  end

	#  def office
	#    render :action=>'excel' if is_excel?
	#    render :action=>'word' if is_word?
	#    render :action=>'ppt' if is_ppt?
	#    render :action=>'help' if is_help?
	#  end

	  def rename
	    old_name = @current_path + File::SEPARATOR + decode(params[:old_name])
	    new_name = @current_path + File::SEPARATOR + decode(params[:new_name])
	    File.rename(old_name, new_name)
	    success
	  end

	  def remove
	    FileUtils.rm_rf(@source.map{|s| @current_path + File::SEPARATOR + s})
	    success
	  end

	  def new_file
	    File.new(@current_path + File::SEPARATOR + decode(params[:new_name]), 'w')
	    success
	  end

	  def new_folder
	    Dir.mkdir(@current_path + File::SEPARATOR + decode(params[:new_name]))
	    success
	  end

	  def copy
	    session[:source] = @source.map{|s| @current_path + File::SEPARATOR + s}
	    session[:remove] = false
	    success
	  end

	  def cut
	    session[:source] = @source.map{|s| @current_path + File::SEPARATOR + s}
	    session[:remove] = true
	    success
	  end

	  def paste
	    return error if session[:remove].nil? || session[:source].nil?
	    begin
	      session[:remove] == true ? FileUtils.mv(session[:source], @current_path) : FileUtils.cp_r(session[:source], @current_path)
	      session[:remove] = nil
	      session[:source] = nil
	      success
	    rescue => exception
	      result(exception)
	    end

	  end

	  def download
	    now = Time.new
	    now = "#{now.to_i}#{now.usec}"
	    temp_file = FM_TEMP_DIR + File::SEPARATOR + now + '.zip'
	    FileUtils.cd(@current_path) do |dir|
	      system "zip -r #{temp_file} #{@source.map{|s| '"' + s + '"'}.join(' ')}"
	    end
	    send_file(temp_file)
	  end


	  def upload
	    file = params[:upload]
	    filename = decode(file.original_filename)
	    File.open(@current_path + File::SEPARATOR + filename, "wb") do |f|
	      f.write(file.read)
	    end
	    to_index
	  end



	  #TODO
	  def adjust_size

	  end

	  #TODO
	  def rotate

	  end

	  #TODO
	  def unzip
	    filename = decode(params[:old_name])
	    FileUtils.cd(@current_path) do |dir|
	      system "unzip -o #{filename}"
	    end
	    to_index
	  end

	  def to_index
	    redirect_to :action => 'index', :path => encode(@path)
	  end

	  def success
	    result("SUCCESS")
	  end

	  def error()
	    result("ERROR")
	  end

	  def result(message)
	    respond_to do |wants|
	      wants.js { render :text => message }
	    end
	  end

	  #methods for view
	  def method_missing(method_id, *args)
	    method_id_s = method_id.to_s
	    if method_id_s[0, 3] == 'is_' && method_id_s[-1, 1] == '?'
	      instance_eval %{
	                        def #{method_id}(*args)
	                          FM_#{method_id_s[3..-2].upcase}_TYPES.include?(@path_suffix)
	                        end
	                      }
	      send(method_id, *args)
	    else
	      super
	    end
	  end

	  def transfer(from, to, target)
	    if FM_ENCODING_TO.nil?
	      target
	    else
	      if target.is_a?(Array)
	        target.map{|i| to.nil? ? i : Iconv.conv(to, from, i)}
	      else
	        Iconv.conv(to, from, target)
	      end
	    end
	  end

	  def encode(target)
	    transfer(FM_ENCODING_FROM, FM_ENCODING_TO, target);
	  end

	  def decode(target)
	    transfer(FM_ENCODING_TO, FM_ENCODING_FROM, target);
	  end

    def hsize(size)
      size = size/1024
      if size > 1024
        size = size/1024
        size = format('%0.2f',(size)) + ' mb'
      else
        size = format('%0.2f', size) + ' kb'
      end
    end

    def get_file_type(file)
      type = File.extname(file)

      unless type.blank?
        type = type.downcase[1..-1]
        return type if FM_SUPPORT_TYPES.include?(type)
      end
      FM_UNKNOWN_TYPE
    end

  end
end
