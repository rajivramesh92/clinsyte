require 'rails_helper'

RSpec.describe Choice, type: :model do

  describe '#assosiations' do
    it { is_expected.to belong_to(:question) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of(:question) }
    it { is_expected.to validate_presence_of(:option) }
  end

  describe '#Callbacks' do
    context "when the user attempts to create choices" do
      context "when the question is multiple choice" do
        let!(:question) { FactoryGirl.create(:question, :type => 'MultipleChoiceQuestion') }

        it "should create the choices for the question" do
          expect(FactoryGirl.build(:choice, :question => question)).to be_valid
        end
      end
    end
  end

end