require 'helper'
require 'bio-chembl/chembl.rb'

class TestBioChemblURI < Test::Unit::TestCase
  def setup
    @obj = BioChEMBL::REST::ChEMBL_URI
  end
  
  def test_status
    assert_equal(@obj.status,
      "https://www.ebi.ac.uk/chemblws/status/")
  end
  
  def test_compounds
    assert_equal(@obj.compounds('CHEMBL1'), 
      'https://www.ebi.ac.uk/chemblws/compounds/CHEMBL1')
  end
  
  def test_compounds_image
    assert_equal(@obj.compounds('CHEMBL192', 'image'), 
       'https://www.ebi.ac.uk/chemblws/compounds/CHEMBL192/image')
  end
  
  def test_compounds_image_params
    assert_equal(@obj.compounds('CHEMBL192', 'image', {:dimensions => 200}), 
      'https://www.ebi.ac.uk/chemblws/compounds/CHEMBL192/image?dimensions=200')
  end
  
  def test_compounds_bioactivities
    assert_equal(@obj.compounds('CHEMBL1', 'bioactivities'), 
      'https://www.ebi.ac.uk/chemblws/compounds/CHEMBL1/bioactivities')
  end
  
  def test_compounds_stdinchikey
    assert_equal(@obj.compounds_stdinchikey("QFFGVLORLPOAEC-SNVBAGLBSA-N"),
      'https://www.ebi.ac.uk/chemblws/compounds/stdinchikey/QFFGVLORLPOAEC-SNVBAGLBSA-N')
  end
  
  def test_compounds_smiles
    assert_equal(@obj.compounds_smiles("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56"),
      'https://www.ebi.ac.uk/chemblws/compounds/smiles/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56')
  end
  
  def test_compounds_substructure
    assert_equal(@obj.compounds_substructure("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56"),
      'https://www.ebi.ac.uk/chemblws/compounds/substructure/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56') 
  end
  
  def test_compounds_similarity
    assert_equal(@obj.compounds_similarity("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56/70"),
      'https://www.ebi.ac.uk/chemblws/compounds/similarity/COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56/70')
  end
   
  def test_targets_id
    assert_equal(@obj.targets("CHEMBL2477"),
      'https://www.ebi.ac.uk/chemblws/targets/CHEMBL2477')
  end
  def test_targets_bioactivities
    assert_equal(@obj.targets("CHEMBL2477", 'bioactivities'),
      'https://www.ebi.ac.uk/chemblws/targets/CHEMBL2477/bioactivities')
  end
  def test_targets
    # targets
    assert_equal(@obj.targets,      
      'https://www.ebi.ac.uk/chemblws/targets')
  end
  
  def test_targets_uniprot
    assert_equal(@obj.targets_uniprot("Q13936"),
      'https://www.ebi.ac.uk/chemblws/targets/uniprot/Q13936')
  end
  
  def test_targets_refseq
    assert_equal(@obj.targets_refseq("NP_001128722"),
      'https://www.ebi.ac.uk/chemblws/targets/refseq/NP_001128722')
  end
  
  def test_assays
    assert_equal(@obj.assays("CHEMBL1217643"),
      'https://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643')
  end
  def test_assays_bioactivities
    assert_equal(@obj.assays("CHEMBL1217643", 'bioactivities'),
      'https://www.ebi.ac.uk/chemblws/assays/CHEMBL1217643/bioactivities')
  end

end


class TestBioChembl < Test::Unit::TestCase
  def setup
    @obj = BioChEMBL::REST.new    
  end
  
  def test_new
    assert(@obj)
  end

  def test_uri_status
    assert_equal(@obj.uri.status, 
      'https://www.ebi.ac.uk/chemblws/status/')
  end
  
  def test_status
    assert_equal(@obj.status, 'UP')
  end

  def test_compounds
    doc = @obj.compounds('CHEMBL1')
    assert_equal(doc, 
      '<compound><chemblId>CHEMBL1</chemblId><knownDrug>No</knownDrug><medChemFriendly>Yes</medChemFriendly><passesRuleOfThree>No</passesRuleOfThree><molecularFormula>C32H32O8</molecularFormula><smiles>COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56</smiles><stdInChiKey>GHBOEFUAGSHXPO-XZOTUCIWSA-N</stdInChiKey><numRo5Violations>1</numRo5Violations><rotatableBonds>2</rotatableBonds><molecularWeight>544.59167</molecularWeight><alogp>3.627</alogp><acdLogp>7.669</acdLogp><acdLogd>7.669</acdLogd></compound>')
  end
  
  def test_compounds_image
#    assert_equal(@obj.compounds('CHEMBL192', 'image'), 
#       '') # \x89PNG 
  end
  
  def test_compounds_image_params
#    assert_equal(@obj.compounds('CHEMBL192', 'image', {:dimensions => 200}), 
#      '')
  end
  
  def test_compounds_bioactivities
    doc = @obj.compounds('CHEMBL1', 'bioactivities')
    assert(doc =~ /<list><bioactivity><parent__cmpd__chemblid>CHEMBL1/)
  end
  
  def test_compounds_stdinchikey
    doc = @obj.compounds_stdinchikey("QFFGVLORLPOAEC-SNVBAGLBSA-N")
    assert(doc =~ /<compound><chemblId>CHEMBL1201760/)
    end
  
  def test_compounds_smiles
    doc = @obj.compounds_smiles("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56")
    assert(doc =~ /<list><compound><chemblId>CHEMBL1/)
  end
  
  def test_compounds_substructure
    doc = @obj.compounds_substructure("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56")
    assert(doc, '<list/>')
  end
  
  def test_compounds_similarity
    doc = @obj.compounds_similarity("COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56/70")
    assert(doc =~ /<list><compound><chemblId>CHEMBL/)
  end
   
  def test_targets_id
    doc = @obj.targets("CHEMBL2477")
    assert(doc =~ /<target><chemblId>CHEMBL2477/)
  end

  def test_targets_bioactivities
    doc = @obj.targets("CHEMBL2477", 'bioactivities')
    assert(doc =~ /<list><bioactivity><parent__cmpd__chemblid>CHEMBL/)
  end

  
  def test_targets
    doc = @obj.targets
    assert(doc =~ /<list><target><chemblId>CHEMBL/)      
  end
  
  def test_targets_uniprot
    doc = @obj.targets_uniprot("Q13936")
    assert_equal(doc, '<target><chemblId>CHEMBL1940</chemblId><targetType>PROTEIN</targetType><preferredName>Voltage-gated L-type calcium channel alpha-1C subunit</preferredName><proteinAccession>Q13936</proteinAccession><synonyms>Voltage-dependent L-type calcium channel subunit alpha-1C; Calcium channel, L type, alpha-1 polypeptide, isoform 1, cardiac muscle; Voltage-gated calcium channel subunit alpha Cav1.2</synonyms><organism>Homo sapiens</organism><description>Voltage-dependent L-type calcium channel subunit alpha-1C</description><geneNames>CACNA1C; CACH2; CACN2; CACNL1A1; CCHL1A1</geneNames></target>')
  end
  
  def test_targets_refseq_not_fount
    assert_raise(Exception) {
        @obj.targets_refseq("NP_001128722")
    }
  end
  
  def test_assays
    doc = @obj.assays("CHEMBL1217643")
    assert(doc =~ /<assay><chemblId>CHEMBL1217643/)
  end

  def test_assays_bioactivities
    doc = @obj.assays("CHEMBL1217643", 'bioactivities')
    assert(doc =~ /<list><bioactivity><parent__cmpd__chemblid>CHEMBL/)
  end
  
end


