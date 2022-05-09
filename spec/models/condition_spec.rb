require 'rails_helper'

RSpec.describe Condition, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:diseases) }
  end
end
