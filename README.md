# bio-chembl

[![Build Status](https://secure.travis-ci.org/nakao/bioruby-chembl.png)](http://travis-ci.org/nakao/bioruby-chembl)

[ChEMBL REST Web Service API](https://www.ebi.ac.uk/chembldb/ws) client, parser and container classes. 

REST API Client

```ruby
    # Show a web service URI
    BioChEMBL::REST::ChEMBL_URI.status
     #=> "http://www.ebi.ac.uk/chemblws/status/" 
    BioChEMBL::REST::ChEMBL_URI.compounds("CHEMBL1") 
     #=> "http://www.ebi.ac.uk/chemblws/compounds/CHEMBL1"
    BioChEMBL::REST::ChEMBL_URI.targets("CHEMBL2477") 
     #=> "http://www.ebi.ac.uk/chemblws/targets/CHEMBL2477"
    BioChEMBL::REST::ChEMBL_URI.assays("CHEMBL1217643") 
     #=> "http://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643"
     
    # GET the XML data of the ChEMBL ID CHEMBL1 
    api = BioChEMBL::REST.new
    compound = api.compounds("CHEMBL1")
    targst   = api.targets("CHEMBL2477")
    assay    = api.assays("CHEMBL1217643")
```

Parser and container

```ruby
    # Compound
    cpd = BioChEMBL::Compound.find("CHEMBL1")
    cpd.chemblId #=> "CHEMBL1"
    cpd.slimes
   
    ba = cpd.bioactivities

    smiles = "CC(=O)CC(C1=C(O)c2ccccc2OC1=O)c3ccccc3"
    cpd = BioChEMBL::Compound.find_all_by_smiles(smiles)
    cpd = BioChEMBL::Compound.find_all_by_substructure(smiles)
    cpd = BioChEMBL::Compound.find_all_by_similarity(smiles + "/70")
   
    # Target
    target = BioChEMBL::Target.find("CHEMBL2477")
    target.chemblId #=> "CHEMBL2477"
    target.targetType #=> "PROTEIN"
   
    # Assay
    assay = BioChEMBL::Assay.find("CHEMBL1217643")
    assay.chemblId #=> "CHEMBL1217643"
    assay.bioactivities[0].target
    assay.bioactivities[0].assay.chemblID #=> "CHEMBL1217643"
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

