require 'rails_helper'

RSpec.describe Careteam, type: :model do
  
  # Validation specs
  it { is_expected.to validate_presence_of(:patient) }

  # Association specs
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to have_many(:careteam_memberships) }
  it { is_expected.to have_many(:members).through(:careteam_memberships) }
  it { is_expected.to have_many(:associated_audits) }

  describe '#add_member' do
    let(:careteam) { FactoryGirl.create(:careteam) }
    let!(:user) { FactoryGirl.create(:user) }

    context "adding a new member" do
      it "should add the member to the careteam" do
        careteam.add_member(user)
        expect(careteam.members).to include(user)
      end
    end

    context "already a member" do
      before do
        careteam.add_member(user)
      end

      it "should not add the member again" do
        expect(careteam.add_member(user)).to be_eql("Already a member")
        expect(careteam.careteam_memberships.count(:member => user)).to eq(1)
      end
    end
  end

  describe '#add_physician' do
    let(:careteam) { FactoryGirl.create(:careteam) }
    let(:physician) { FactoryGirl.create(:user_with_physician_role) }

    context "physician is passed" do
      context "careteam does not have any physician" do
        it "should added a physician and make him primary" do
          careteam.add_physician(physician)
          expect(careteam.members).to include(physician)
          expect(careteam.membership_level_of(physician)).to be_eql("primary")
        end
      end

      context "careteam have minimum one physician" do
        let(:primary_physician) { FactoryGirl.create(:user_with_physician_role) }

        before do
          careteam.add_physician(primary_physician)
        end

        it "should add a physician and should not make him primary" do
          careteam.add_physician(physician)
          expect(careteam.members).to include(physician)
          expect(careteam.membership_level_of(physician)).not_to be_eql("primary")
        end
      end
    end

    context "patient is passed" do
      let(:patient) { FactoryGirl.create(:user) }

      it "should render 'Must be a physician' error" do
        expect(careteam.add_physician(patient)).to eq("Must be a physician")
        expect(careteam.members).not_to include(patient)
      end
    end
  end

  describe '#remove_member' do
    let(:careteam) { FactoryGirl.create(:careteam) }

    context "no member exists" do
      it "should not raise error" do
        expect do
          careteam.remove_member(User.new)
        end.
        not_to raise_error
      end
    end

    context "members exist" do
      let(:member) { FactoryGirl.create(:user) }

      before do
        careteam.add_member(member)
      end

      it "should remove the member" do
        expect do
          careteam.remove_member(member)
        end
        .to change(CareteamMembership, :count).by(-1)
        expect(careteam.reload.members).to be_empty
      end
    end
  end
end
