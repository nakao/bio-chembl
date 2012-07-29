require 'active_record'

module BioChEMBL
  module ChEMBLDB


    # ActiveRecord classes for ChEMBL14 mysql dump
    # ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_14/
    # The ChEMBL14 ER diagram is ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_14/chembl_14_erd.png
    #
    # Usage:
    # 
    #   require 'bio-chembl/chembldb.rb'
    #
    #   ActiveRecord::Base.establish_connection( {:adapter => 'mysql', 
    #                                             :host => 'localhost',
    #                                             :port => 3306,
    #                                             :username => 'chembl', 
    #                                             :password => '', 
    #                                             :socket => '/tmp/mysql.sock',
    #                                             :database => 'chembl_14'} )
    #                                         
    #  accession = "Q00534"
    #  target = BioChEMBL::ChEMBLDB::Target.find_by_protein_accession(accession)
    #  puts "Target description:  #{target.description}"
    #  puts "Target CHEMBLID:     #{target.chembl_id}"
    #
    #  # ChEMBL ID
    #  chembl_id = "CHEMBL1"
    #  chemblid = BioChEMBL::ChEMBLDB::ChemblIdLookup.find(chembl_id)
    #  chemblid.entity_type 
    #  compound = chemblid.entity
    #    
    #  # Compound
    #  compound = BioChEMBL::ChEMBLDB::Molecule.find_by_chembl_id(chembl_id)
    #  activities = compound.compound_records.map {|x| x.activities }.flatten
    #
    #  # Target
    #  target = BioChEMBL::ChEMBLDB::Target.find_by_chembl_id(chembl_id)
    #  activities = target.assays.map {|x| x.activities }.flatten
    #
    #  # Assay
    #  assay = BioChEMBL::ChEMBLDB::Assay.find_by_chembl_id(chembl_id)
    #  activities = assay.activities
    #
    #
    
class Activity < ActiveRecord::Base
  self.primary_key = :activity_id
  attr_accessible :activity_id, 
                  :assay_id,
                  :doc_id,
                  :record_id,
                  :molregno,
                  :relation,
                  :published_value, 
                  :published_units,
                  :standard_value, 
                  :standard_units,
                  :standaerd_type, 
                  :activity_comment,
                  :published_activity_type 
  
  belongs_to :assay
  belongs_to :doc
  belongs_to :record, 
    :class_name => :CompoundRecord, :foreign_key => :record_id
  belongs_to :molecule, 
    :class_name => :Molecule, :foreign_key => :molregno
  
end


class AssayType < ActiveRecord::Base
  self.table_name = :assay_type
  self.primary_key = :assay_type
  attr_accessible :assay_type, 
                  :assay_desc

  has_many :assays,           
    :foreign_key => :assay_type
end


class Assay < ActiveRecord::Base
  self.primary_key = :assay_id
  attr_accessible :assay_id, 
                  :assay_type,
                  :description,
                  :doc_id,
                  :src_id,
                  :src_assay_id, 
                  :chembl_id,
                  :assay_category,
                  :assay_organism,
                  :assay_tax_id,
                  :assay_strain

  belongs_to :assay_type_,  
    :class_name => 'AssayType', :foreign_key => :assay_type
  belongs_to :doc
  belongs_to :src, 
    :class_name => 'Source'
  belongs_to :chembl_id_lookup, 
    :class_name => 'ChemblIdLookup', :foreign_key => :chembl_id
  belongs_to :assay_tax, 
    :foreign_key => :assay_tax_id, :class_name => 'OrganismClass', :primary_key => :tax_id 

  has_many :activities

  # assays.assay_id =  assay2taret.assay_id AND assay2target.tid = target_dictionary.tid
  has_and_belongs_to_many :targets, 
    :join_table => :assay2target,    
    :class_name => 'Target', :association_foreign_key => :tid
end


