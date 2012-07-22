require 'cgi'
require 'uri'
require 'bio/version'
require 'curb'
require 'nokogiri'

#
module BioChEMBL

  # ChEMBL Website
  def self.website
    "https://www.ebi.ac.uk/chembl/"
  end
  
  # Multi value utility
  #
  #   BioChEMBL.to_array(aTarget.synonyms) #=> []
  #
  def self.to_array(str)
    str.to_s.split('; ')
  end

end


require 'bio-chembl/chemblid.rb'
require 'bio-chembl/rest_client.rb'

require 'bio-chembl/datamodel.rb'
require 'bio-chembl/compound.rb'
require 'bio-chembl/target.rb'
require 'bio-chembl/assay.rb'
require 'bio-chembl/bioactivity.rb'

