class Redirection < ActiveRecord::Base
  belongs_to :article
  belongs_to :redirect
end
