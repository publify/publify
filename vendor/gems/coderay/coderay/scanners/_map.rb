module CodeRay
module Scanners

  map :cpp => :c,
    :plain => :plaintext,
    :pascal => :delphi,
    :irb => :ruby,
    :xhtml => :nitro_xhtml,
    :javascript => :java_script,
    :nitro => :nitro_xhtml,
    :yml => :yaml

  default :plain

end
end
