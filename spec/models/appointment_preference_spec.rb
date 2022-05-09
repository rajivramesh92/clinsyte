require 'rails_helper'

RSpec.describe AppointmentPreference, type: :model do

  describe '#Assosiations' do
    it { is_expected.to belong_to(:physician).class_name(:User) }
  end

  describe '#Validations' do
    required_attributes = [
      :physician
    ]

    required_attributes.each do | attribute |
      it { is_expected.to validate_presence_of(attribute) }
    end
  end
end