class Assay2target < ActiveRecord::Base
  self.table_name = 'assay2target'
  self.primary_key = :assay_id
  attr_accessible :assay_id, 
                  :tid, 
                  :relationship_type,
                  :complex, 
                  :multi, 
                  :confidence_score, 
                  :curated_by

  belongs_to :assay
  belongs_to :target, 
    :class_name => 'Target', :foreign_key => :tid
  belongs_to :relationship_type_,             
    :class_name => 'RelationshipType', :foreign_key => :relationship_type
  belongs_to :confidence_score_lookup_,      
    :class_name => 'ConfidenceScoreLookup', :foreign_key => :confidence_score
  belongs_to :curation_lookup,   
    :foreign_key => :curated_by
end


class AtcClassification < ActiveRecord::Base
  self.table_name = :atc_classification
  self.primary_key = :who_id
  attr_accessible :who_name, 
                  :level1,
                  :level2,
                  :level3,
                  :level4,
                  :level5,
                  :who_id,
                  :level1_description,
                  :level2_description,
                  :level3_description,
                  :level4_description
                  
  has_many :defined_daily_dose, 
    :foreign_key => :atc_code,   
    :class_name => 'DefinedDailyDose',:primary_key => :level5
end


class ChemblIdLookup < ActiveRecord::Base
  self.table_name = :chembl_id_lookup
  self.primary_key = :chembl_id
  attr_accessible :chembl_id, 
                  :entity_type, 
                  :entry_id, 
                  :status
                  
  has_one :assay,    
    :primary_key => :entity_id, 
    :class_name => 'Assay' ,   :foreign_key => :assay_id 
  has_one :target,   
    :primary_key => :entity_id, 
    :class_name => 'Target',   :foreign_key => :tid      
  has_one :compound, 
    :primary_key => :entity_id, 
    :class_name => 'Molecule', :foreign_key => :molregno 
  has_one :document, 
    :primary_key => :entity_id, 
    :class_name => 'Doc',      :foreign_key => :doc_id
  
  def entity
    # eval entity_type.downcase
    case entity_type
    when 'COMPOUND'
      compound
    when 'ASSAY'
      assay
    when 'TARGET'
      target
    when 'DOCUMENT'
      document
    end
  end
end


class CompoundProperty < ActiveRecord::Base
  self.primary_key = :molregno
  attr_accessible :molregno, 
                  :mw_freebase,
                  :alogp,
                  :hba,
                  :hbd,
                  :psa,
                  :rtb,
                  :ro3_pass,
                  :num_ro5_violations,
                  :med_chem_friendly, 
                  :acd_most_apka, 
                  :acd_most_bpka,
                  :acd_logp,
                  :acd_logd,
                  :molecular_species,
                  :full_mwt 

  belongs_to :molecule, 
    :class_name => 'Molecule', :foreign_key => :molregno
end


class CompoundRecord < ActiveRecord::Base
  self.primary_key = :record_id
  attr_accessible :record_id, 
                  :molregno,
                  :doc_id, 
                  :compound_key,
                  :compound_name,
                  :src_id,
                  :src_compound_id

  belongs_to :molecule, 
    :class_name => 'Molecule', :foreign_key => :molregno
  belongs_to :doc
  belongs_to :source, 
    :class_name => 'Source', :foreign_key => :src_id
             
  has_many :activities,
    :class_name => 'Activity', :foreign_key => :record_id
end


class CompoundStructure < ActiveRecord::Base
  self.primary_key = :molregno
  attr_accessible :molregno, 
                  :molfile,
                  :standard_inchi,
                  :standard_inchi_key,
                  :canonical_smiles,
                  :molformula

  belongs_to :molecule, 
    :class_name => 'Molecule', :foreign_key => :molregno
end


class ConfidenceScoreLookup < ActiveRecord::Base
  self.table_name = :confidence_score_lookup
  self.primary_key = :confidence_score
  attr_accessible :confidence_score, 
                  :description,
                  :target_mapping

  belongs_to :assay2target,
    :class_name => 'Assay2target', :foreign_key => :confidence_score
end


class CurationLookup < ActiveRecord::Base
  self.table_name = :curation_lookup
  self.primary_key = :curated_by
  attr_accessible :curated_by, 
                  :decription
                  
  has_many :assay2targets, 
    :class_name => 'Assay2target', :foreign_key => :curated_by
