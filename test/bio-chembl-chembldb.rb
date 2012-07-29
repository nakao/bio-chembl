require 'test/unit'
require 'active_record'
require 'bio-chembl/chembldb.rb'


ActiveRecord::Base.establish_connection( {:adapter => 'mysql', 
                                          :host => 'localhost',
                                          :port => 3306,
                                          :username => 'chembl', 
                                          :password => '', 
                                          :socket => '/Applications/mampstack-5.3.14-1/mysql/tmp/mysql.sock',
                                          :database => 'chembl_14'} )

include BioChEMBL::ChEMBLDB                                          

class ActivityTest < Test::Unit::TestCase
  def setup
    @activity = Activity.find(31863)
  end
  
  def test_attributes
    assert_equal(31863, @activity.activity_id)
    assert_equal(54505, @activity.assay_id)
    assert_equal(6424, @activity.doc_id)
    assert_equal(206172, @activity.record_id)
    assert_equal(180094, @activity.molregno)
    assert_equal(">", @activity.relation)
    assert_equal("100".to_f, @activity.published_value)
    assert_equal("uM", @activity.published_units)
    assert_equal("100000".to_f, @activity.standard_value)
    assert_equal("nM", @activity.standard_units)
    assert_equal("IC50", @activity.standard_type)        
    assert_equal(nil, @activity.activity_comment)        
    assert_equal("IC50", @activity.published_activity_type)            
  end
  
  def test_belongs_to_assay
    assay = @activity.assay
    assert_equal(Assay, assay.class)
    assert_equal(@activity.assay_id, assay.assay_id)  
  end
  
  def test_belongs_to_doc
    doc = @activity.doc
    assert_equal(Doc, doc.class)         
    assert_equal(@activity.doc_id, doc.doc_id)
  end
  
  def test_belongs_to_record
    #, :class_name => :CompoundRecord
    record = @activity.record
    assert_equal(CompoundRecord, record.class)     
    assert_equal(@activity.record_id, record.record_id)
  end
  
  def test_belongs_to_molecule
    molecule = @activity.molecule
    assert_equal(Molecule, molecule.class)   
    assert_equal(@activity.molregno, molecule.molregno)  
  end
end

                                          
class AssayTest < Test::Unit::TestCase
  def setup
    @assay = Assay.find(688284)
  end
  
  def test_attributes
    assert_equal(688284, @assay.assay_id)
    assert_equal("F", @assay.assay_type)
    assert_equal("PubChem BioAssay. Inhibitors of Plasmodium falciparum M17- Family Leucine Aminopeptidase (M17LAP). (Class of assay: confirmatory) ", @assay.description)
    assert_equal(51887, @assay.doc_id)
    assert_equal(7, @assay.src_id)
    assert_equal("1619", @assay.src_assay_id)
    assert_equal("CHEMBL1613799", @assay.chembl_id)
    assert_equal("confirmatory", @assay.assay_category)
    assert_equal("Plasmodium falciparum 3D7", @assay.assay_organism)
    assert_equal(36329, @assay.assay_tax_id)
    assert_equal("3D7", @assay.assay_strain)
  end
  

  def test_belongs_to_doc
    assert_equal(Doc, @assay.doc.class)
  end
  
  def test_belongs_to_src
    assert_equal(Source, @assay.src.class)
  end
  
  def test_belongs_to_lookup
    assert_equal(ChemblIdLookup, @assay.chembl_id_lookup.class)    
  end
  
  def test_belongs_to_assay_tax
    assert_equal(OrganismClass, @assay.assay_tax.class)
  end
  
  def test_belongs_to_assay_type_
    assert_equal(AssayType, @assay.assay_type_.class)    
  end
  
  def test_has_many_activities
    activities = @assay.activities
    assert_equal(827, activities.size) 
    assert_equal(Activity, activities.first.class) 
  end
  
  def hmbtm_targets
    targets = @assay.targets
    assert_equal(827, tarets.size) 
    assert_equal(Target, targets.first.class) 
  end
end


