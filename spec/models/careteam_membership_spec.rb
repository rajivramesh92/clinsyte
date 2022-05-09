require 'rails_helper'

RSpec.describe CareteamMembership, type: :model do
  # Validation specs
  it { is_expected.to validate_presence_of(:careteam) }
  it { is_expected.to validate_presence_of(:member) }

  it "should validate uniqueness on (member_id, careteam_id) - Composite Key" do
    subject.member = FactoryGirl.build(:user)
    is_expected.to validate_uniqueness_of(:member_id).scoped_to(:careteam_id)
  end

  # Association specs
  it { is_expected.to belong_to(:careteam) }
  it { is_expected.to belong_to(:member) }
  it { is_expected.to have_many(:audits) }

  it { is_expected.to be_basic }

  describe '.activity_name' do
    it 'should return "Careteam"' do
      expect(described_class.activity_name).to eq('Careteam')
    end
  end

  describe '.primary_physician' do
    let!(:careteam) { FactoryGirl.create(:careteam) }
    let!(:primary_physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }

    before do
      careteam.add_physician(primary_physician)
      careteam.add_physician(physician)
    end

    it "should return the primary physician among the members" do
      expect(careteam.careteam_memberships.primary_physician).to eq(primary_physician)
    end
  end

  describe '.make_primary!' do
    let(:careteam) { FactoryGirl.create(:careteam) }

    context "careteam has no primary physician" do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      it "should make the physician as primary" do
        careteam.add_physician(physician)
        expect(careteam.membership_level_of(physician)).to be_eql("primary")
      end
    end

    context "careteam has a primary physician already" do
      let(:primary_physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        careteam.add_physician(primary_physician)
        careteam.add_physician(physician)
      end

      it "should make the physician as primary" do
        careteam.careteam_memberships.make_primary!(physician)
        expect(careteam.membership_level_of(physician)).to be_eql("primary")
        expect(careteam.membership_level_of(primary_physician)).to be_eql("basic")
      end
    end
  end

  describe '.primary_membership' do
    let(:careteam) { FactoryGirl.create(:careteam) }

    context "careteam has primary physician" do
      let(:primary_physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        careteam.add_physician(primary_physician)
        careteam.add_physician(physician)
      end

      it "should return primary membership" do
        expect(careteam.careteam_memberships.primary_membership).to be_primary
      end
    end

    context "careteam does not have primary physician" do
      it "should return null" do
        expect(careteam.careteam_memberships.primary_membership).to be_nil
      end
    end    
  end

  describe '.membership_level_of' do
    let(:careteam) { FactoryGirl.create(:careteam) }
    let(:member) { FactoryGirl.create(:user) }

    before do
      careteam.add_member(member)
    end

    it "should return the level of membership" do
      expect(CareteamMembership.membership_level_of(member)).to be_eql("basic")
    end
  end

  # Callbacks
  describe '#after_destroy' do
    let(:careteam) { FactoryGirl.create(:careteam) }
    let(:member) { FactoryGirl.create(:user) }

    before do
      careteam.add_member(member)
    end

    context "careteam has no physicians" do
      it "should not set any one as primary physician" do
        careteam.remove_member(member)
        expect(careteam.reload.members).to be_empty
        expect(careteam.primary_membership).not_to be_present
      end
    end

    context "careteam has one physician" do
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        careteam.add_physician(physician)
      end

      it "should not set any one as primary physician" do
        careteam.remove_member(physician)
        expect(careteam.primary_membership).not_to be_present
      end
    end

    context "careteam have more than one physician" do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:physician1) { FactoryGirl.create(:user_with_physician_role) }
      let(:physician2) { FactoryGirl.create(:user_with_physician_role) }

      before do
        careteam.add_physician(physician)
        careteam.add_physician(physician1)
        careteam.add_physician(physician2)
      end

      it "should set any one of the physician as primary" do
        careteam.remove_member(physician)
        expect(careteam.primary_membership).to be_present
        expect(careteam.primary_physician).to be_eql(physician1)
      end
    end
  end

  describe '#get_activity_value_for' do
    let(:user) { FactoryGirl.create(:user) }
    let(:careteam_membership) { FactoryGirl.create(:careteam_membership, :member => user) }

    context 'action is update' do
      before do
        user.role = 'physician'
        careteam_membership.primary!
      end

      it 'should return levels' do
        audit = careteam_membership.audits.last
        value = careteam_membership.get_activity_value_for(audit)
        expect(value).to eq({ "level" => [ "basic", "primary" ] })
      end
    end

    context 'action is anything else other than update' do
      let(:user) { FactoryGirl.create(:user) }
      let(:careteam_membership) { FactoryGirl.create(:careteam_membership, :member => user) }

      it 'should return member and level' do
        audit = careteam_membership.audits.last
        value = careteam_membership.get_activity_value_for(audit)
        expect(value).to eq({ :member => UserMinimalSerializer.new(user).as_json, :level => 'basic' })
      end
    end
  end

end