end


class DefinedDailyDose < ActiveRecord::Base
  self.table_name = :defined_daily_dose
  self.primary_key = :ddd_id
  attr_accessible :atc_code, 
                  :ddd_value, 
                  :ddd_units, 
                  :ddd_admr, 
                  :ddd_comment, 
                  :ddd_id
                  
  belongs_to :atc_classification, 
    :foreign_key => :atc_code,
    :class_name => 'AtcClassification', :primary_key => :level5
end


class Doc < ActiveRecord::Base
  attr_accessible :doc_id, 
                  :journal,
                  :year,
                  :volume,
                  :issue,
                  :first_page,
                  :last_page,
                  :pubmed_id,
                  :doi, 
                  :chembl_id,
                  :title,
                  :doc_type

  belongs_to :chembl_id_lookup, 
    :class_name => 'ChemblIdLookup', :foreign_key => :chembl_id
    
  has_many :assays,  
    :class_name => 'Assay'
  has_many :compound_records,  
    :class_name => 'CompoundRecord'
end


class Formulation < ActiveRecord::Base
  self.table_name = :formulations
  self.primary_key = :product_id
  attr_accessible :product_id, 
                  :ingredient, 
                  :strength, 
                  :molregno

  belongs_to :product
  belongs_to :molecule,
    :class_name => 'Molecule', :foreign_key => :molregno
end


class LigandEff < ActiveRecord::Base
  self.table_name = :ligand_eff
  self.primary_key = :activity_id
  attr_accessible :activity_id, 
                  :bei,
                  :sei

  belongs_to :activity
end


class Molecule < ActiveRecord::Base
  self.table_name = :molecule_dictionary
  self.primary_key = :molregno
  attr_accessible :molregno, 
                  :pref_name, 
                  :chembl_id, 
                  :max_phase, 
                  :therapeutic_flag,
                  :dosed_ingredient,
                  :structure_type, 
                  :chebi_id, 
                  :chebi_par_id,
                  :molecule_type,
                  :first_approval,
                  :oral,
                  :parenteral, 
                  :topical,
                  :black_box_warning,
                  :natural_product,
                  :prodrug 

  belongs_to :chembl_id_lookup, 
    :class_name => 'ChemblIdLookup', :foreign_key => :chembl_id

  has_many :compound_records, 
    :foreign_key => :molregno
  has_many :molecule_synonyms, 
    :foreign_key => :molregno
  

  has_one :compound_property,    
    :foreign_key => :molregno
  has_one :compound_structure,
    :foreign_key => :molregno, :primary_key => :molregno
  has_one :formulation, 
    :foreign_key => :molregno
  has_one :molecule_hierarchy, 
    :foreign_key => :molregno
  has_one :protein_therapeutic, 
    :foreign_key => :molregno
end


class MoleculeHierarchy < ActiveRecord::Base
  self.table_name = :molecule_hierarchy
  self.primary_key = :molregno
  attr_accessible :molregno, 
                  :parent_molregno,
                  :active_molregno

  belongs_to :molecule,  
    :class_name => 'Molecule', :foreign_key => :molregno
  belongs_to :parent, 
    :class_name => 'Molecule', :foreign_key => :parent_molregno
  belongs_to :active,
    :class_name => 'Molecule', :foreign_key => :active_molregno
end


class MoleculeSynonym < ActiveRecord::Base
  self.table_name = :molecule_synonyms
  self.primary_key = :molregno
  attr_accessible :molregno, 
                  :synonyms, 
                  :syn_type,
                  :research_stem

  belongs_to :molecule,
    :class_name => 'Molecule', :foreign_key => :molregno  
  has_many :research_codes,
    :class_name => 'ResearchCode', :primary_key => :research_stem, :foreign_key => :stem             
end


class OrganismClass < ActiveRecord::Base
  self.table_name = :organism_class
  self.primary_key = :oc_id
  attr_accessible :oc_id, 
                  :tax_id,
                  :l1,
                  :l2, 
                  :l3

  has_many :assays,
    :primary_key => :tax_id,
    :class_name => 'Assay', :foreign_key => :assay_tax_id
  has_many :targets,
    :primary_key => :tax_id,
    :class_name => 'Target', :foreign_key => :tax_id