class Assay2targetTest < Test::Unit::TestCase
  def setup
    @obj = Assay2target.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.assay_id)
    assert_equal(12052, @obj.tid)
    assert_equal("H", @obj.relationship_type)
    assert_equal(0, @obj.complex)
    assert_equal(0, @obj.multi)
    assert_equal(8, @obj.confidence_score)
    assert_equal("Autocuration", @obj.curated_by)
  end
  
  def test_belongs_to_assay
    o = @obj.assay
    assert_equal(Assay, o.class)     
    assert_equal(@obj.assay_id, o.assay_id)
  end
  
  def test_belongs_to_target
    o = @obj.target
    assert_equal(Target, o.class)     
    assert_equal(@obj.tid, o.tid)
  end
  
  def test_belongs_to_relationship_type_
    #, :class_name => 'RelationshipType'
    o = @obj.relationship_type_
    assert_equal(RelationshipType, o.class)     
    assert_equal(@obj.relationship_type, o.relationship_type)
  end
  
  def test_belongs_to_confidence_score_lookup_
    #, :class_name => 'ConfidenceScoreLookup'
    o = @obj.confidence_score_lookup_
    assert_equal(ConfidenceScoreLookup, o.class)     
    assert_equal(@obj.confidence_score, o.confidence_score)
  end
  
  def test_belongs_to_curation_lookup
    c = @obj.curation_lookup
    assert_equal(CurationLookup, c.class)
  end
end


class AssayTypeTest < Test::Unit::TestCase
  def setup
    @obj = AssayType.find("P")
  end
  
  def test_attributes
    assert_equal("P", @obj.assay_type)
    assert_equal("Property", @obj.assay_desc)    
  end
  
  def test_assays
    assays = @obj.assays
    assert_equal(Array, assays.class)
    assert_equal(Assay, assays.first.class)    
  end
end


class AtcClassificationTest < Test::Unit::TestCase
  def setup
    @obj = AtcClassification.find("who0001")
  end
  
  def test_attributes
    assert_equal("sodium fluoride", @obj.who_name)
    assert_equal("A", @obj.level1)    
    assert_equal("A01", @obj.level2)        
    assert_equal("A01A", @obj.level3)            
    assert_equal("A01AA", @obj.level4)
    assert_equal("A01AA01", @obj.level5)
    assert_equal("who0001", @obj.who_id)                                            
    assert_equal("ALIMENTARY TRACT AND METABOLISM", @obj.level1_description)
    assert_equal("STOMATOLOGICAL PREPARATIONS", @obj.level2_description)        
    assert_equal("STOMATOLOGICAL PREPARATIONS", @obj.level3_description)            
    assert_equal("Caries prophylactic agents", @obj.level4_description)            
  end
  
  def test_has_many_defined_daily_dose
    ddd = @obj.defined_daily_dose
    assert_equal(Array, ddd.class)
    assert_equal(DefinedDailyDose, ddd.first.class)
  end
end


class ChemblIdLookupTest < Test::Unit::TestCase
  def setup
    @obj = ChemblIdLookup.find("CHEMBL1")
    @obja = ChemblIdLookup.find("CHEMBL1000000")
    @objt = ChemblIdLookup.find("CHEMBL1075021")
    @objd = ChemblIdLookup.find("CHEMBL1126670")
  end
  
  def test_attributes
    assert_equal("CHEMBL1", @obj.chembl_id)
    assert_equal("COMPOUND", @obj.entity_type)
    assert_equal(517180, @obj.entity_id)
    assert_equal("ACTIVE", @obj.status)
  end
  
  def test_entity
    assert_equal(Molecule, @obj.entity.class)
    assert_equal(Assay, @obja.entity.class)
    assert_equal(Target, @objt.entity.class)
    assert_equal(Doc, @objd.entity.class)    
  end
  
  def test_assay
    a = @obja.assay
    assert_equal(Assay, a.class)
  end
  
  def test_compound
    c = @obj.compound
    assert_equal(Molecule, c.class)
  end
  
  def test_target
    t = @objt.target
    assert_equal(Target, t.class)
  end
  
  def test_document
    d = @objd.document
    assert_equal(Doc, d.class)
  end
end


class CompoundPropertyTest < Test::Unit::TestCase
  def setup
    @obj = CompoundProperty.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.molregno)
    assert_equal(341.74798583984375, @obj.mw_freebase)
    assert_equal(3.3440001010894775, @obj.alogp)
    assert_equal(4, @obj.hba)
    assert_equal(1, @obj.hbd)
    assert_equal(78.83999633789062, @obj.psa)
    assert_equal(3, @obj.rtb)
    assert_equal("N", @obj.ro3_pass)
    assert_equal(0, @obj.num_ro5_violations)
    assert_equal("Y", @obj.med_chem_friendly) 
    assert_equal(6.443999767303467, @obj.acd_most_apka) 
    assert_equal(nil, @obj.acd_most_bpka)
    assert_equal(3.186000108718872, @obj.acd_logp)
    assert_equal(2.2209999561309814, @obj.acd_logd)
    assert_equal("ACID", @obj.molecular_species)
    assert_equal(341.74798583984375, @obj.full_mwt)
  end
  
  def test_belongs_to_molecule
    m = @obj.molecule
    assert_equal(Molecule, m.class)
  end
