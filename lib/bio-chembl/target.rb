require 'nokogiri'
require 'bio-chembl/datamodel.rb'
require 'bio-chembl/bioactivity.rb'

module BioChEMBL
  
  # ChEMBL Target parser and container.
  #
  # Data XML
  #
  #  <target>
  #    <chemblId>CHEMBL1785</chemblId>
  #    <targetType>PROTEIN</targetType>
  #    <preferredName>Endothelin receptor ET-B</preferredName>
  #    <proteinAccession>P24530</proteinAccession>
  #    <synonyms>Endothelin B receptor; Endothelin receptor non-selective type; ET-B; ET-BR</synonyms>
  #    <organism>Homo sapiens</organism>
  #    <description>Endothelin B receptor</description>
  #    <geneNames>EDNRB; ETRB</geneNames>
  #  </target>
  #
  # Usage
  # 
  #  target = BioChEMBL::Target.find("CHEMBL1785")
  #  target.geneNames
  #  BioChEMBL.to_array(target.geneNames)[0] #=> "EDNRB"
  #  
  #  bioactivities = target.bioactivities
  #   
  #  target = BioChEMBL::Target.find_by_uniprot("P24530")
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
    
    # Parse the Target data.
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
    
    # Parse the Target data in XML format.
    def self.parse_xml(str)
      xml = Nokogiri::XML(str)
      this = new  
      eval set_attr_values(ATTRIBUTES)
      this
    end 

    # Parse the Target data list in XML format.
    # data lsit: <list><target/></list>
    def self.parse_list_xml(str)
      xmls = Nokogiri::XML(str)
      xmls.xpath("/list/target").map do |cpd|
        self.parse_xml(cpd.to_s)
      end
    end
    
    # Parse the Target data in JSON format.
    def self.parse_json(str)
      raise NotImplementedError
    end

    # Parse the Target data in RDF format.
    def self.parse_rdf(str)
      raise NotImplementedError
    end   
    
    # Find the Target data by the ChEMBL ID.
    def self.find(chemblId)
      self.parse_xml(REST.new.targets(chemblId))
    end
    
    # Find the Target data by the UniProt ID.
    def self.find_by_uniprot(uniprot_id)
      self.parse_xml(REST.new.targets_uniprot(uniprot_id))      
    end

    # Find the Target data by the RefSeq ID.
    def self.find_by_refseq(refseq_id)
      self.parse_xml(REST.new.targets_refseq(refseq_id))            
    end
    
    # Get the bioactivity data list.
    def bioactivities
      BioChEMBL::Bioactivity.parse_list_xml(REST.new.targets(chemblId, 'bioactivities'))
    end
    
    # Resolve the Target data by the ChEMBL ID
    def resolve
      resolved = self.class.find(@chemblId)
      ATTRIBUTES.each do |attr|
        eval "@#{attr} = resolved.#{attr}"
      end
    end
    
  end

end
