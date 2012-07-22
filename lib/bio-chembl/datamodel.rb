require 'nokogiri'


module BioChEMBL
  
  # ChEMBL database data common utilities
  #
  module DataModel
    
    # Set attr_accessor of ATTRIBUTES
    def set_attr_accessors(attributes)
      attributes.each do |attr|
        eval "attr_accessor :#{attr}"
      end
    end
    
   # Set the values from XML data on the instance variables.
    def set_attr_values(attributes)
      attributes.map do |attr|
        "this.#{attr} = xml.xpath('/#{self.to_s.split('::').last.downcase}/#{attr}').text"
      end.join("\n")
    end
    
  end

end
