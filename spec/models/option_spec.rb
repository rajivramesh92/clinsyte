require 'rails_helper'

RSpec.describe Option, type: :model do

  # Assosiaitons
  it { is_expected.to belong_to(:list) }

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:list) }

end