end


class CompoundRecordTest < Test::Unit::TestCase
  def setup
    @obj = CompoundRecord.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.record_id) 
    assert_equal(41, @obj.molregno)
    assert_equal(11788, @obj.doc_id) 
    assert_equal("X", @obj.compound_key)
    assert_equal("Bis(3-[14-Benzyl-11-(1H-indol-3-ylmethyl)-2-isobutyl-13-methyl-5-(2-methylsulfanyl-ethyl)-3,6,9,12,15,20-hexaoxo-1,4,7,10,13,16-hexaaza-bicyclo[15.2.1]icos-18-en-8-yl]-propionamide)", @obj.compound_name)
    assert_equal(1, @obj.src_id)
    assert_equal(nil, @obj.src_compound_id)
  end
  
  def test_belongs_to_molecule
    m = @obj.molecule
    assert_equal(Molecule, m.class)
  end
  
  def test_belongs_to_doc
    m = @obj.doc
    assert_equal(Doc, m.class)
  end
  
  def test_belongs_to_source
    m = @obj.source
    assert_equal(Source, m.class)
  end
  
  def test_has_many_activities
    a = @obj.activities
    assert_equal(Array, a.class)
    assert_equal(Activity, a.first.class)
  end
end


class CompoundStructureTest < Test::Unit::TestCase
  def setup
    @obj = CompoundStructure.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.molregno) 
    assert_equal("\n          11280714432D 1   1.00000     0.00000     0\n\n 24 26  0     0  0            999 V2000\n    5.2792   -2.0500    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.7917   -2.3500    0.0000 N   0  0  3  0  0  0           0  0  0\n    5.2792   -1.4500    0.0000 N   0  0  0  0  0  0           0  0  0\n    6.3125   -2.0500    0.0000 N   0  0  0  0  0  0           0  0  0\n    5.7875   -4.7417    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.7875   -4.1417    0.0000 C   0  0  0  0  0  0           0  0  0\n    6.3125   -1.4500    0.0000 C   0  0  0  0  0  0           0  0  0\n    6.3042   -5.0417    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.7917   -1.1500    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.7917   -2.9500    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.2667   -3.8417    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.2667   -3.2417    0.0000 C   0  0  0  0  0  0           0  0  0\n    6.3042   -3.8417    0.0000 C   0  0  0  0  0  0           0  0  0\n    4.7542   -2.3417    0.0000 O   0  0  0  0  0  0           0  0  0\n    6.3042   -5.6417    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.2667   -5.0417    0.0000 O   0  0  0  0  0  0           0  0  0\n    6.3042   -3.2417    0.0000 C   0  0  0  0  0  0           0  0  0\n    5.7917   -0.5500    0.0000 O   0  0  0  0  0  0           0  0  0\n    5.7792   -5.9417    0.0000 Cl  0  0  0  0  0  0           0  0  0\n    6.8167   -4.7417    0.0000 C   0  0  0  0  0  0           0  0  0\n    4.7417   -4.1417    0.0000 C   0  0  0  0  0  0           0  0  0\n    6.8250   -5.9417    0.0000 C   0  0  0  0  0  0           0  0  0\n    7.3417   -5.0417    0.0000 C   0  0  0  0  0  0           0  0  0\n    7.3417   -5.6417    0.0000 C   0  0  0  0  0  0           0  0  0\n  2  1  1  0     0  0\n  3  1  1  0     0  0\n  4  2  1  0     0  0\n  5  6  1  0     0  0\n  6 13  1  0     0  0\n  7  9  1  0     0  0\n  8  5  1  0     0  0\n  9  3  1  0     0  0\n 10  2  1  0     0  0\n 11 12  1  0     0  0\n 12 10  2  0     0  0\n 13 17  2  0     0  0\n 14  1  2  0     0  0\n 15  8  2  0     0  0\n 16  5  2  0     0  0\n 17 10  1  0     0  0\n 18  9  2  0     0  0\n 19 15  1  0     0  0\n 20  8  1  0     0  0\n 21 11  1  0     0  0\n 22 15  1  0     0  0\n 23 20  2  0     0  0\n 24 23  1  0     0  0\n  4  7  2  0     0  0\n 11  6  2  0     0  0\n 22 24  2  0     0  0\nM  END", @obj.molfile)
    assert_equal("InChI=1S/C17H12ClN3O3/c1-10-8-11(21-17(24)20-15(22)9-19-21)6-7-12(10)16(23)13-4-2-3-5-14(13)18/h2-9H,1H3,(H,20,22,24)", @obj.standard_inchi)
    assert_equal("OWRSAHYFSSNENM-UHFFFAOYSA-N", @obj.standard_inchi_key)
    assert_equal("Cc1cc(ccc1C(=O)c2ccccc2Cl)N3N=CC(=O)NC3=O", @obj.canonical_smiles)
    assert_equal("C17 H12 Cl N3 O3", @obj.molformula)
  end
  
  def test_belongs_to_molecule
    m = @obj.molecule
    assert_equal(Molecule, m.class)
  end
