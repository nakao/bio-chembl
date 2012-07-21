require 'helper'
require 'bio-chembl/chembl.rb'



class TestBioChemblCompound < Test::Unit::TestCase
  def setup
    @xml = "<compound><chemblId>CHEMBL1</chemblId><knownDrug>No</knownDrug><medChemFriendly>Yes</medChemFriendly><passesRuleOfThree>No</passesRuleOfThree><molecularFormula>C32H32O8</molecularFormula><smiles>COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56</smiles><stdInChiKey>GHBOEFUAGSHXPO-XZOTUCIWSA-N</stdInChiKey><numRo5Violations>1</numRo5Violations><rotatableBonds>2</rotatableBonds><molecularWeight>544.59167</molecularWeight><alogp>3.627</alogp><acdLogp>7.669</acdLogp><acdLogd>7.669</acdLogd></compound>"
    @chemblId = "CHEMBL1"
  end
  
  def test_compound_parser_xml
    doc = BioChEMBL::Compound.parse_xml(@xml)
    assert_equal(doc.chemblId, "CHEMBL1")
  end
  
  def test_compound_attributes
    doc = BioChEMBL::Compound.parse_xml(@xml)
    assert_equal(doc.class, BioChEMBL::Compound)
  end

  def test_compound_attributes
    doc = BioChEMBL::Compound.parse_xml(@xml)
    assert_equal(doc.chemblId, "CHEMBL1")
    assert_equal(doc.knownDrug, "No")
    assert_equal(doc.medChemFriendly, "Yes")
    assert_equal(doc.passesRuleOfThree, "No")
    assert_equal(doc.molecularFormula, "C32H32O8")
    assert_equal(doc.smiles, "COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56")
    assert_equal(doc.stdInChiKey, "GHBOEFUAGSHXPO-XZOTUCIWSA-N")
    assert_equal(doc.numRo5Violations, "1")
    assert_equal(doc.rotatableBonds, "2")
    assert_equal(doc.molecularWeight, "544.59167")
    assert_equal(doc.alogp, "3.627")
    assert_equal(doc.acdLogp, "7.669")
    assert_equal(doc.acdLogd, "7.669")
  end
    

  def test_compound_parse_json
    assert_raise(NotImplementedError) {
      BioChEMBL::Compound.parse_json("")
    }
  end

  
  def test_compound_parse_rdf
    assert_raise(NotImplementedError) {
      BioChEMBL::Compound.parse_rdf("")
    }
  end
  
  
  def test_compound_parse
    doc = BioChEMBL::Compound.parse(@xml)
    assert_equal("CHEMBL1", doc.chemblId)
  end

  
  def test_compound_resolve
    doc = BioChEMBL::Compound.new
    doc.chemblId = @chemblId
    assert_equal(doc.knownDrug, nil)
    doc.resolve
    assert_equal(doc.knownDrug, "No")
  end
end

class TestBioChemblCompoundClassMethods < Test::Unit::TestCase
  def setup
    @chemblId = "CHEMBL1"
    @smiles = "COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56"
    @stdinchikey = "QFFGVLORLPOAEC-SNVBAGLBSA-N"
    @warfarine = "CC(=O)CC(C1=C(O)c2ccccc2OC1=O)c3ccccc3"
    @warfarine70 = "CC(=O)CC(C1=C(O)c2ccccc2OC1=O)c3ccccc3/70"
  end

  def test_find
    doc = BioChEMBL::Compound.find(@chemblId)
    assert_equal(doc.chemblId, "CHEMBL1")
    assert_equal(doc.knownDrug, "No")
  end

  def test_find_by_smiles
    uri = BioChEMBL::REST::ChEMBL_URI.compounds_smiles(@smiles)
    assert_equal(uri, "https://www.ebi.ac.uk/chemblws/compounds/smiles/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56")
    xml = BioChEMBL::REST.new.compounds_smiles(@smiles)
    assert_equal(xml, "<list><compound><chemblId>CHEMBL1</chemblId><knownDrug>No</knownDrug><medChemFriendly>Yes</medChemFriendly><passesRuleOfThree>No</passesRuleOfThree><molecularFormula>C32H32O8</molecularFormula><smiles>COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56</smiles><stdInChiKey>GHBOEFUAGSHXPO-XZOTUCIWSA-N</stdInChiKey><numRo5Violations>1</numRo5Violations><rotatableBonds>2</rotatableBonds><molecularWeight>544.59167</molecularWeight><alogp>3.627</alogp><acdLogp>7.669</acdLogp><acdLogd>7.669</acdLogd></compound></list>")
    doc = BioChEMBL::Compound.find_by_smiles(@smiles)
    assert_equal(doc.class, BioChEMBL::Compound)
    assert_equal("CHEMBL1", doc.chemblId)
  end

  def test_find_all_by_smiles
    uri = BioChEMBL::REST::ChEMBL_URI.compounds_smiles(@smiles)
    assert_equal(uri, "https://www.ebi.ac.uk/chemblws/compounds/smiles/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56")
    xml = BioChEMBL::REST.new.compounds_smiles(@smiles)
    assert_equal(xml, "<list><compound><chemblId>CHEMBL1</chemblId><knownDrug>No</knownDrug><medChemFriendly>Yes</medChemFriendly><passesRuleOfThree>No</passesRuleOfThree><molecularFormula>C32H32O8</molecularFormula><smiles>COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56</smiles><stdInChiKey>GHBOEFUAGSHXPO-XZOTUCIWSA-N</stdInChiKey><numRo5Violations>1</numRo5Violations><rotatableBonds>2</rotatableBonds><molecularWeight>544.59167</molecularWeight><alogp>3.627</alogp><acdLogp>7.669</acdLogp><acdLogd>7.669</acdLogd></compound></list>")
    docs = BioChEMBL::Compound.find_all_by_smiles(@smiles)
    assert_equal(docs.class, Array)
    assert_equal(docs.first.class, BioChEMBL::Compound)
    assert_equal("CHEMBL1", docs.first.chemblId)
  end

  def test_find_by_stdinchikey
    doc = BioChEMBL::Compound.find_by_stdinchikey(@stdinchikey)
    assert_equal(doc.class, BioChEMBL::Compound)
    assert_equal("CHEMBL1201760", doc.chemblId)
  end

  def test_find_all_by_substructure
    docs = BioChEMBL::Compound.find_all_by_substructure(@warfarine)
    assert_equal(docs.class, Array)
    assert_equal(docs.first.class, BioChEMBL::Compound)
    assert_equal("CHEMBL149194", docs.first.chemblId)
  end

  def test_find_all_by_similarity
    docs = BioChEMBL::Compound.find_all_by_similarity(@warfarine70)
    assert_equal(docs.class, Array)
    assert_equal(docs.first.class, BioChEMBL::Compound)
    assert_equal("CHEMBL313331", docs.first.chemblId)
  end

end