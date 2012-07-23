require 'cgi'
require 'uri'
require 'nokogiri'


module BioChEMBL
  class REST
    
    # Local API server
    #
    # Usage
    #   
    #  serv = BioChEMBL::REST::Server.new(:hostname => 'localhost', :port => 3306)
    #  serv.start
    #   
    class Server
      def initialize
        raise NotImplementedError
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
