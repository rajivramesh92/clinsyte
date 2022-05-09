require 'rails_helper'

RSpec.describe TemplateDatum, type: :model do

  describe "Assosiations" do
    it { is_expected.to belong_to(:template) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:message) }
  end
end
