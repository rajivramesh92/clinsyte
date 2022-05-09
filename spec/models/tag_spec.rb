require 'rails_helper'

RSpec.describe Tag, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  # Associations
  it { is_expected.to have_many(:compounds) }

end