end


class Product < ActiveRecord::Base
  attr_accessible :dosage_form, 
                  :route,
                  :trade_name, 
                  :approval_date, 
                  :ad_type,
                  :oral,
                  :topical,
                  :parenteral, 
                  :information_source,
                  :black_box_warning, 
                  :applicant_full_name, 
                  :innovator_company, 
                  :product_id
                  
  has_many :formulations,
    :class_name => 'Formulation', :foreign_key => :product_id
end


class ProteinTherapeutic < ActiveRecord::Base
  self.primary_key = :molregno
  attr_accessible :molregno, 
                  :protein_description,
                  :protein_sequence,
                  :protein_species,
                  :protein_sequence_length, 
                  :mature_peptide_sequence

  belongs_to :molecule, 
             :class_name => 'Molecule', :foreign_key => :molregno
end


class RelationshipType < ActiveRecord::Base
  self.table_name = :relationship_type
  self.primary_key = :relationship_type
  attr_accessible :relationship_type, 
                  :relationship_desc

  has_many :assay2targets, 
    :class_name => 'Assay2target', :foreign_key => :relationship_type
end


class ResearchCode < ActiveRecord::Base
  self.primary_key = :company
  attr_accessible :stem, 
                  :company,
                  :country,
                  :previous_company
                  
  has_many :molecule_synonyms,
    :class_name => 'MoleculeSynonym', :primary_key => :stem, :foreign_key => :research_stem
                  
end


class Source < ActiveRecord::Base
  self.table_name = :source
  self.primary_key = :src_id
  attr_accessible :src_id, 
                  :src_description
  
  has_many :assays,
    :foreign_key => :src_id
  has_many :compound_records,
    :foreign_key => :src_id
end


class TargetClass < ActiveRecord::Base
  self.table_name = :target_class
  self.primary_key = :tc_id
  attr_accessible :tc_id, 
                  :tid,
                  :l1,
                  :l2,
                  :l3,
                  :l4,
                  :l5,
                  :l6,
                  :l7,
                  :l8,
                  :target_classification
  
  belongs_to :target, 
    :class_name => 'Target', :foreign_key => :tid, :primary_key => :tid
end


class Target < ActiveRecord::Base
  self.table_name = :target_dictionary
  self.primary_key = :tid
  attr_accessible :tid, 
                  :target_type, 
                  :db_source, 
                  :description, 
                  :gene_names, 
                  :pref_name, 
                  :synonyms, 
                  :keywords, 
                  :protein_sequence, 
                  :protein_md5sum, 
                  :tax_id, 
                  :organism, 
                  :tissue, 
                  :strain, 
                  :db_version, 
                  :cell_line, 
                  :protein_accession,
                  :ec_number,
                  :chembl_id
                 
  belongs_to :target_type_, 
    :class_name => 'TargetType', :foreign_key => :target_type
  belongs_to :chembl_id_lookup, 
    :class_name => 'ChemblIdLookup', :foreign_key => :chembl_id
    
  belongs_to :organism_class,
    :class_name => 'OrganismClass', :foreign_key => :tax_id, :primary_key => :tax_id
  
  has_many :target_classes, 
    :class_name => 'TargetClass', :foreign_key => :tid
    
  # assays.assay_id =  assay2taret.assay_id AND assay2target.tid = target_dictionary.tid
  has_and_belongs_to_many :assays,   
    :join_table => :assay2target, :foreign_key => :tid,
    :class_name => 'Assay', :association_foreign_key => :assay_id
end


class TargetType < ActiveRecord::Base
  self.table_name = :target_type
  self.primary_key = :target_type
  attr_accessible :target_type, 
                  :target_desc
  
  has_many :targets,
    :class_name => 'Target', :foreign_key => :target_type
end


class Version < ActiveRecord::Base
  self.table_name = :version
  self.primary_key = :name
  attr_accessible :name,
                  :creation_date,
                  :comments
end

  end
end