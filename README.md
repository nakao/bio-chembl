# bio-chembl

[![Build Status](https://secure.travis-ci.org/nakao/bio-chembl.png)](http://travis-ci.org/nakao/bio-chembl)

[ChEMBL REST Web Service API](https://www.ebi.ac.uk/chembldb/ws) client, parser and container classes. 

REST API address

```ruby
    BioChEMBL::REST::ChEMBL_URI.status
     #=> "https://www.ebi.ac.uk/chemblws/status/" 
    BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1") 
     #=> "https://www.ebi.ac.uk/chemblws/compounds/CHEMBL1"
    BioChEMBL::REST::ChEMBL_URI.targets("CHEMBL2477") 
     #=> "https://www.ebi.ac.uk/chemblws/targets/CHEMBL2477"
    BioChEMBL::REST::ChEMBL_URI.assays("CHEMBL1217643") 
     #=> "https://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643"
```

Get data in XML
```ruby     
    api = BioChEMBL::REST.new
    compound = api.compounds("CHEMBL1")
    targst   = api.targets("CHEMBL2477")
    assay    = api.assays("CHEMBL1217643")
```
Check the server status
```ruby
   BioChEMBL::REST.up? #=> true/false
```   
REST API client, parser and container: BioChEMBL::Compound
```ruby
    cpd = BioChEMBL::Compound.find("CHEMBL1")
    cpd.chemblId #=> "CHEMBL1"
    cpd.slimes
   
    smiles = "CC(=O)CC(C1=C(O)c2ccccc2OC1=O)c3ccccc3"
    cpds = BioChEMBL::Compound.find_all_by_smiles(smiles)
    cpds = BioChEMBL::Compound.find_all_by_substructure(smiles)
    cpds = BioChEMBL::Compound.find_all_by_similarity(smiles + "/70")

    cpd.bioactivities[0].parent_compound.chemblId #=> "CHEMBL1"
    
    xml = BioChEMBL::REST.new.compounds("CHEMBL1") 
    cpd = BioChEMBL::Compound.parse_xml(xml)
```
REST API client, parser and container: BioChEMBL::Target
```ruby       
    target = BioChEMBL::Target.find("CHEMBL1785")
    target.chemblId #=> "CHEMBL1785"
    target.targetType #=> "PROTEIN"
    target.geneNames #=> "EDNRB; ETRB"
    
    BioChEMBL.to_array(target.geneNames) #=> ["EDNRB", "ETRB"]
    synonyms = BioChEMBL.to_array(target.synonyms)
    synosyms[0] #=> "Endothelin B receptor"

    target = BioChEMBL::Target.find_by_uniprot("Q13936")
    
    target.bioactivities[0].target.chemblId #=> "CHEMBL1785"
    
    xml = BioChEMBL::REST.new.targets("CHEMBL1785")     
    target = BioChEMBL::Target.parse_xml(xml)
```
REST API client, parser and container: BioChEMBL::Assay
```ruby   
    assay = BioChEMBL::Assay.find("CHEMBL1217643")
    assay.chemblId #=> "CHEMBL1217643"
    
    assay.bioactivities[0].assay.chemblId #=> "CHEMBL1217643"
    assay.bioactivities[0].target
    assay.bioactivities[0].parent_compound
    
    xml = BioChEMBL::REST.new.assays("CHEMBL1217643") 
    assay = BioChEMBL::Assay.parse_xml(xml)
```

Parser and container: BioChEMBL::Bioactivity
```ruby
    cpd.bioactivities[0].parent_compound.chemblId
    target.bioactivities[0].target.chemblId
    assay.bioactivities[0].assay.chemblId
    assay.bioactivities[0].target
    assay.bioactivities[0].parent_compound
```

Getting Started with Ruby
```ruby
    require 'bio-chembl'
    # 1. Use UniProt accession to get target details
    puts "
    # =========================================================
    # 1. Use UniProt accession to get target details
    # =========================================================
    "
    
  	accession = "Q00534"
  	target = BioChEMBL::Target.find_by_uniprot(accession)
  	
  	puts "Target description:  #{target.description}"
  	puts "Target CHEMBLID:     #{target.chemblId}"
  	
  
    # 2. Get all bioactivties for target CHEMBL_ID
    puts "
	# =========================================================
	# 2. Get all bioactivties for target CHEMBL_ID
	# =========================================================
	"

	bioactivities = target.bioactivities
	
	puts "Bioactivity count:           #{bioactivities.size}"
	puts "Bioactivity count (IC50's):  #{bioactivities.find_all {|x| x.bioactivity__type =~ /IC50/}.size}"


	# 3. Get compounds with high binding affinity (IC50 < 100)
	puts "
	# =========================================================
	# 3. Get compounds with high binding affinity (IC50 < 100)
	# =========================================================
	"

	bioactivities.find_all {|x| x.bioactivity__type =~ /IC50/ and x.value.to_i < 100 }.each do |ba|
	  compound = ba.parent_compound
	  print "Compound CHEMBLID: #{compound.chemblId}"
	  puts "  #{compound.smiles}"
	end
	
	# 4. Get assay details for Ki actvity types
	puts "
	# =========================================================
	# 4. Get assay details for Ki actvity types
	# =========================================================
	"
	
	bioactivities.find_all {|x| x.bioactivity__type =~ /Ki/i }.each do |ba|
	  assay = ba.assay
	  print "Assay CHEMBLID:  #{assay.chemblId}"
	  puts "  #{assay.assayDescription}"
	end
```
Note: this software is under active development!

## Installation

```sh
    gem install bio-chembl
```

## Usage

```ruby
    require 'bio-chembl'
```

The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/nakao/bio-chembl

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Todo list

* BioChEMBL::Compound#image method to get the image in png.
* BioChEMBL::Target.find_by_refesq method.
* JSON output support (parser and address).
* ChEMBL RDF integration.
* Local REST API server with local ChEMBL database.
* Connect Bioactivity#reference to external IDs (PubMed ID/DOI/CiteXplore)

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at [#bio-chembl](http://biogems.info/index.html)

## Copyright

Copyright (c) 2012 Mitsuteru Nakao. See LICENSE.txt for further details.

