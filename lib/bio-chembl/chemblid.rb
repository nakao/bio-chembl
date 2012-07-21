require 'cgi'
require 'uri'
require 'bio/version'
require 'curb'
require 'nokogiri'




module BioChEMBL
      
  # ChEMBL ID
  #
  # CHEMBL1
  #
  # cid = BioChEMBL::ChEMBLID.new("CHEMBL1")
  # cid.is_compound? #=> true
  # cid.resolve #=> aBioChEMBL::Compound
  #
  class ChEMBLID < String
    
    attr_accessor :data_type
 
    def self.validate_chemblId(str)
      unless str =~ /^CHEMBL\d+$/
        raise Exception, "Invalid ChEMBL ID."
      end
    end
       
    def initialize(str)
      @data_type = nil
      self.validate_chemblId(str)
      super(str)
    end

   
    def resolve
      case @data_type
      when Compound
        Compound.find(self.to_s)
      when Target
        Target.find(self.to_s)
      when Assay
        Assay.find(self.to_s)
      else
        begin
          Compound.find(self.to_s)
        rescue
        end 
        begin
          Target.find(self.to_s)
        rescue
        end 
        begin
          Assay.find(self.to_s)
        rescue
        end 
      end
    end
    
    def is_compound?
      if @data_type == Compound
        return true
      else
        if Compound.find(self.to_s)
          @data_type = Compound
          return true
        else
          return false  
        end 
      end
    end
    
    def is_target?
      if @data_type == Assay
        return true
      else
        if Assay.find(self.to_s)
          @data_type = Assay
          return true
        else
          return false  
        end 
      end    
    end
    
    def is_assay?
      if @data_type == Assay
        return true
      else
        if Assay.find(self.to_s)
          @data_type = Assay
          return true
        else
          return false  
        end 
      end   
    end

  end

end
