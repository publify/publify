# --------------------------------------------------------------------------
# Portions of this code were taken from the "poignant.rb" script created
# by whytheluckystiff, which generates "Why's (Poignant) Guide to Ruby".
# The original script may be obtained from the poignant CVS repository,
# at http://poignant.rubyforge.org.
#
# This script is distributed under the by-sa/1.0 Creative Commons license.
# --------------------------------------------------------------------------

require 'erb'
require 'fileutils'
require 'yaml'
require 'redcloth'
require 'syntax/convertors/html'

module Syntax
  module Manual

    class Manual
      attr_accessor :product, :meta, :chapters, :tutorials, :examples, :recent_updates

      def Manual.load( file_name )
        File.open( file_name ) { |file| YAML.load( file ) }
      end
    end

    class Meta
      attr_accessor :copyright, :author, :email
    end

    class Product
      attr_accessor :name, :tagline, :version, :logo, :urls, :project
    end

    class Sidebar
      attr_accessor :title, :content
    end

    class Chapter
      attr_accessor :index, :title, :sections

      def initialize( index, title, sections )
        @index = index
        @title = title

        section_index = 0
        @sections = ( sections || [] ).collect do |section|
          section_index += 1
          if section.respond_to? :keys
            Section.new( section_index, section.keys.first, section.values.first )
          else
            section_index -= 1
            Section.new( section_index, nil, section )
          end
        end
      end

      def page_title
        "Chapter #{index}: #{title}"
      end
    end

    class Tutorial
      attr_accessor :index, :title, :brief, :intro, :steps, :summary

      def initialize( index, title, brief, intro, steps, summary )
        @index = index
        @title = title
        @brief = RedCloth.new( brief )
        @intro = RedCloth.new( intro ) if intro
        @summary = RedCloth.new( summary ) if summary
        @steps = steps.map { |step| RedCloth.new( step ) }
      end

      def page_title
        "Tutorial #{index}: #{title}"
      end
    end

    class Example
      attr_accessor :index, :title, :brief, :intro, :design, :implementation, :summary

      def initialize( index, title, brief, intro, design, implementation, summary )
        @index = index
        @title = title
        @brief = RedCloth.new( brief )
        @intro = RedCloth.new( intro )
        @design = RedCloth.new( design )
        @implementation = RedCloth.new( implementation )
        @summary = RedCloth.new( summary )
      end

      def page_title
        "Example #{index}: #{title}"
      end
    end

    class Section
      attr_accessor :index, :title, :content

      def initialize( index, title, content )
        @index = index
        @title = RedCloth.new( title ).to_html.gsub( %r{</?p>}, "" ) if title
        @content = FigureContainer.new( content || "" )
      end
    end

    class FigureContainer
      def initialize( content )
        @content = content
        @html = nil
      end

      def to_html
        return @html if @html
        extract_figures
        convert_to_html
        replace_figures
        @html
      end

      private

        Figure = Struct.new( :opts, :body )

        def extract_figures
          @figures = []
          @content.gsub!( /^\{\{\{(.*?)?\n(.*?)\n\}\}\}$/m ) do
            body = $2.strip
            opts = Hash[*$1.strip.split(/,/).map{|p| p.split(/=/)}.flatten]
            @figures << Figure.new( opts, body )
            "====#{@figures.length-1}===="
          end
        end

        def convert_to_html
          @html = ( @content.length < 1 ? "" :
            RedCloth.new( @content ).to_html )
        end

        def replace_figures
          @html.gsub!( /<p>====(.*?)====<\/p>/ ) do
            figure = @figures[$1.to_i]
            lang = figure.opts["lang"]
            caption = figure.opts["caption"] || "Figure"
            caption << " [#{lang}]" if lang

            body = figure.body

            if lang
              convertor = Syntax::Convertors::HTML.for_syntax( lang )

              body = "<link rel='stylesheet' type='text/css' " +
                     "href='stylesheets/#{lang}.css' />" +
                     "<div class='#{lang}'>" +
                     convertor.convert( body ) +
                     "</div>"
            end

            if figure.opts["number"] && eval(figure.opts["number"])
              line = 1
              numbers = ""
              body.each_line { numbers << "#{line}<br />"; line += 1 }
              body = "<table border='0' cellpadding='0' cellspacing='0'>" +
                     "<tr><td class='lineno'>#{numbers}</td>" +
                     "<td width='100%'>#{body}</td></tr></table>"
            end

            "<div class='figure'>\n" +
            "<span class='caption'>#{caption}</span>\n" +
            "<div class='body'>#{body}</div>" +
            "</div>"
          end
        end
    end

    YAML.add_private_type( 'file' ) { |type_id, value| File.read( value ) rescue "" }
    YAML.add_private_type( 'eval' ) { |type_id, value| eval( value ) }

    YAML.add_domain_type( 'jamisbuck.org,2004', 'manual' ) do |taguri, val|
      index = 0

      val['chapters'].collect! do |chapter|
        index += 1
        Chapter.new( index, chapter.keys.first, chapter.values.first )
      end

      index = 0
      ( val['tutorials'] ||= [] ).collect! do |tutorial|
        index += 1
        content = tutorial.values.first
        Tutorial.new( index, tutorial.keys.first, content['brief'], content['intro'],
                      content['steps'], content['summary'] )
      end

      index = 0
      ( val['examples'] ||= [] ).collect! do |example|
        index += 1
        content = example.values.first
        Example.new( index, example.keys.first, content['brief'], content['intro'], content['design'],
                     content['implementation'], content['summary'] )
      end

      YAML.object_maker( Manual, val )
    end

    YAML.add_domain_type( 'jamisbuck.org,2004', 'meta' ) do |taguri, val|
      YAML.object_maker( Meta, val )
    end

    YAML.add_domain_type( 'jamisbuck.org,2004', 'product' ) do |taguri, val|
      version = val["version"]
      if version.respond_to?( :type_id )
        if version.type_id == "version"
          if version.value =~ %r{(.*)/(.*)}
            require_file, constant = $1, $2
          else
            constant = version.value
          end

          require require_file if require_file
          val["version"] = eval(constant)
        else
          raise "Unexpected type: #{val.type_id}"
        end
      end
      YAML.object_maker( Product, val )
    end

    YAML.add_domain_type( 'jamisbuck.org,2004', 'sidebar' ) do |taguri, val|
      YAML.object_maker( Sidebar,
                         'title' => val.keys.first,
                         'content'=> RedCloth.new( val.values.first ) )
    end

  end
