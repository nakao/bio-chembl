require 'helper'
require 'bio-chembl/chembl.rb'



class TestBioChemblChembId < Test::Unit::TestCase
  def setup
    @str = "CHEMBL1"
    @chemblid = BioChEMBL::ChEMBLID.new(@str)
  end
  
  def test_chemblid
    assert_equal(BioChEMBL::ChEMBLID, @chemblid.class)
    assert_equal("CHEMBL1", @chemblid)
    assert_equal(nil, @chemblid.data_type)
  end
  
  def test_invalid_chembl_id
    assert_raise(Exception) {
      BioChEMBL::ChEMBLID.new("CHEMBLCHEMBL1")
    }
  end
  
  def test_chemblid_validate
    assert_equal(true, BioChEMBL::ChEMBLID.valid_format?(@str))
    assert_equal(false, BioChEMBL::ChEMBLID.valid_format?("CHEMBLCHEMBL1"))
  end
  
  def test_resolve
    compound = @chemblid.resolve
    assert_equal(BioChEMBL::Compound, @chemblid.data_type)
    assert_equal(@chemblid, compound.chemblId)
    assert_equal("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56", compound.smiles)
  end

  def test_resolve_target
    target = BioChEMBL::ChEMBLID.new("CHEMBL1785").resolve
    assert_equal(BioChEMBL::Target, target.class)
    assert_equal("CHEMBL1785", target.chemblId)
    assert_equal("PROTEIN", target.targetType)
  end

  def test_resolve_assay
    assay = BioChEMBL::ChEMBLID.new("CHEMBL1217643").resolve
    assert_equal(BioChEMBL::Assay, assay.class)
    assert_equal("CHEMBL1217643", assay.chemblId)
    assert_equal("B", assay.assayType)
  end
  
  def test_resolve_invalid
    assert_raise(ArgumentError) {
      dummy = BioChEMBL::ChEMBLID.new("CHEMBL11111111111111217643").resolve
    }
  end

  
  def test_chemblid_is_compound?
    assert_equal(true, @chemblid.is_compound?)
    assert_equal(BioChEMBL::Compound, @chemblid.data_type)
  end
  
  def test_chemblid_is_target?
    assert_equal(false, @chemblid.is_target?)    
  end

  def test_chemblid_is_assay?
    assert_equal(false, @chemblid.is_assay?)    
  end
end