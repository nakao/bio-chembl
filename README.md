# bio-chembl

[![Build Status](https://secure.travis-ci.org/nakao/bioruby-chembl.png)](http://travis-ci.org/nakao/bioruby-chembl)

[ChEMBL REST Web Service API](https://www.ebi.ac.uk/chembldb/ws) client, parser and container classes. 

REST API address

```ruby
    BioChEMBL::REST::ChEMBL_URI.status
     #=> "http://www.ebi.ac.uk/chemblws/status/" 
    BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1") 
     #=> "http://www.ebi.ac.uk/chemblws/compounds/CHEMBL1"
    BioChEMBL::REST::ChEMBL_URI.targets("CHEMBL2477") 
     #=> "http://www.ebi.ac.uk/chemblws/targets/CHEMBL2477"
    BioChEMBL::REST::ChEMBL_URI.assays("CHEMBL1217643") 
     #=> "http://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643"
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

* BioChEMBL::Target.find_by_refesq method.
* JSON output support (parser and address).
* ChEMBL RDF support.
* Local REST API server with local ChEMBL database.

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at [#bio-chembl](http://biogems.info/index.html)

## Copyright

Copyright (c) 2012 Mitsuteru Nakao. See LICENSE.txt for further details.

