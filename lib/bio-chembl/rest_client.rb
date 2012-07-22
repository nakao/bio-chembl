require 'cgi'
require 'uri'
require 'bio/version'
require 'curb'
require 'nokogiri'

require 'bio-chembl/compound.rb'
require 'bio-chembl/target.rb'
require 'bio-chembl/assay.rb'
require 'bio-chembl/bioactivity.rb'

module BioChEMBL
  
  # ChEMBL REST Web service API Client.
  #
  # Usage
  # 
  #  # URI
  #  BioChEMBL::REST::ChEMBL_URI.status
  #  BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1")
  #
  #  # Low-level client
  #  client = BioChEMBL::REST.new
  #  client.status
  #  client.compounds("CHEMBL1")
  #
  #  # Check REST API status
  #  BioChEMBL::REST.up? #=> true/false
  #
  #
  class REST
    
    HOST_NAME = "www.ebi.ac.uk"
    API_ROOT = "chemblws"
    BASE_URI = "https://" + HOST_NAME + "/" + API_ROOT
    
    
    # ChEMBL REST Web Service URI generator
    #
    # [ChEMBL Web Services](https://www.ebi.ac.uk/chembldb/ws)
    # 
    module ChEMBL_URI

      # 
      def self.address(path)
        "#{BASE_URI}/#{path}"
      end
     
      
      # Check API status 
      def self.status
        # Example URL: http://www.ebi.ac.uk/chemblws/status/
        address("status/")
      end
      
      # Get compound by ChEMBLID
      #   BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1")  
      # Get image of a ChEMBL compound by ChEMBLID     
      #   BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1", 'image')       
      #   BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1", 'image', {'dimensions' => 200})   
      # Get individual compound bioactivities    
      #   BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1", 'bioactivities')       
      def self.compounds(chemblId = nil, arg = nil, params = nil)
        if chemblId and arg == nil and params == nil 
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/CHEMBL1
          address("compounds/#{chemblId}")
        elsif chemblId and arg == 'image' and params == nil
        # Example URL: http://www.ebi.ac.uk/chemblws/compounds/CHEMBL192/image
          address("compounds/#{chemblId}/#{arg}")
        elsif chemblId and arg == 'image' and params 
        # Example URL with dimensions parameter: http://www.ebi.ac.uk/chemblws/compounds/CHEMBL192/image?dimensions=200
          address("compounds/#{chemblId}/#{arg}?" + params.map {|k,v| "#{k}=#{v}"}.join("&"))
        elsif chemblId and arg == 'bioactivities' and params == nil
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/CHEMBL2/bioactivities
          address("compounds/#{chemblId}/#{arg}")
        else 
          raise Exception, "Undefined address. ID: #{chemblId}, arg: #{arg}, params: #{params.inspect}"
        end
      end
      
      # Get compound by Standard InChiKey
      #   BioChEMBL::REST::ChEMBL_URI.compounds_stdinchikey(stdinchikey)
      def self.compounds_stdinchikey(stdinchikey)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/stdinchikey/QFFGVLORLPOAEC-SNVBAGLBSA-N
        address("compounds/stdinchikey/#{stdinchikey}")
      end 
      
      # Get list of compounds matching Canonical SMILES
      #  BioChEMBL::REST::ChEMBL_URI.compounds_smiles(smiles)
      def self.compounds_smiles(smiles)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/smiles/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56
        address("compounds/smiles/#{smiles}")
      end
      
      # Get list of compounds containing the substructure represented by a given Canonical SMILES
      #  BioChEMBL::REST::ChEMBL_URI.compounds_substructure(smiles)
      def self.compounds_substructure(smiles)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/substructure/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56
        address("compounds/substructure/#{smiles}")
      end
      
      # Get list of compounds similar to the one represented by a given Canonical SMILES, at a given cutoff percentage
      #  BioChEMBL::REST::ChEMBL_URI.compounds_similarity(smiles + "/" + cutoff)
      def self.compounds_similarity(smiles)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/similarity/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56/70
        address("compounds/similarity/#{smiles}")
      end
  
      # Get target by ChEMBLID
      #  BioChEMBL::REST::ChEMBL_URI.targets(chemblId)
      # Get individual target bioactivities
      #  BioChEMBL::REST::ChEMBL_URI.targets(chemblId, 'bioactivities')
      # Get all targets
      #  BioChEMBL::REST::ChEMBL_URI.targets
      def self.targets(chemblId = nil, arg = nil)
        if chemblId and arg == nil
          # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets/CHEMBL2477
          address("targets/#{chemblId}")
        elsif chemblId and arg == 'bioactivities' 
          # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets/CHEMBL240/bioactivities
          address("targets/#{chemblId}/bioactivities")
        elsif chemblId == nil and arg == nil 
          # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets
          address("targets")
        else
          raise Exception, "Undefined."
        end
      end
      
      # Get target by UniProt Accession Identifier
      #  BioChEMBL::REST::ChEMBL_URI.targets_uniprot(uniprot_id)
      def self.targets_uniprot(uniprot_id)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets/uniprot/Q13936
        address("targets/uniprot/#{uniprot_id}")
      end 
      
      # Get target by RefSeq Accession Identifier
      #  BioChEMBL::REST::ChEMBL_URI.targets_refseq(refseq_id)
      def self.targets_refseq(refseq_id)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets/refseq/NP_001128722
        address("targets/refseq/#{refseq_id}")
      end
      
      # Get assay by ChEMBLID
      #  BioChEMBL::REST::ChEMBL_URI.assays(chemblId)
      # Get individual assay bioactivities
      #  BioChEMBL::REST::ChEMBL_URI.assays(chemblId, 'bioactivities')
      def self.assays(chemblId, arg = nil)
        if chemblId and arg == nil
          # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643
          address("assays/#{chemblId}")
        elsif chemblId and arg == 'bioactivities' 
          # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643/bioactivities
          address("assays/#{chemblId}/bioactivities")
        else
          raise Exception, "Undefined. ChEMBL ID: #{chemblId}, arg: #{arg}"
        end
      end
    end
    

    # The ChEMBL REST Web services website
    def self.website
      "https://www.ebi.ac.uk/chembldb/index.php/ws"
    end

    # Usage
    def self.usage    
      ["a = Bio::DB::ChEMBL::REST.new",
       "a.status => https://www.ebi.ac.uk/chembldb/index.php/ws#serviceStatus",
       'a.compounds("CHEMBL1") => http://www.ebi.ac.uk/chemblws/compounds/CHEMBL1',
       'a.compounds.stdinchikey("QFFGVLORLPOAEC-SNVBAGLBSA-N") => http://www.ebi.ac.uk/chemblws/compounds/stdinchikey/QFFGVLORLPOAEC-SNVBAGLBSA-N'
       ].join("\n")
    end
    
    # Check the API status
    #  BioChEMBL::REST.up? #=> true/false
    def self.up?
      if new.status == "UP"
        true
      else
        false
      end
    end

    
    def initialize(uri = BASE_URI)
      uri = URI.parse(uri) unless uri.kind_of?(URI)
      @header = {
        'User-Agent' => "BioChEMBL, BioRuby/#{Bio::BIORUBY_VERSION_ID}"
      }
      @debug = false
    end

    # If true, shows debug information to $stderr.
    attr_accessor :debug

    # get the HTTP GET URL
    def get(url)
      easy = Curl::Easy.new(url) do |c|
        @header.each do |k,v|
          c.headers[k] = v
        end
      end 
      easy.perform
      easy
    end
    
    def prepare_return_value(response)
      if @debug then
        $stderr.puts "ChEMBL: #{response.inspect}"
      end
      case response.response_code 
      when 200
        response.body_str
      when 400
        raise Exception, "400 Bad request  #{response.inspect}"
      when 404
        raise Exception, "404 Not found   #{response.inspect}"
      when 500
        raise Exception, "500 Service unavailable"
      else
        nil
      end
    end
    
    # URI
    def uri
      ChEMBL_URI
    end

    # Address
    def address(path)
      "#{BASE_URI}/#{path}"
    end


    
    # API methods
    
    # Generic request builder and evaluator
    def get_body(method, args = [])
      code = case args.size
      when 0
        "get(uri.#{method})"
      when 1
        "get(uri.#{method}(#{args[0].inspect}))"
      when 2
        "get(uri.#{method}(#{args[0].inspect}, #{args[1].inspect}))"
      when 3
        "get(uri.#{method}(#{args[0].inspect}, #{args[1].inspect}, #{args[2].inspect}))"
      else
        raise Exception, "method=#{method}, args=#{args.inspect}"
      end  
      
      response = eval code
      prepare_return_value(response)
    end
    private :get_body
    
    # Resolve the calling method name
    def current_method_name
      caller(1).first.scan(/`(.*)'/)[0][0].to_s
    end 
    private :current_method_name
    
    # Check API status
    def status
      get_body(current_method_name)
    end

    # Evaluate Compound methods
    def compounds(chemblId = nil, action = nil, params = nil)
      get_body(current_method_name, [chemblId, action, params])
    end
    
    # Evaluate Compound StdInchiKey method
    def compounds_stdinchikey(stdinchikey)
      get_body(current_method_name, [stdinchikey])
    end
     
    # Evaluate Compound SMILES method
    def compounds_smiles(smiles)
      get_body(current_method_name, [smiles])
    end
    
    # Evaluate Compound SubStructure method
    def compounds_substructure(smiles)
      get_body(current_method_name, [smiles])
    end
    
    # Evaluate Compound Similarity method
    def compounds_similarity(smiles)
      get_body(current_method_name, [smiles])
    end

    # Evaluate Target Methods
    def targets(chemblId = nil, action = nil)
      get_body(current_method_name, [chemblId, action])
    end
    
    # Evaluate Target UniProt method
    def targets_uniprot(uniprot_id)
      get_body(current_method_name, [uniprot_id])
    end
     
    # Evaluate Target RefSeq method
    def targets_refseq(refseq_id)
      get_body(current_method_name, [refseq_id])
    end

    # Evaluate Assay methods
    def assays(chemblId = nil, action = nil)
      get_body(current_method_name, [chemblId, action])
    end
  end

end
