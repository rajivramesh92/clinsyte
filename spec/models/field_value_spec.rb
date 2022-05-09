require 'rails_helper'

RSpec.describe FieldValue, type: :model do
  
  # Assosiation
  it { is_expected.to belong_to(:entity) }

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:value) }

end