end

if __FILE__ == $0

  def log_action( action )
    $stderr.puts action
  end

  unless ( output_path = ARGV[0] )
    $stderr.puts "Usage: #{$0} [/path/to/save/html]"
    exit
  end

  FileUtils.mkdir_p File.join( output_path, "stylesheets" )

  log_action "Loading manual.yml..."
  manual = Syntax::Manual::Manual.load( 'manual.yml' )

  # force these to be defined at the TOPLEVEL_BINDING
  object = nil
  guts = nil

  page = File.open( "page.erb" ) { |file| ERB.new( file.read ) }
  page.filename = "page.erb"

  template = File.open( "index.erb" ) { |file| ERB.new( file.read ) }
  template.filename = "index.erb"

  File.open( File.join( output_path, "index.html" ), "w" ) do |file|
    guts = template.result
    file << page.result
  end

  template = File.open( "chapter.erb" ) { |file| ERB.new( file.read ) }
  template.filename = "chapter.erb"

  manual.chapters.each_with_index do |object,index|
    log_action "Processing chapter ##{object.index}..."

    previous_chapter = ( index < 1 ? nil : manual.chapters[index-1] )
    next_chapter = manual.chapters[index+1]

    File.open( File.join( output_path, "chapter-#{object.index}.html" ), "w" ) do |file|
      guts = template.result( binding )
      file << page.result( binding )
    end
  end

  template = File.open( "tutorial.erb" ) { |file| ERB.new( file.read ) }
  template.filename = "tutorial.erb"

  manual.tutorials.each do |object|
    log_action "Processing tutorial ##{object.index}..."
    File.open( File.join( output_path, "tutorial-#{object.index}.html" ), "w" ) do |file|
      guts = template.result
      file << page.result
    end
  end

#  template = File.open( "example.erb" ) { |file| ERB.new( file.read ) }
#  template.filename = "example.erb"

#  manual.examples.each do |object|
#    log_action "Processing example ##{object.index}..."
#    File.open( File.join( output_path, "example-#{object.index}.html" ), "w" ) do |file|
#      guts = template.result
#      file << page.result
#    end
#  end

  log_action "Copying style sheets..."
  FileUtils.cp Dir["stylesheets/*.css"], File.join( output_path, "stylesheets" )

  log_action "Done!"
end
