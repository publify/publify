#
# $Id: sanitize.rb 3 2005-04-05 12:51:14Z dwight $
#
# Copyright (c) 2005 Dwight Shih
# A derived work of the Perl version:
# Copyright (c) 2002 Brad Choate, bradchoate.com
# 
# Permission is hereby granted, free of charge, to
# any person obtaining a copy of this software and
# associated documentation files (the "Software"), to
# deal in the Software without restriction, including
# without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to
# whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission
# notice shall be included in all copies or
# substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
# OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
# OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

def sanitize( html, okTags='a href, b, br, i, p' )
  # no closing tag necessary for these
  soloTags = ["br","hr"]

  # Build hash of allowed tags with allowed attributes
  tags = okTags.downcase().split(',').collect!{ |s| s.split(' ') }
  allowed = Hash.new
  tags.each do |s|
    key = s.shift
    allowed[key] = s
  end

  # Analyze all <> elements
  stack = Array.new
  result = html.gsub( /(<.*?>)/m ) do | element |
    if element =~ /\A<\/(\w+)/ then
      # </tag>
      tag = $1.downcase
      if allowed.include?(tag) && stack.include?(tag) then
        # If allowed and on the stack
        # Then pop down the stack
        top = stack.pop
        out = "</#{top}>"
        until top == tag do
          top = stack.pop
          out << "</#{top}>"
        end
        out
      end
    elsif element =~ /\A<(\w+)\s*\/>/
      # <tag />
      tag = $1.downcase
      if allowed.include?(tag) then
        "<#{tag} />"
      end
    elsif element =~ /\A<(\w+)/ then
      # <tag ...>
      tag = $1.downcase
      if allowed.include?(tag) then
        if ! soloTags.include?(tag) then
          stack.push(tag)
        end
        if allowed[tag].length == 0 then
          # no allowed attributes
          "<#{tag}>"
        else
          # allowed attributes?
          out = "<#{tag}"
          while ( $' =~ /(\w+)=("[^"]+")/ )
            attr = $1.downcase
            valu = $2
            if allowed[tag].include?(attr) then
              out << " #{attr}=#{valu}"
            end
          end
          out << ">"
        end
      end
    end
  end
  
  # eat up unmatched leading >
  while result.sub!(/\A([^<]*)>/m) { $1 } do end
  
  # eat up unmatched trailing <
  while result.sub!(/<([^>]*)\Z/m) { $1 } do end
  
  # clean up the stack
  if stack.length > 0 then
    result << "</#{stack.reverse.join('></')}>"
  end

  result
end
