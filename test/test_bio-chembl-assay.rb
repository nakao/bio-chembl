require 'helper'
require 'bio-chembl/chembl.rb'



class TestBioChemblAssay < Test::Unit::TestCase
  def setup
    @xml = "<assay><chemblId>CHEMBL1217643</chemblId><assayType>B</assayType><journal>Bioorg. Med. Chem. Lett.</journal><assayOrganism>Homo sapiens</assayOrganism><assayStrain>Unspecified</assayStrain><assayDescription>Inhibition of human hERG</assayDescription><numBioactivities>1</numBioactivities></assay>"
    @chemblId = "CHEMBL1217643"
  end
  
  def test_assay_parser_xml
    doc = BioChEMBL::Assay.parse_xml(@xml)
    assert_equal("CHEMBL1217643", doc.chemblId)
  end
  
  def test_assay_attributes
    doc = BioChEMBL::Assay.parse_xml(@xml)
    assert_equal(doc.class, BioChEMBL::Assay)
  end

  def test_assay_attributes
    doc = BioChEMBL::Assay.parse_xml(@xml)
    assert_equal("CHEMBL1217643", doc.chemblId)
    assert_equal("B", doc.assayType)
    assert_equal("Bioorg. Med. Chem. Lett.", doc.journal)
    assert_equal("Homo sapiens", doc.assayOrganism)
    assert_equal("Unspecified", doc.assayStrain)
    assert_equal("Inhibition of human hERG", doc.assayDescription)
    assert_equal("1", doc.numBioactivities)
  end
    

  def test_assay_parse_json
    assert_raise(NotImplementedError) {
      BioChEMBL::Assay.parse_json("")
    }
  end

  
  def test_assay_parse_rdf
    assert_raise(NotImplementedError) {
      BioChEMBL::Assay.parse_rdf("")
    }
  end
  
  
  def test_assay_parse
    doc = BioChEMBL::Assay.parse(@xml)
    assert_equal("CHEMBL1217643", doc.chemblId)
  end

  
  def test_assay_resolve
    doc = BioChEMBL::Assay.new
    doc.chemblId = @chemblId
    assert_equal(nil, doc.assayType)
    doc.resolve
    assert_equal("B", doc.assayType)
  end
end

class TestBioChemblAssayClassMethods < Test::Unit::TestCase
  def setup
    @chemblId = "CHEMBL1217643"
    @assay = BioChEMBL::Assay.find(@chemblId)
  end

  def test_find
    assert_equal("CHEMBL1217643", @assay.chemblId)
    assert_equal("B", @assay.assayType)
  end

  def test_bioactivities
    docs = @assay.bioactivities
    assert_equal(Array, docs.class)
    assert_equal(BioChEMBL::Bioactivity, docs.first.class)
    assert_equal("Homo sapiens", docs.first.organism)
    assert_equal("Bioorg. Med. Chem. Lett., (2010) 20:15:4359", docs.first.reference)
  end
end


class TestBioChemblBioactivity < Test::Unit::TestCase
  def setup
    @xml = "<list><bioactivity><parent__cmpd__chemblid>CHEMBL1214402</parent__cmpd__chemblid><ingredient__cmpd__chemblid>CHEMBL1214402</ingredient__cmpd__chemblid><target__chemblid>CHEMBL240</target__chemblid><target__confidence>9</target__confidence><target__name>HERG</target__name><reference>Bioorg. Med. Chem. Lett., (2010) 20:15:4359</reference><name__in__reference>26</name__in__reference><organism>Homo sapiens</organism><bioactivity__type>IC50</bioactivity__type><activity__comment>Unspecified</activity__comment><operator>=</operator><units>nM</units><assay__chemblid>CHEMBL1217643</assay__chemblid><assay__type>B</assay__type><assay__description>Inhibition of human hERG</assay__description><value>5900</value></bioactivity></list>"
    @chemblId = "CHEMBL1214402"
  end
  
  def test_bioactivity_new
    ba = BioChEMBL::Bioactivity.new
    assert_equal(BioChEMBL::Bioactivity, ba.class)
    ba.reference = '11'
    assert_equal('11', ba.reference)
  end
  
  def test_bioactivities_parser_list_xml
    docs = BioChEMBL::Bioactivity.parse_list_xml(@xml)
    assert_equal("CHEMBL1214402", docs.first.parent__cmpd__chemblid)
  end
  
  def test_bioactivity_attributes
    docs = BioChEMBL::Bioactivity.parse_list_xml(@xml)
    assert_equal(docs.first.class, BioChEMBL::Bioactivity)
  end

  def test_bioactivity_attributes
    docs = BioChEMBL::Bioactivity.parse_list_xml(@xml)
    doc = docs.first
    assert_equal("CHEMBL1214402", doc.parent__cmpd__chemblid)
    assert_equal("CHEMBL1214402", doc.ingredient__cmpd__chemblid)
    assert_equal("CHEMBL240", doc.target__chemblid)
    assert_equal("9", doc.target__confidence)
    assert_equal("HERG", doc.target__name)
    assert_equal("Bioorg. Med. Chem. Lett., (2010) 20:15:4359", doc.reference)
    assert_equal("26", doc.name__in__reference)
    assert_equal("Homo sapiens", doc.organism)
    assert_equal("IC50", doc.bioactivity__type)
    assert_equal("Unspecified", doc.activity__comment)
    assert_equal("=", doc.operator)
    assert_equal("nM", doc.units)
    assert_equal("CHEMBL1217643", doc.assay__chemblid)
    assert_equal("B", doc.assay__type)
    assert_equal("Inhibition of human hERG", doc.assay__description)
    assert_equal("5900", doc.value)
  end
    

  def test_bioactivity_parse_json
    assert_raise(NotImplementedError) {
      BioChEMBL::Bioactivity.parse_json("")
    }
  end

  
  
  def test_bioactivity_parse_rdf
    assert_raise(NotImplementedError) {
      BioChEMBL::Bioactivity.parse_rdf("")
    }
  end
  
  
  def test_bioactivity_parse_xml
    docs = BioChEMBL::Bioactivity.parse_list_xml(@xml)
    assert_equal(Array, docs.class)
    assert_equal(BioChEMBL::Bioactivity, docs.first.class)
    assert_equal("CHEMBL1214402", docs.first.parent__cmpd__chemblid)
  end

end
  