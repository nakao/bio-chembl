require 'cgi'
require 'uri'
require 'bio/version'
require 'curb'
require 'nokogiri'




module BioChEMBL
      
  # ChEMBL ID utility String
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
  #   BioChEMBL::ChEMBLID.validate("CHEMBL1")
  #
  class ChEMBLID < String
    
    attr_accessor :data_type
 
    
    # Checking the format of the ChEMBL ID
    def self.valid_format?(str)
      begin
        self.new(str)
        true
      rescue Exception
        false
      end
    end
    
    # ChEMBL ID Validater
    def validate_chemblId(str)
      if str =~ /^CHEMBL\d+$/
        true
      else
        raise Exception, "Invalid ChEMBL ID, '#{str}'"
      end
    end  
    private :validate_chemblId
      
    def initialize(str)
      @data_type = nil
      validate_chemblId(str)
      super(str)
    end

    # Get the data of the ChEMBL ID (Slow)
    def resolve
      if @data_type    == Compound
        return Compound.find(self.to_s)
      elsif @data_type == Target
        return Target.find(self.to_s)
      elsif @data_type == Assay
        return Assay.find(self.to_s)
      else
        if    is_compound?
        elsif is_target?
        elsif is_assay?
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
        begin
          Compound.find(self)
          @data_type = Compound
          return true
        rescue Exception
          return false  
        end 
      end
    end


    # Is the ChEMBL ID of Target ?
    def is_target?
      if @data_type == Target
        return true
      else
        begin
          Target.find(self)
          @data_type = Target
          return true
        rescue Exception
          return false  
        end 
      end    
    end
    
    
    # Is the ChEMBL ID of Assay ?
    def is_assay?
      if @data_type == Assay
        return true
      else
        begin
          Assay.find(self)
          @data_type = Assay
          return true
        rescue Exception
          return false  
        end 
      end   
    end

  end

end
