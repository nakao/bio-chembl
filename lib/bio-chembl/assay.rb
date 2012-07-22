require 'nokogiri'
require 'bio-chembl/datamodel.rb'
require 'bio-chembl/bioactivity.rb'


module BioChEMBL
  
  # ChEMBL Assay Data parser and container.
  #  
  # Data XML
  #
  #  <assay>
  #    <chemblId>CHEMBL1217643</chemblId>
  #    <assayType>B</assayType>
  #    <journal>Bioorg. Med. Chem. Lett.</journal>
  #    <assayOrganism>Homo sapiens</assayOrganism>
  #    <assayStrain>Unspecified</assayStrain>
  #    <assayDescription>Inhibition of human hERG</assayDescription>
  #    <numBioactivities>1</numBioactivities>
  #  </assay>
  #
  # Usage
  #
  #   assay = BioChEMBL::Assay.find("CHEMBL1217643")
  #   assay.assayType
  #   assay.assayOrganism
  #   ba = assay.bioactivities
  #
  #   assay = BioChEMBL::Assay.new("CHEMBL1217643")
  #   assay.assayType #=> nil
  #   assay.resolve
  #   assay.assayType #=> "B"
  #
  #   xml = BioChEMBL::REST.new.assays("CHEMBL1217643")
  #   assay = BioChEMBL::Assay.parse_xml(xml)
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

    #  Parse the assay data.
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
    
    # Parse the assay data in XML format.
    def self.parse_xml(str)
      xml = Nokogiri::XML(str)
      this = new  
      eval set_attr_values(ATTRIBUTES)
      this
    end 
    
    # Parse the assay data in JSON format.
    def self.parse_json(str)
      raise NotImplementedError
    end
    
    # Parse the assay data in RDF format.
    def self.parse_rdf(str)
      raise NotImplementedError
    end
    
    # Find the assay data by ChEMBL ID via the web service.
    def self.find(chemblId)
      self.parse_xml(REST.new.assays(chemblId))
    end   
    
     
    # Create a blank Assay instance.
    def initialize(chemblId = nil)
      @chemblId = chemblId
    end 
    
    # Resolve the assay data by given ChEMBL ID
    def resolve
      resolved = self.class.find(@chemblId)
      ATTRIBUTES.each do |attr|
        eval "@#{attr} = resolved.#{attr}"
      end
    end
    
    # Find the Bioactivity data by the assay.
    def bioactivities
      BioChEMBL::Bioactivity.parse_list_xml(REST.new.assays(@chemblId, 'bioactivities'))
    end
    
  end

end
