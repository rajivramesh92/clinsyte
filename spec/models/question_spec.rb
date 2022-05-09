require 'rails_helper'

RSpec.describe Question, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:survey) }
  it { is_expected.to have_many(:answers) }

end
