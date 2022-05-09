require 'rails_helper'

RSpec.describe RangeBasedAnswer, type: :model do

  describe "Validations" do
    it { is_expected.to validate_presence_of(:value) }
  end

end