end


class ConfidenceScoreLookupTest < Test::Unit::TestCase
  def setup
    @obj = ConfidenceScoreLookup.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.confidence_score)
    assert_equal("Target assigned is non-molecular", @obj.description)
    assert_equal("Non-molecular", @obj.target_mapping)
  end
  
  def test_blongs_to_assay2target
    a = @obj.assay2target
    assert_equal(Assay2target, a.class)
  end
end


class CurationLookupTest < Test::Unit::TestCase
  def setup
    @obj = CurationLookup.find("Expert")
  end
  
  def test_attributes
    assert_equal("Expert", @obj.curated_by) 
    assert_equal("Curated against ChEMBL target assignment from original publication", @obj.decription)
  end
  
  def test_has_many_assay2targets
    a = @obj.assay2targets
    assert_equal(Array, a.class)
    assert_equal(Assay2target, a.first.class)
  end
end


class DefinedDailyDoseTest < Test::Unit::TestCase
  def setup
    @obj = DefinedDailyDose.find(1)
  end
  
  def test_attributes
    assert_equal("A01AA01", @obj.atc_code)
    assert_equal(1.100000023841858, @obj.ddd_value)    
    assert_equal("mg", @obj.ddd_units)        
    assert_equal("O", @obj.ddd_admr)
    assert_equal("0.5 mg Fluoride", @obj.ddd_comment)            
    assert_equal(1, @obj.ddd_id)    
  end
  
  def test_belongs_to_atc_classification
    r = @obj.atc_classification
    assert_equal(AtcClassification, r.class)
  end
end


class DocTest < Test::Unit::TestCase
  def setup
    @obj = Doc.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.doc_id) 
    assert_equal("J. Med. Chem.", @obj.journal)
    assert_equal("2004", @obj.year)
    assert_equal("47", @obj.volume)
    assert_equal("1", @obj.issue)
    assert_equal("1", @obj.first_page)
    assert_equal("9", @obj.last_page)
    assert_equal(14695813, @obj.pubmed_id)
    assert_equal(nil, @obj.doi) 
    assert_equal("CHEMBL1139451", @obj.chembl_id)
    assert_equal(nil, @obj.title)
    assert_equal("PUBLICATION", @obj.doc_type)
  end
  
  def test_belongs_to_chembl_id_lookup
    c = @obj.chembl_id_lookup
    assert_equal(ChemblIdLookup, c.class)
  end
  
  def test_has_many_assays
    a = @obj.assays
    assert_equal(Array, a.class)
    assert_equal(Assay, a.first.class)
  end
  def test_has_many_compound_records
    a = @obj.compound_records
    assert_equal(Array, a.class)
    assert_equal(CompoundRecord, a.first.class)
  end
end


class FormulationTest < Test::Unit::TestCase  
  def setup
    @obj = Formulation.find("PRODUCT19072")
  end
  
  def test_attributes
    assert_equal("PRODUCT19072", @obj.product_id) 
    assert_equal("INFLIXIMAB", @obj.ingredient) 
    assert_equal(nil, @obj.strength)   
    assert_equal(675617, @obj.molregno)
  end
  
  def test_belongs_to_product
    a = @obj.product
    assert_equal(Product, a.class)
  end
  
  def test_belongs_to_molecule 
    a = @obj.molecule
    assert_equal(Molecule, a.class)
  end
