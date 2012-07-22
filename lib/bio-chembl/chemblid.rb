require 'cgi'
require 'uri'
require 'bio/version'
require 'curb'
require 'nokogiri'




module BioChEMBL
      
  # ChEMBL ID Utility
  #
  # Format
  #
  #   /^CHEMBL\d+$/
  #
  # Usage
  #
  #   chemblId = BioChEMBL::ChEMBLID.new("CHEMBL1")
  #   chemblId.is_compound? #=> true
  #   chemblId.is_target?   #=> false
  #   compound = chemblId.resolve
  #
  class ChEMBLID < String
    
    attr_accessor :data_type
 
    # ChEMBL ID Validater
    def self.validate_chemblId(str)
      validate_chemblId(ste)
    end
    
    # ChEMBL ID Validater
    def validate_chemblId(str)
      unless str =~ /^CHEMBL\d+$/
        raise Exception, "Invalid ChEMBL ID, '#{str}'"
      end
    end  
     
    def initialize(str)
      @data_type = nil
      validate_chemblId(str)
      super(str)
    end

    # Get the data of the ChEMBL ID
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
          is_compound?
        rescue
        end 
        begin
          is_target?
        rescue
        end 
        begin
          is_assay?
        rescue
        end
        if @data_type == nil
          raise ArgumentError, "This ChEMBL ID is not exist, #{self.to_s}"
        else
          resolve
        end 
      end
    end
    
    # Is the ChEMBL ID of Compound ?
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

    # Is the ChEMBL ID of Target ?
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
    
    # Is the ChEMBL ID of Assay ?
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
