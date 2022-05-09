require 'rails_helper'

RSpec.describe Template, type: :model do
  
  describe "Assosiations" do
    it { is_expected.to have_one(:template_data) }
    it { is_expected.to belong_to(:strain) }
    it { is_expected.to belong_to(:creator) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:strain) }
    it { is_expected.to validate_presence_of(:creator) }
    it { is_expected.to validate_presence_of(:name) }
  end

end