end


class LigandEffTest < Test::Unit::TestCase
  def setup
    @obj = LigandEff.find(1994982)
  end
  
  def test_attributes
    assert_equal(1994982, @obj.activity_id)
    assert_equal(25.239999771118164, @obj.bei)
    assert_equal(20.760000228881836, @obj.sei)
  end
  
  def test_belongs_to_activity
    a = @obj.activity
    assert_equal(Activity, a.class)
  end
end


class MoleculeTest < Test::Unit::TestCase
  def setup
    @obj = Molecule.find(1)
    @objs = Molecule.find(97)
    @objf = Molecule.find(675423)
    @objt = Molecule.find(48705)
  end
  
  def test_attributes
    assert_equal(1, @obj.molregno) 
    assert_equal(nil, @obj.pref_name) 
    assert_equal("CHEMBL6329", @obj.chembl_id) 
    assert_equal(0, @obj.max_phase) 
    assert_equal(0, @obj.therapeutic_flag)
    assert_equal(0, @obj.dosed_ingredient)
    assert_equal("MOL", @obj.structure_type) 
    assert_equal(100001, @obj.chebi_id) 
    assert_equal(nil, @obj.chebi_par_id)
    assert_equal("Small molecule", @obj.molecule_type)
    assert_equal(nil, @obj.first_approval)
    assert_equal(0, @obj.oral)
    assert_equal(0, @obj.parenteral) 
    assert_equal(0, @obj.topical)
    assert_equal(0, @obj.black_box_warning)
    assert_equal(0, @obj.natural_product)
    assert_equal(0, @obj.prodrug) 
  end
  
  def test_belongs_to_chembl_id_lookup
    a = @obj.chembl_id_lookup
    assert_equal(ChemblIdLookup, a.class)
  end               

  def test_has_many_compound_records
    a = @obj.compound_records
    assert_equal(Array, a.class)
    assert_equal(CompoundRecord, a.first.class)
  end
    
  def test_has_many_molecule_synonyms
    a = @objs.molecule_synonyms
    assert_equal(Array, a.class)
    assert_equal(MoleculeSynonym, a.first.class)
  end
    
  def test_has_one_molecule_hierarchy
    a = @obj.molecule_hierarchy
    assert_equal(MoleculeHierarchy, a.class)      
  end

  def test_has_one_compound_property
    a = @obj.compound_property
    assert_equal(CompoundProperty, a.class)
  end
  
  def test_has_one_compound_structure
    a = @obj.compound_structure
    assert_equal(CompoundStructure, a.class)
  end

  def test_has_one_formulation
    a = @objf.formulation
    assert_equal(Formulation, a.class)
  end

  def test_has_one_protein_therapeutic
    a = @objt.protein_therapeutic
    assert_equal(ProteinTherapeutic, a.class)
  end
end


class MoleculeHierarchyTest < Test::Unit::TestCase
  def setup
    @obj = MoleculeHierarchy.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.molregno) 
    assert_equal(1, @obj.parent_molregno)
    assert_equal(1, @obj.active_molregno)
  end
  
  def test_belongs_to_molecule
    a = @obj.molecule
    assert_equal(Molecule, a.class)
  end

  def test_belongs_to_parent
    a = @obj.parent
    assert_equal(Molecule, a.class)
  end

  def test_belongs_to_active
    a = @obj.active
    assert_equal(Molecule, a.class)
  end
end


class MoleculeSynonymTest < Test::Unit::TestCase
  def setup
    @obj = MoleculeSynonym.find(97)
  end
  
  def test_attributes
    assert_equal(97, @obj.molregno) 
    assert_equal("CP-12299", @obj.synonyms) 
    assert_equal("RESEARCH_CODE", @obj.syn_type)
    assert_equal("CP", @obj.research_stem)  
  end
  
  def test_belongs_to_molecule
    a = @obj.molecule
    assert_equal(Molecule, a.class)
  end
  
  def test_has_and_belongs_to_many_research_codes
    a = @obj.research_codes
    assert_equal(Array, a.class)
    assert_equal(ResearchCode, a.first.class)
  end
end


