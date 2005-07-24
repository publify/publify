#!/usr/bin/env ruby
require 'lib/redcloth'
require 'yaml'

Dir["tests/*.yml"].each do |testfile|
    YAML::load_documents( File.open( testfile ) ) do |doc|
        if doc['in'] and doc['out']
            red = RedCloth.new( doc['in'] )
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
