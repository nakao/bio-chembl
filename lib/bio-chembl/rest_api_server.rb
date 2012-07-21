require 'cgi'
require 'uri'
require 'nokogiri'


module BioChEMBL
  class REST
    # serv = BioChEMBL::REST::Server.new
    #    
    class Server
      def initialize
        
      end
      
      # serv.query(:status)
      # serv.query(:compounds, 'CHEML1')
      def query(action, args, options)
      end
      
      # /compounds/CHEMBL1
      def compounds(chemblId)
      end
      # /compounds/CHEMBL1/image
      def compounds_image(chemblId)
      end
      # /compounds/CHEMBL1/bioactivities
      def comopunds_bioactivities(chemblId)
      end
      
    end
    
  end
  
  class DB
    class Query
      def initialize
      end
    end
  end
end