class OrganismClassTest < Test::Unit::TestCase
  def setup
    @obj = OrganismClass.find(1)
  end
  
  def test_attributes
    assert_equal(1, @obj.oc_id) 
    assert_equal(10030, @obj.tax_id)
    assert_equal("Eukaryotes", @obj.l1)
    assert_equal("Mammalia", @obj.l2) 
    assert_equal("Rodentia", @obj.l3)
  end
  
  def test_has_many_assays
    a = @obj.assays
    assert_equal(Array, a.class)
    assert_equal(Assay, a.first.class)
  end

  def test_has_many_targets
    a = @obj.targets
    assert_equal(Array, a.class)
    assert_equal(Target, a.first.class)
  end
end


class ProductTest < Test::Unit::TestCase
  def setup
    @obj = Product.find("PRODUCT19072")
  end
  
  def test_attributes
    assert_equal(nil, @obj.dosage_form) 
    assert_equal(nil, @obj.route)
    assert_equal("REMICADE", @obj.trade_name) 
    assert_equal(nil, @obj.approval_date) 
    assert_equal(nil, @obj.ad_type)
    assert_equal(0, @obj.oral)
    assert_equal(0, @obj.topical)
    assert_equal(1, @obj.parenteral) 
    assert_equal("CDER", @obj.information_source)
    assert_equal(nil, @obj.black_box_warning) 
    assert_equal("CENTOCOR INC", @obj.applicant_full_name) 
    assert_equal(nil, @obj.innovator_company) 
    assert_equal("PRODUCT19072", @obj.product_id)
  end
  
  def test_has_many_formulations
    a = @obj.formulations
    assert_equal(Array, a.class)
    assert_equal(Formulation, a.first.class)
  end
end


class ProteinTherapeuticTest < Test::Unit::TestCase
  def setup
    @obj = ProteinTherapeutic.find(48705)
  end
  
  def test_attributes
    assert_equal(48705, @obj.molregno) 
    assert_equal("Oxytocin-neurophysin 1 [Precursor]", @obj.protein_description)
    assert_equal("MAGPSLACCLLGLLALTSACYIQNCPLGGKRAAPDLDVRKCLPCGPGGKGRCFGPNICCAEELGCFVGTAEALRCQEENYLPSPCQSGQKACGSGGRCAVLGLCCSPDGCHADPACDAEATFSQR", @obj.protein_sequence)
    assert_equal("Homo sapiens", @obj.protein_species)
    assert_equal(125, @obj.protein_sequence_length) 
    assert_equal(nil, @obj.mature_peptide_sequence)
  end
  
  def test_belongs_to_molecule
    a = @obj.molecule
    assert_equal(Molecule, a.class) 
  end
end


class RelationshipTypeTest < Test::Unit::TestCase  
  def setup
    @obj = RelationshipType.find("D")
  end
  
  def test_attributes
    assert_equal("D", @obj.relationship_type)
    assert_equal("Direct protein target assigned", @obj.relationship_desc)
  end
  
  def test_has_many_assay2targets
    a = @obj.assay2targets
    assert_equal(Array, a.class)
    assert_equal(Assay2target, a.first.class)
  end
end


class ResearchCodeTest < Test::Unit::TestCase  
  def setup
    @obj = ResearchCode.find("Eisai")
  end
  
  def test_attributes
    assert_equal("E", @obj.stem) 
    assert_equal("Eisai", @obj.company)
    assert_equal("Japan", @obj.country)
    assert_equal(nil, @obj.previous_company)
  end
  
  def test_has_many_molecule_synonyms
    a = @obj.molecule_synonyms
    assert_equal(Array, a.class)
    assert_equal(MoleculeSynonym, a.first.class)
  end
end


class SourceTest < Test::Unit::TestCase
  def setup
    @obj = Source.find(2)
    @obj5 = Source.find(5)
  end
  
  def test_attributes
    assert_equal(2, @obj.src_id)
    assert_equal("GSK Malaria Screening", @obj.src_description)
  end
  
  def test_has_many_assays
    a = @obj.assays
    assert_equal(Array, a.class)
    assert_equal(Assay, a.first.class)
  end
  
  def test_has_many_compound_records
    a = @obj5.compound_records
    assert_equal(Array, a.class)
    assert_equal(CompoundRecord, a.first.class)
  end
end


