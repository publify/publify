require 'fileutils'
require 'tmpdir'

class CkeditorController < ActionController::Base

  UPLOAD_FOLDER = "/files"
  UPLOAD_ROOT = ::Rails.root.to_s + "/public" + UPLOAD_FOLDER

  MIME_TYPES = [
    "image/jpg",
    "image/jpeg",
    "image/pjpeg",
    "image/gif",
    "image/png",
    "image/x-png",
    "application/x-shockwave-flash"
  ]

  ##############################################################################
  # XML Response string
  #
  RXML = <<-EOL
  xml.instruct!
    #=> <?xml version="1.0" encoding="utf-8" ?>
  xml.Connector("command" => params[:command], "resourceType" => 'File') do
    xml.CurrentFolder("url" => @ck_url, "path" => params[:currentFolder])
    xml.Folders do
      @folders.each do |folder|
        xml.Folder("name" => folder)
      end
    end if !@folders.nil?
    xml.Files do
      @files.keys.sort.each do |f|
        xml.File("name" => f, "size" => @files[f])
      end
    end if !@files.nil?
    xml.Error("number" => @errorNumber) if !@errorNumber.nil?
  end
  EOL

  ##############################################################################
  # figure out who needs to handle this request
  #
  def command
    if params[:command] == 'CheckAuthentication'
      return true
    end
    if params[:command] == 'GetFoldersAndFiles' || params[:command] == 'GetFolders'
      get_folders_and_files
    elsif params[:command] == 'CreateFolder'
      create_folder
    elsif params[:command] == 'FileUpload'
      upload_file
    end

    render :inline => RXML, :type => :rxml unless params[:command] == 'FileUpload'
  end

  def get_folders_and_files(include_files = true)
    @folders = Array.new
    @files = {}
    begin
      @ck_url = upload_directory_path
      @current_folder = current_directory_path
      Dir.entries(@current_folder).each do |entry|
        next if entry =~ /^\./
        path = @current_folder + entry
        @folders.push entry if FileTest.directory?(path)
        @files[entry] = (File.size(path) / 1024) if (include_files and FileTest.file?(path))
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
    end
  end

  def create_folder
    begin
      @ck_url = current_directory_path
      path = @ck_url + params[:newFolderName]
      if !(File.stat(@ck_url).writable?)
        @errorNumber = 103
      elsif params[:newFolderName] !~ /[\w\d\s]+/
        @errorNumber = 102
      elsif FileTest.exists?(path)
        @errorNumber = 101
      else
        Dir.mkdir(path,0775)
        @errorNumber = 0
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
    end
  end

  def upload_file
    begin
      load_file_from_params

      resource = Resource.create(:upload => @new_file, :mime => @ftype, :created_at => Time.now)
      #copy_tmp_file(@new_file) if mime_types_ok(@ftype)
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
    end

    render :text => %Q'
    <html>
      <body>
        <script type="text/javascript">
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, "#{resource.upload_url}");
        </script>
      </body>
    </html>'
  end

  def upload
    self.upload_file
  end

  #################################################################################
  #
  private

  def load_file_from_params
    @new_file = check_file(params[:upload])
    @ck_url  = upload_directory_path
    @ftype     = @new_file.content_type.strip
    log_upload
  end

  ##############################################################################
  # Chek if mime type is included in the MIME_TYPES
  #
  def mime_types_ok(ftype)
    mime_type_ok = MIME_TYPES.include?(ftype) ? true : false
    if mime_type_ok
      @errorNumber = 0
    else
      @errorNumber = 202
      raise_mime_type_and_show_msg(ftype)
    end
    mime_type_ok
  end

  ##############################################################################
  # Raise and exception, log the msg error and show msg
  #
  def raise_mime_type_and_show_msg(ftype)
    msg = "#{ftype} is invalid MIME type"
    puts msg;
    raise msg;
    log msg
  end

  ##############################################################################
  # Copy tmp file to current_directory_path/tmp_file.original_filename
  #
  def copy_tmp_file(tmp_file)
    path = current_directory_path + "/" + tmp_file.original_filename
    File.open(path, "wb", 0664) do |fp|
      FileUtils.copy_stream(tmp_file, fp)
    end
  end

  ##############################################################################
  # Puts a messgae info in the current log, only if ::Rails.env is 'development'
  #
  def log(str)
    ::Rails.logger.info str if ::Rails.env == 'development'
  end

  ##############################################################################
  # Puts some data in the current log
  #
  def log_upload
    log "CKEDITOR - #{params[:upload]}"
    log "CKEDITOR - UPLOAD_FOLDER: #{UPLOAD_FOLDER}"
    log "CKEDITOR - #{File.expand_path(::Rails.root.to_s)}/public#{UPLOAD_FOLDER}/" +
        "#{@new_file.original_filename}"
  end

  ##############################################################################
  # Returns the filesystem folder with the current folder
  #
  def current_directory_path
    base_dir = "#{UPLOAD_ROOT}/#{params[:type]}"
    Dir.mkdir(base_dir,0775) unless File.exists?(base_dir)
    check_path("#{base_dir}#{params[:currentFolder]}")
  end

  ##############################################################################
  # Returns the upload url folder with the current folder
  #
  # TODO: delete this?
  def upload_directory_path
    url_root = env["RAILS_RELATIVE_URL_ROOT"].to_s
    uploaded = url_root + "#{UPLOAD_FOLDER}/#{params[:Type]}"
    "#{uploaded}#{params[:currentFolder]}"
  end

  ##############################################################################
  # Current uploaded file path
  #
  # TODO : delete this?
  def uploaded_file_path
    @new_file.upload.url
  end

  ##############################################################################
  # check that the file is a tempfile object
  #
  def check_file(file)
    log "CKEDITOR ---- CLASS OF UPLOAD OBJECT: #{file.class}"
    unless [Tempfile, StringIO, ActionDispatch::Http::UploadedFile].include? file.class
      @errorNumber = 403
      throw Exception.new
    end
    file
  end

  def check_path(path)
    exp_path = File.expand_path path
    if exp_path !~ %r[^#{File.expand_path(UPLOAD_ROOT)}]
      @errorNumber = 403
      throw Exception.new
    end
    path
  end
end
