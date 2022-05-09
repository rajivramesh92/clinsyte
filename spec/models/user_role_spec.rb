require 'rails_helper'

RSpec.describe UserRole, type: :model do

  # Association Specs
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:role) }

  # Validation Specs
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:role) }

  it "should validate uniqueness on (user_id, role_id) - Composite Key" do
    subject.user = FactoryGirl.build(:user)
    is_expected.to validate_uniqueness_of(:user_id).scoped_to(:role_id)
  end

  describe ".scopes" do
    before(:each) do
      Rails.application.load_seed
      roles = Role.all
      100.times do
        UserRole.create({
          :user => FactoryGirl.create(:user),
          :role => roles.sample
        })
      end
    end

    # Scope specs
    Role.all.each do | role |
      scope_name = role.pluralized_name
      helper_name = "#{role.underscored_name}?".to_sym

      describe ".#{scope_name}" do
        it "should return only #{scope_name}" do
          expect(described_class.send(scope_name)).to be_all(&helper_name)
        end
      end
    end
  end
end
