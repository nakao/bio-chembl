require 'nokogiri'
require 'bio-chembl/datamodel.rb'
require 'bio-chembl/bioactivity.rb'

module BioChEMBL
  
  # ChEMBL Target
  #
  # Data XML
  # <target>
  #  <chemblId>CHEMBL1785</chemblId>
  #  <targetType>PROTEIN</targetType>
  #  <preferredName>Endothelin receptor ET-B</preferredName>
  #  <proteinAccession>P24530</proteinAccession>
  #  <synonyms>Endothelin B receptor; Endothelin receptor non-selective type; ET-B; ET-BR</synonyms>
  #  <organism>Homo sapiens</organism>
  #  <description>Endothelin B receptor</description>
  #  <geneNames>EDNRB; ETRB</geneNames>
  # </target>
  #
  class Target
    extend BioChEMBL::DataModel
    
    ATTRIBUTES = [
      :chemblId,
      :targetType,
      :preferredName,
      :proteinAccession,
      :synonyms,
      :organism,
      :description,
      :geneNames
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

    # XML
    # <list><target> ...
    def self.parse_list_xml(str)
      xmls = Nokogiri::XML(str)
      xmls.xpath("/list/target").map do |cpd|
        self.parse_xml(cpd.to_s)
      end
    end
    
    def self.parse_json(str)
      raise NotImplementedError
    end

    def self.parse_rdf(str)
      raise NotImplementedError
    end   
    
    def self.find(chemblId)
      self.parse_xml(REST.new.targets(chemblId))
    end
    
    def self.find_by_uniprot(uniprot_id)
      self.parse_xml(REST.new.targets_uniprot(uniprot_id))      
    end

    def self.find_by_refseq(refseq_id)
      self.parse_xml(REST.new.targets_refseq(refseq_id))            
    end
    
    # bioactivities => [aBioactivity, ...]
    def bioactivities
      BioChEMBL::Bioactivity.parse_list_xml(REST.new.targets(chemblId, 'bioactivities'))
    end
    
    # Resolve the target data by given ChEMBL ID => aTarget
    def resolve
      resolved = self.class.find(@chemblId)
      ATTRIBUTES.each do |attr|
        eval "@#{attr} = resolved.#{attr}"
      end
    end
  end

end
