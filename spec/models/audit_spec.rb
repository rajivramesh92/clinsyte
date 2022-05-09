require 'rails_helper'

RSpec.describe Audit, type: :model do

  describe '#create?' do
    context 'action is "create"' do
      let(:record) { FactoryGirl.create(:audit, :action => 'create') }

      it 'should return true' do
        expect(record).to be_create
      end
    end

    context 'action is anything else other than create' do
      let(:record) { FactoryGirl.create(:audit, :action => 'destroy') }

      it 'should return false' do
        expect(record).not_to be_create
      end
    end
  end

  describe '#update?' do
    context 'action is "update"' do
      let(:record) { FactoryGirl.create(:audit, :action => 'update') }

      it 'should return true' do
        expect(record).to be_update
      end
    end

    context 'action is anything else other than update' do
      let(:record) { FactoryGirl.create(:audit, :action => 'create') }

      it 'should return false' do
        expect(record).not_to be_update
      end
    end
  end

  describe '#destroy?' do
    context 'action is "destroy"' do
      let(:record) { FactoryGirl.create(:audit, :action => 'destroy') }

      it 'should return true' do
        expect(record).to be_destroy
      end
    end

    context 'action is anything else other than destroy' do
      let(:record) { FactoryGirl.create(:audit, :action => 'update') }

      it 'should return false' do
        expect(record).not_to be_destroy
      end
    end
  end

  describe '#set_created_time - Before Create Callback' do
    context 'action is "update"' do
      let!(:user) { FactoryGirl.create(:user) }

      before do
        user.update(:height => '120cm')
      end

      it 'should set the created time as the current time of auditing' do
        current_time = Time.zone.now
        Time.stub(:now).and_return(current_time)
        expect(user.audits.first.created_at.to_i).to eq(current_time.to_i)
      end
    end

    context 'action is "destroy"' do
      let!(:user) { FactoryGirl.create(:user) }

      before do
        user.destroy
      end

      it 'should create a record for "destroy"' do
        audit = Audit.find_by(:auditable => user, :action => 'destroy')
        expect(audit).to be_present
      end
    end
  end

  describe '#activity_name' do
    context 'auditable record is present' do
      context 'auditable class not implemented "activity_name" method' do
        let(:audit) { Audit.new(:auditable => Medication.new) }

        it 'should return the downcased name of auditable class' do
          expect(audit.activity_name).to eq(Medication.to_s.downcase)
        end
      end

      context 'auditable class implemented "activity_name" method' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          user.update(:height => '20')
        end

        it 'should return the result of "activity_name" method invocation' do
          expect(user.audits.first.activity_name).to eq(User.activity_name)
        end
      end
    end

    context 'auditable record is not present' do
      let(:audit) { Audit.new }

      it 'should return blank string' do
        expect(audit.activity_name).to be_blank
      end
    end
  end

  describe '#activity_value' do
    context 'auditable is present' do
      context 'auditable class not implemented "get_activity_value_for"' do
        let(:disease) { FactoryGirl.create(:disease) }

        it 'should return the result of "get_activity_value_for" method invocation' do
          audit = disease.audits.first
          expect(audit.activity_value).to eq(disease.get_activity_value_for(audit))
        end
      end

      context 'auditable class implemented "get_activity_value_for"' do
        let(:medication) { FactoryGirl.create(:medication) }
        let(:audit) { Audit.new(:auditable => medication) }

        it 'should return the audited_changes' do
          expect(audit.activity_value).to eq(audit.audited_changes)
        end
      end
    end

    context 'auditable is not present' do
      let(:audit) { Audit.new }

      it 'should return the audited_changes' do
        expect(audit.activity_value).to eq(audit.audited_changes)
      end
    end
  end

  # Class Methods
  describe '.filter_by_action' do
    context 'no input is passed' do
      it 'should return all the audits' do
        expect(Audit.filter_by_action).to eq(Audit.all)
      end
    end

    context 'empty array is passed' do
      it 'should return all the audits' do
        expect(Audit.filter_by_action([])).to eq(Audit.all)
      end
    end

    context 'a valid array of actions is passed' do
      it 'should return all the audits belongs to the given actions' do
        expect(Audit.filter_by_action(["Create", "Update"])).to eq(Audit.where(:action => ["create", "update"]))
      end
    end
  end

  describe '.filter_by_auditable' do
    context 'no input is passed' do
      it 'should return all the audits' do
        expect(Audit.filter_by_auditable).to eq(Audit.all)
      end
    end

    context 'empty array is passed' do
      it 'should return all the audits' do
        expect(Audit.filter_by_auditable([])).to eq(Audit.all)
      end
    end

    context 'a valid array of auditables is passed' do
      let(:disease) { FactoryGirl.create(:disease) }
      let(:symptom) { FactoryGirl.create(:symptom) }
      let(:medication) { FactoryGirl.create(:medication) }
      let!(:disease_medication_connection) {
        FactoryGirl.create(:disease_medication_connection, :disease => disease, :medication => medication)
      }
      let!(:disease_symptom_connection) {
        FactoryGirl.create(:disease_symptom_connection, :disease => disease, :symptom => symptom)
      }

      it 'should return all the audits belongs to the given actions' do
        result = Audit.where("( auditable_type like '%DiseaseSymptomConnection%' ) OR ( auditable_type like '%DiseaseMedicationConnection%' )")
        expect(Audit.filter_by_auditable(["Symptom", "Medication"])).to match_array(result)
      end
    end
  end

  describe '.filter_by_user_ids' do
    context 'no input is passed' do
      it 'should return all the audits' do
        expect(Audit.filter_by_user_ids).to eq(Audit.all)
      end
    end

    context 'An empty array of user ids is passed' do
      it 'should return all the audits' do
        expect(Audit.filter_by_user_ids([])).to eq(Audit.all)
      end
    end

    context 'A valid array of user ids passed' do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:disease) { FactoryGirl.create(:disease) }
      let!(:symptom) { FactoryGirl.create(:symptom) }
      let!(:medication) { FactoryGirl.create(:medication) }
      let!(:new_medication) { FactoryGirl.create(:medication) }
      let!(:disease_medication_connection) {
        FactoryGirl.create(:disease_medication_connection, :disease => disease, :medication => medication)
      }
      let!(:disease_symptom_connection) {
        FactoryGirl.create(:disease_symptom_connection, :disease => disease, :symptom => symptom)
      }

      before do
        Audit.as_user(user) do
          disease.update(:name => 'Something')
          disease_symptom_connection.destroy
          DiseaseMedicationConnection.create(:disease => disease, :medication => new_medication)
        end
      end

      it 'should return all audits associated with user ids' do
        user_ids = User.all.map(&:id)
        expect(Audit.filter_by_user_ids(user_ids)).to match_array(Audit.where(:user_id => user_ids))
      end
    end
  end

  describe '.filter_by_time' do
    it_should_behave_like "time_filter", "audit"
  end

end
