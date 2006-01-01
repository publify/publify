#!/usr/bin/env ruby
require 'lib/redcloth'
require 'yaml'

Dir["tests/*.yml"].each do |testfile|
    YAML::load_documents( File.open( testfile ) ) do |doc|
        if doc['in'] and doc['out']
            opts = []
            opts << :hard_breaks if testfile =~ /hard_breaks/
            red = RedCloth.new( doc['in'], opts )
            html = if testfile =~ /markdown/
                       red.to_html( :markdown )
                   else
                       red.to_html
                   end
            puts "---"

            html.gsub!( /\n+/, "\n" )
            doc['out'].gsub!( /\n+/, "\n" )
            if html == doc['out']
                puts "success: true"
            else
                puts "out: "; p html
                puts "expected: "; p doc['out']
            end
        end
    end
end
