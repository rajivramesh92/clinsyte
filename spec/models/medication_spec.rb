require 'rails_helper'

RSpec.describe Medication, type: :model do

  # Validations
  it { is_expected.to validate_presence_of(:name) }

  # Associations
  it { is_expected.to have_many(:disease_connections) }
  it { is_expected.to have_many(:diseases).through(:disease_connections) }

end