class TargetClassTest < Test::Unit::TestCase
  def setup
    @obj = TargetClass.find(2568)
  end
  
  def test_attributes
    assert_equal(2568, @obj.tc_id) 
    assert_equal(169, @obj.tid)
    assert_equal("Ion channel", @obj.l1)
    assert_equal("VGC", @obj.l2)
    assert_equal("VGC", @obj.l3)
    assert_equal("VOLT", @obj.l4)
    assert_equal("CATIONIC", @obj.l5)
    assert_equal("CA", @obj.l6)
    assert_equal("CACN alpha-1, CaVx.x", @obj.l7)
    assert_equal("L-TYPE", @obj.l8)
    assert_equal("ion channel  vgc  vgc  volt  cationic  ca  cacn alpha-1, cavx.x  l-type", @obj.target_classification)
  end
  
  def test_belongs_to_target
    a = @obj.target
    assert_equal(Target, a.class)    
  end
end


class TargetTest < Test::Unit::TestCase
  def setup
    @obj = Target.find(1)
    @objt = Target.find(11695)
  end
  
  def test_attributes
    assert_equal(1, @obj.tid) 
    assert_equal("PROTEIN", @obj.target_type) 
    assert_equal("SWISS-PROT", @obj.db_source) 
    assert_equal("Maltase-glucoamylase, intestinal", @obj.description) 
    assert_equal("MGAM; MGA; MGAML", @obj.gene_names) 
    assert_equal("Maltase-glucoamylase", @obj.pref_name) 
    assert_equal("Maltase-glucoamylase, intestinal; Maltase; Glucoamylase; Alpha-glucosidase; Glucan 1,4-alpha-glucosidase", @obj.synonyms) 
    assert_equal("3D-structure; Cell membrane; Complete proteome; Direct protein sequencing; Disulfide bond; Glycoprotein; Glycosidase; Hydrolase; Membrane; Multifunctional enzyme; Polymorphism; Reference proteome; Repeat; Signal-anchor; Sulfation; Transmembrane; Transmembrane helix", @obj.keywords) 
    assert_equal("MARKKLKKFTTLEIVLSVLLLVLFIISIVLIVLLAKESLKSTAPDPGTTGTPDPGTTGTPDPGTTGTTHARTTGPPDPGTTGTTPVSAECPVVNELERINCIPDQPPTKATCDQRGCCWNPQGAVSVPWCYYSKNHSYHVEGNLVNTNAGFTARLKNLPSSPVFGSNVDNVLLTAEYQTSNRFHFKLTDQTNNRFEVPHEHVQSFSGNAAASLTYQVEISRQPFSIKVTRRSNNRVLFDSSIGPLLFADQFLQLSTRLPSTNVYGLGEHVHQQYRHDMNWKTWPIFNRDTTPNGNGTNLYGAQTFFLCLEDASGLSFGVFLMNSNAMEVVLQPAPAITYRTIGGILDFYVFLGNTPEQVVQEYLELIGRPALPSYWALGFHLSRYEYGTLDNMREVVERNRAAQLPYDVQHADIDYMDERRDFTYDSVDFKGFPEFVNELHNNGQKLVIIVDPAISNNSSSSKPYGPYDRGSDMKIWVNSSDGVTPLIGEVWPGQTVFPDYTNPNCAVWWTKEFELFHNQVEFDGIWIDMNEVSNFVDGSVSGCSTNNLNNPPFTPRILDGYLFCKTLCMDAVQHWGKQYDIHNLYGYSMAVATAEAAKTVFPNKRSFILTRSTFAGSGKFAAHWLGDNTATWDDLRWSIPGVLEFNLFGIPMVGPDICGFALDTPEELCRRWMQLGAFYPFSRNHNGQGYKDQDPASFGADSLLLNSSRHYLNIRYTLLPYLYTLFFRAHSRGDTVARPLLHEFYEDNSTWDVHQQFLWGPGLLITPVLDEGAEKVMAYVPDAVWYDYETGSQVRWRKQKVEMELPGDKIGLHLRGGYIFPTQQPNTTTLASRKNPLGLIIALDENKEAKGELFWDNGETKDTVANKVYLLCEFSVTQNRLEVNISQSTYKDPNNLAFNEIKILGTEEPSNVTVKHNGVPSQTSPTVTYDSNLKVAIITDIDLLLGEAYTVEWSIKIRDEEKIDCYPDENGASAENCTARGCIWEASNSSGVPFCYFVNDLYSVSDVQYNSHGATADISLKSSVYANAFPSTPVNPLRLDVTYHKNEMLQFKIYDPNKNRYEVPVPLNIPSMPSSTPEGQLYDVLIKKNPFGIEIRRKSTGTIIWDSQLLGFTFSDMFIRISTRLPSKYLYGFGETEHRSYRRDLEWHTWGMFSRDQPPGYKKNSYGVHPYYMGLEEDGSAHGVLLLNSNAMDVTFQPLPALTYRTTGGVLDFYVFLGPTPELVTQQYTELIGRPVMVPYWSLGFQLCRYGYQNDSEIASLYDEMVAAQIPYDVQYSDIDYMERQLDFTLSPKFAGFPALINRMKADGMRVILILDPAISGNETQPYPAFTRGVEDDVFIKYPNDGDIVWGKVWPDFPDVVVNGSLDWDSQVELYRAYVAFPDFFRNSTAKWWKREIEELYNNPQNPERSLKFDGMWIDMNEPSSFVNGAVSPGCRDASLNHPPYMPHLESRDRGLSSKTLCMESQQILPDGSLVQHYNVHNLYGWSQTRPTYEAVQEVTGQRGVVITRSTFPSSGRWAGHWLGDNTAAWDQLKKSIIGMMEFSLFGISYTGADICGFFQDAEYEMCVRWMQLGAFYPFSRNHNTIGTRRQDPVSWDVAFVNISRTVLQTRYTLLPYLYTLMHKAHTEGVTVVRPLLHEFVSDQVTWDIDSQFLLGPAFLVSPVLERNARNVTAYFPRARWYDYYTGVDINARGEWKTLPAPLDHINLHVRGGYILPWQEPALNTHLSRQKFMGFKIALDDEGTAGGWLFWDDGQSIDTYGKGLYYLASFSASQNTMQSHIIFNNYITGTNPLKLGYIEIWGVGSVPVTSVSISVSGMVITPSFNNDPTTQVLSIDVTDRNISLHNFTSLTWISTL", @obj.protein_sequence) 
    assert_equal("376cfb3aaf307eb3aacfb30367c8a66e", @obj.protein_md5sum) 
    assert_equal(9606, @obj.tax_id) 
    assert_equal("Homo sapiens", @obj.organism) 
    assert_equal(nil, @obj.tissue) 
    assert_equal(nil, @obj.strain) 
    assert_equal("2012_05", @obj.db_version) 
    assert_equal(nil, @obj.cell_line) 
    assert_equal("O43451", @obj.protein_accession)
    assert_equal("3.2.1.3", @obj.ec_number)
    assert_equal("CHEMBL2074", @obj.chembl_id)
  end
  
  def test_belongs_to_target_type_ 
    a = @obj.target_type_
    assert_equal(TargetType, a.class)
  end
  
  def test_belongs_to_chembl_id_lookup 
    a = @obj.chembl_id_lookup
    assert_equal(ChemblIdLookup, a.class)
  end      
  
  def test_belongs_to_organism_class
    a = @obj.organism_class
    assert_equal(OrganismClass, a.class)
  end

  def test_has_many_target_classes 
    a = @objt.target_classes
    assert_equal(Array, a.class)
    assert_equal(TargetClass, a.first.class)
  end        
        
  def test_has_and_belongs_to_many_assays 
    a = @obj.assays
    assert_equal(Array, a.class)
    assert_equal(Assay, a.first.class)
  end
end


class TargetTypeTest < Test::Unit::TestCase
  def setup
    @obj = TargetType.find("ADMET")
  end
  
  def test_attributes
    assert_equal("ADMET", @obj.target_type) 
    assert_equal("ADMET", @obj.target_desc)
  end
  
  def test_has_many_targets
    a = @obj.targets
    assert_equal(Array, a.class)
    assert_equal(Target, a.first.class)
  end
end


class VersionTest < Test::Unit::TestCase
  def setup
    @version = Version.find("ChEMBL_14")
  end
  
  def test_attributes
    assert_equal("ChEMBL_14", @version.name)
    assert_equal(Date, @version.creation_date.class) 
    assert_equal(Date.parse("2012-06-27"), @version.creation_date) 
    assert_equal("2012-06-27", @version.creation_date.to_s) 
    assert_equal("ChEMBL release 14", @version.comments) 
  end
  
  def test_find_all
    a = Version.find(:all)
    assert_equal(Array, a.class)
    assert_equal(Version, a.first.class)
  end
end