require 'helper'
require 'bio-chembl/chembl.rb'

class TestBioChEMBL < Test::Unit::TestCase
  def test_website
    assert_equal("https://www.ebi.ac.uk/chembl/", BioChEMBL.website)
  end
end

