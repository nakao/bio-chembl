require 'helper'
require 'bio-chembl/chembl.rb'



class TestBioChemblTarget < Test::Unit::TestCase
  def setup
    @xml = "<target><chemblId>CHEMBL1785</chemblId><targetType>PROTEIN</targetType><preferredName>Endothelin receptor ET-B</preferredName><proteinAccession>P24530</proteinAccession><synonyms>Endothelin B receptor; Endothelin receptor non-selective type; ET-B; ET-BR</synonyms><organism>Homo sapiens</organism><description>Endothelin B receptor</description><geneNames>EDNRB; ETRB</geneNames></target>"
    @chemblId = "CHEMBL1785"
  end

  def test_target_parser_xml
    doc = BioChEMBL::Target.parse_xml(@xml)
    assert_equal(doc.chemblId, "CHEMBL1785")
  end
  
  def test_target_attributes
    doc = BioChEMBL::Target.parse_xml(@xml)
    assert_equal(doc.class, BioChEMBL::Target)
  end

  def test_target_attributes
    doc = BioChEMBL::Target.parse_xml(@xml)
    assert_equal("CHEMBL1785", doc.chemblId)
    assert_equal("PROTEIN", doc.targetType)
    assert_equal("Endothelin receptor ET-B", doc.preferredName)
    assert_equal("P24530", doc.proteinAccession)
    assert_equal("Endothelin B receptor; Endothelin receptor non-selective type; ET-B; ET-BR", doc.synonyms)
    assert_equal("Homo sapiens", doc.organism)
    assert_equal("Endothelin B receptor", doc.description)
    assert_equal("EDNRB; ETRB", doc.geneNames)
  end
    
  def test_target_synonyms_to_array
    doc = BioChEMBL::Target.parse_xml(@xml)
    assert_equal("Endothelin B receptor; Endothelin receptor non-selective type; ET-B; ET-BR", doc.synonyms)
    synonyms = BioChEMBL.to_array(doc.synonyms)
    assert_equal(4, synonyms.size)
    assert_equal("Endothelin B receptor", synonyms[0])
  end

  def test_target_geneNames_to_array
    doc = BioChEMBL::Target.parse_xml(@xml)
    assert_equal("EDNRB; ETRB", doc.geneNames)
    geneNames = BioChEMBL.to_array(doc.geneNames)
    assert_equal(2, geneNames.size)
    assert_equal("EDNRB", geneNames[0])
  end
  
  def test_target_parse_json
    assert_raise(NotImplementedError) {
      BioChEMBL::Target.parse_json("")
    }
  end

  
  def test_target_parse_rdf
    assert_raise(NotImplementedError) {
      BioChEMBL::Target.parse_rdf("")
    }
  end
  
  
  def test_target_parse
    doc = BioChEMBL::Target.parse(@xml)
    assert_equal("CHEMBL1785", doc.chemblId)
  end

  
  def test_target_resolve
    doc = BioChEMBL::Target.new
    doc.chemblId = @chemblId
    assert_equal(doc.targetType, nil)
    doc.resolve
    assert_equal(doc.targetType, "PROTEIN")
  end
  
end 

class TestBioChemblTargetClassMethods < Test::Unit::TestCase
  def setup
    @chemblId = "CHEMBL2477"
    @target = BioChEMBL::Target.find(@chemblId)
    @uniprot_id = "Q13936"
    @refseq_id = "NP_001128722"
  end

  def test_find
    assert_equal(@target.chemblId, "CHEMBL2477")
    assert_equal(@target.targetType, "PROTEIN")
  end
  
  def test_find_by_uniprot
    @target = BioChEMBL::Target.find_by_uniprot(@uniprot_id)
    assert_equal(@target.chemblId, "CHEMBL1940")
    assert_equal(@target.targetType, "PROTEIN")
  end
  
  def test_find_by_refseq
#    @target = BioChEMBL::Target.find_by_refseq(@refseq_id)
#    p @target
#    assert_equal(@target.chemblId, "CHEMBL2477")
#    assert_equal(@target.targetType, "PROTEIN")
  end

  def test_bioactivities
     docs = @target.bioactivities
     assert_equal(Array, docs.class)
     assert_equal(BioChEMBL::Bioactivity, docs.first.class)
     assert_equal("Homo sapiens", docs.first.organism)
     assert_equal("Bioorg. Med. Chem. Lett., (1998) 8:13:1703", docs.first.reference)
  end
  
end