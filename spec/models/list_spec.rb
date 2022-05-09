require 'rails_helper'

RSpec.describe List, type: :model do

  describe 'Assosiations' do
    it { is_expected.to have_many(:options) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

end
