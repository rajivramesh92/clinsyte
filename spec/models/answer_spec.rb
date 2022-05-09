require 'rails_helper'

RSpec.describe Answer, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:creator).class_name(:User) }
  it { is_expected.to belong_to(:request).class_name(:UserSurveyForm) }

  # Validations
  it { is_expected.to validate_presence_of(:question) }
  it { is_expected.to validate_presence_of(:creator) }
  it { is_expected.to validate_presence_of(:request) }

end
