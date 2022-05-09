require 'rails_helper'

RSpec.describe CompoundStrain, type: :model do

  # Validation specs
  it { is_expected.to validate_presence_of(:compound) }
  it { is_expected.to validate_presence_of(:strain) }
  it { is_expected.to validate_presence_of(:high) }
  it { is_expected.to validate_presence_of(:low) }
  it { is_expected.to validate_presence_of(:average) }
  it do
    subject.compound = FactoryGirl.build(:compound)
    is_expected.to validate_uniqueness_of(:compound_id).scoped_to(:strain_id)
  end

  # Association specs
  it { is_expected.to belong_to(:compound) }
  it { is_expected.to belong_to(:strain) }

end
