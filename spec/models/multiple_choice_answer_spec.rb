require 'rails_helper'

RSpec.describe MultipleChoiceAnswer, type: :model do

  describe "Validations" do
    it { is_expected.to validate_presence_of(:choice) }
  end
end
