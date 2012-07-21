require 'nokogiri'


module BioChEMBL
  
  # BioChEMBL::DataModel
  #
  module DataModel
    
    def set_attr_accessors(attributes)
      attributes.each do |attr|
        eval "attr_accessor :#{attr}"
      end
    end
    
   
    def set_attr_values(attributes)
      attributes.map do |attr|
        "this.#{attr} = xml.xpath('/#{self.to_s.split('::').last.downcase}/#{attr}').text"
      end.join("\n")
    end
    
  end

end
