require 'nokogiri'
require 'bio-chembl/datamodel.rb'

module BioChEMBL
  
  # ChEMBL Compound Data Container and Parser
  #
  # XML Data string
  # <compound>
  #  <chemblId>CHEMBL1</chemblId>
  #  <knownDrug>No</knownDrug>
  #  <medChemFriendly>Yes</medChemFriendly>
  #  <passesRuleOfThree>No</passesRuleOfThree>
  #  <molecularFormula>C32H32O8</molecularFormula>
  #  <smiles>COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56</smiles>
  #  <stdInChiKey>GHBOEFUAGSHXPO-XZOTUCIWSA-N</stdInChiKey>
  #  <numRo5Violations>1</numRo5Violations>
  #  <rotatableBonds>2</rotatableBonds>
  #  <molecularWeight>544.59167</molecularWeight>
  #  <alogp>3.627</alogp>
  #  <acdLogp>7.669</acdLogp>
  #  <acdLogd>7.669</acdLogd>
  # </compound>
  #
  # Usage
  # ```cpd = BioChEMBL::Compound.find("CHEMBL1")
  #    cpd.chemblId #=> "CHEMLB1"
  #    cpd.smiles
  #
  #    cpd2 = BioChEMBL::Compound.find_all_by_smiles(cpd.smile)
  #
  #    cpd3 = BioChEMBL::Compound.parse(xml)
  # ```
  class Compound
    extend BioChEMBL::DataModel

    ATTRIBUTES =  [ 
      :chemblId, 
      :knownDrug,
      :medChemFriendly,
      :passesRuleOfThree,
      :molecularFormula,
      :smiles,
      :stdInChiKey,
      :species,
      :numRo5Violations,
      :rotatableBonds,
      :molecularWeight,
      :alogp,
      :acdAcidicPka,
      :acdLogp,
      :acdLogd 
    ]
      
    # aBioChEMBL::Compound instance have attribute accessors.
    # Values of all attributes are in String.
    set_attr_accessors(ATTRIBUTES)
    
    #
    # BioChEMBL::Compound.parse(doc)
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
    
    # XML 
    # <compound>
    def self.parse_xml(str)
      xml = Nokogiri::XML(str)
      this = new  
      eval set_attr_values(ATTRIBUTES)
      this
    end 
    
    # XML
    # <list><compound> ...
    def self.parse_list_xml(str)
      xmls = Nokogiri::XML(str)
      xmls.xpath("/list/compound").map do |cpd|
        self.parse_xml(cpd.to_s)
      end
    end 

    # JSON
    def self.parse_json(str)
      raise NotImplementedError
    end

    # RDF
    def self.parse_rdf(str)
      raise NotImplementedError
    end   
    
    
    # Compound.find(chemblId)
    # Find a compound data by a ChEMBL ID
    def self.find(chemblId)
      self.parse_xml(REST.new.compounds(chemblId))
    end 

    # Compound.find_by_smiles(smiles)
    # Find a compound data by a SMILES
    def self.find_by_smiles(smiles)
      self.find_all_by_smiles(smiles).first
    end 

    # Compound.find_all_by_smiles(smiles)
    # Find compounds by a SMILES.
    def self.find_all_by_smiles(smiles)
      self.parse_list_xml(REST.new.compounds_smiles(smiles))
    end 

    # Compound.find_by_stdinchikey(stdinchikey)
    # Find a compound data by a StdInChiKey
    def self.find_by_stdinchikey(stdinchikey)
      self.parse_xml(REST.new.compounds_stdinchikey(stdinchikey))
    end 

    # Compound.find_all_by_substructure(smiles)
    # Substructure Search by a SMILES
    def self.find_all_by_substructure(smiles)
      self.parse_list_xml(REST.new.compounds_substructure(smiles))
    end 
    
    # Compound.find_similarity(smiles_with_similarity)
    # Search compounds by a SMILES with similarity
    def self.find_all_by_similarity(smiles_with_similarity)
      self.parse_list_xml(REST.new.compounds_similarity(smiles_with_similarity))
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
  end
  
end
