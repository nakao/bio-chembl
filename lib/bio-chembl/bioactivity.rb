require 'nokogiri'
require 'bio-chembl/datamodel.rb'


module BioChEMBL

  # BioChEMBL::Bioactivity
  #
  # Data XML
  # <list>
  #   <bioactivity>
  #     <parent__cmpd__chemblid>CHEMBL1214402</parent__cmpd__chemblid>
  #     <ingredient__cmpd__chemblid>CHEMBL1214402</ingredient__cmpd__chemblid>
  #     <target__chemblid>CHEMBL240</target__chemblid>
  #     <target__confidence>9</target__confidence>
  #     <target__name>HERG</target__name>
  #     <reference>Bioorg. Med. Chem. Lett., (2010) 20:15:4359</reference>
  #     <name__in__reference>26</name__in__reference>
  #     <organism>Homo sapiens</organism>
  #     <bioactivity__type>IC50</bioactivity__type>
  #     <activity__comment>Unspecified</activity__comment>
  #     <operator>=</operator>
  #     <units>nM</units>
  #     <assay__chemblid>CHEMBL1217643</assay__chemblid>
  #     <assay__type>B</assay__type>
  #     <assay__description>Inhibition of human hERG</assay__description>
  #     <value>5900</value>
  #   </bioactivity>
  # </list>
  #
  # Usage
  # 
  class Bioactivity
    extend BioChEMBL::DataModel
      
    ATTRIBUTES = [
          :parent__cmpd__chemblid,
          :ingredient__cmpd__chemblid,
          :target__chemblid,
          :target__confidence,
          :target__name,
          :reference,
          :name__in__reference,
          :organism,
          :bioactivity__type,
          :activity__comment,
          :operator,
          :units,
          :assay__chemblid,
          :assay__type,
          :assay__description,
          :value
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
    # <list><bioactivity> ...
    def self.parse_list_xml(str)
      xmls = Nokogiri::XML(str)
      xmls.xpath("/list/bioactivity").map do |cpd|
        self.parse_xml(cpd.to_s)
      end
    end
      
    def self.parse_json(str)
      raise NotImplementedError
    end
      
    def self.parse_rdf(str)
      raise NotImplementedError
    end
    
    def parent_compound
      require 'bio-chembl/compound.rb'
      BioChEMBL::Compound.find(@parent__cmpd__chemblid)
    end
    
    def target
      require 'bio-chembl/target.rb'
      BioChEMBL::Target.find(@target__chemblid)
    end
       
    def assay
      require 'bio-chembl/assay.rb'
      BioChEMBL::Assay.find(@assay__chemblid)
    end
  end

end
