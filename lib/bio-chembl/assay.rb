require 'nokogiri'
require 'bio-chembl/datamodel.rb'
require 'bio-chembl/bioactivity.rb'


module BioChEMBL
  

  
  # ChEMBL Assay
  #
  # Data XML
  # <assay>
  #  <chemblId>CHEMBL1217643</chemblId>
  #  <assayType>B</assayType>
  #  <journal>Bioorg. Med. Chem. Lett.</journal>
  #  <assayOrganism>Homo sapiens</assayOrganism>
  #  <assayStrain>Unspecified</assayStrain>
  #  <assayDescription>Inhibition of human hERG</assayDescription>
  #  <numBioactivities>1</numBioactivities>
  # </assay>
  #
  # 
  class Assay
    extend BioChEMBL::DataModel
    
    ATTRIBUTES = [
      :chemblId,
      :assayType,
      :journal,
      :assayOrganism,
      :assayStrain,
      :assayDescription,
      :numBioactivities
      ]
      
    set_attr_accessors(ATTRIBUTES)

    
    def self.parse(str)
      case str
      when /^</
        format = 'xml'
      when /^\{/
        format = 'json'
      else
        raise ArgumentError, "Unexpected file format: #{str.inspect}" 
      end
      begin
        eval "self.parse_#{format}(str)"
      rescue 
        raise NoMethodError
      end  
    end 
    
    def self.parse_xml(str)
      xml = Nokogiri::XML(str)
      this = new  
      eval set_attr_values(ATTRIBUTES)
      this
    end 
    
    def self.parse_json(str)
      raise NotImplementedError
    end
    
    def self.parse_rdf(str)
      raise NotImplementedError
    end
    
    def self.find(chemblId)
      self.parse_xml(REST.new.assays(chemblId))
    end   
    
     
    # new
    def initialize(chemblId = nil)
      @chemblId = chemblId
    end 
    
    # Resolve the compound data by given ChEMBL ID
    def resolve
      resolved = self.class.find(@chemblId)
      ATTRIBUTES.each do |attr|
        eval "@#{attr} = resolved.#{attr}"
      end
    end
    
    # ChEMBL Bioactivity
    def bioactivities
      BioChEMBL::Bioactivity.parse_list_xml(REST.new.assays(@chemblId, 'bioactivities'))
    end
    
  end

end
