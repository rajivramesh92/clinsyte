require 'rails_helper'

RSpec.describe Compound, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  # Associations
  it { is_expected.to have_many(:tags).through(:tag_connections) }
  it { is_expected.to have_many(:compound_strains) }
  it { is_expected.to have_many(:strains).through(:compound_strains) }

end
