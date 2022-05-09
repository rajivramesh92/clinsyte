require 'rails_helper'

RSpec.describe Strain, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:brand_name) }

  # Associations
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:compound_strains) }
  it { is_expected.to have_many(:compounds).through(:compound_strains) }
  it { is_expected.to have_many(:tags).through(:compounds) }
end
