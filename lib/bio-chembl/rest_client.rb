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
  
  class REST
    
    HOST_NAME = "www.ebi.ac.uk"
    API_ROOT = "chemblws"
    BASE_URI = "https://" + HOST_NAME + "/" + API_ROOT
    
    
    # BioChEMBL::REST::ChEMBL_URI module
    #
    module ChEMBL_URI
      # 
      def self.address(path)
        "#{BASE_URI}/#{path}"
      end
     
      
      # BioChEMBL::REST::ChEMBL_URI.status 
      def self.status
        # Example URL: http://www.ebi.ac.uk/chemblws/status/
        address("status/")
      end
      
      # BioChEMBL::REST::ChEMBL_URI.compounds()       
      # compounds("CHEMBL1")
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
      # BioChEMBL::REST::ChEMBL_URI.compounds_stdinchikey()
      def self.compounds_stdinchikey(stdinchikey)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/stdinchikey/QFFGVLORLPOAEC-SNVBAGLBSA-N
        address("compounds/stdinchikey/#{stdinchikey}")
      end 
      # BioChEMBL::REST::ChEMBL_URI.compounds_smiles()
      def self.compounds_smiles(smiles)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/smiles/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56
        address("compounds/smiles/#{smiles}")
      end
      # BioChEMBL::REST::ChEMBL_URI.compounds_substructure()
      def self.compounds_substructure(smiles)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/substructure/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56
        address("compounds/substructure/#{smiles}")
      end
      # BioChEMBL::REST::ChEMBL_URI.compounds_similarity()
      def self.compounds_similarity(smiles)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/compounds/similarity/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56/70
        address("compounds/similarity/#{smiles}")
      end
  
      # BioChEMBL::REST::ChEMBL_URI.targets()
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
      # BioChEMBL::REST::ChEMBL_URI.targets_uniprot()
      def self.targets_uniprot(uniprot_id)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets/uniprot/Q13936
        address("targets/uniprot/#{uniprot_id}")
      end 
      # BioChEMBL::REST::ChEMBL_URI.targets_refseq()
      def self.targets_refseq(refseq_id)
        # Example URL (XML Output): http://www.ebi.ac.uk/chemblws/targets/refseq/NP_001128722
        address("targets/refseq/#{refseq_id}")
      end
      
      # BioChEMBL::REST::ChEMBL_URI.assays()
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
    

    # BioChEMBL::REST.website
    def self.website
      "https://www.ebi.ac.uk/chembldb/index.php/ws"
    end

    # BioChEMBL::REST.usage
    def self.usage    
      ["a = Bio::DB::ChEMBL::REST.new",
       "a.status => https://www.ebi.ac.uk/chembldb/index.php/ws#serviceStatus",
       'a.compounds("CHEMBL1") => http://www.ebi.ac.uk/chemblws/compounds/CHEMBL1',
       'a.compounds.stdinchikey("QFFGVLORLPOAEC-SNVBAGLBSA-N") => http://www.ebi.ac.uk/chemblws/compounds/stdinchikey/QFFGVLORLPOAEC-SNVBAGLBSA-N'
       ].join("\n")
    end
    
    # BioChEMBL::REST.up? #=> true/false
    def self.up?
      if new.status == "UP"
        true
      else
        false
      end
    end

    
    # new
    def initialize(uri = BASE_URI)
      uri = URI.parse(uri) unless uri.kind_of?(URI)
      @header = {
        'User-Agent' => "BioChEMBL, BioRuby/#{Bio::BIORUBY_VERSION_ID}"
      }
      @debug = false
    end

    # If true, shows debug information to $stderr.
    attr_accessor :debug

    # get HTTP GET URL
    def get(url)
      easy = Curl::Easy.new(url) do |c|
        @header.each do |k,v|
          c.headers[k] = v
        end
      end 
      easy.perform
      easy
    end
    
    # 
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
    
    # uri
    def uri
      ChEMBL_URI
    end

    # address
    def address(path)
      "#{BASE_URI}/#{path}"
    end


    
    # API methods
    
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
    
    # 
    def current_method_name
      caller(1).first.scan(/`(.*)'/)[0][0].to_s
    end 
    private :current_method_name
    
    
    def status
      get_body(current_method_name)
    end

    def compounds(chemblId = nil, action = nil, params = nil)
      get_body(current_method_name, [chemblId, action, params])
    end
    
    def compounds_stdinchikey(stdinchikey)
      get_body(current_method_name, [stdinchikey])
    end
     
    def compounds_smiles(smiles)
      get_body(current_method_name, [smiles])
    end
    
    def compounds_substructure(smiles)
      get_body(current_method_name, [smiles])
    end
    
    def compounds_similarity(smiles)
      get_body(current_method_name, [smiles])
    end

    def targets(chemblId = nil, action = nil)
      get_body(current_method_name, [chemblId, action])
    end
    
    def targets_uniprot(uniprot_id)
      get_body(current_method_name, [uniprot_id])
    end
     
    def targets_refseq(refseq_id)
      get_body(current_method_name, [refseq_id])
    end

    def assays(chemblId = nil, action = nil)
      get_body(current_method_name, [chemblId, action])
    end
  end

end
