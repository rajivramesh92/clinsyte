require 'rails_helper'

describe AuditSerializer do

  describe '#as_json' do
    context 'auditable is present' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        user.update(:height => '20')
        @audit = Audit.first
      end

      it "should return jsonized data" do
        json = AuditSerializer.new(@audit).as_json
        expect(json).to eq({
          :action => 'update',
          :owner => nil,
          :message => {
            :name => 'basic info',
            :value => @audit.audited_changes,
            :association => nil
          },
          :timestamp => @audit.created_at.to_time.strftime("%s%3N")
        })
      end
    end

    context 'auditable is not present' do
      let(:audit) { Audit.new(:created_at => Time.zone.now) }

      it "should return jsonized data" do
        json = AuditSerializer.new(audit).as_json
        expect(json).to eq({
          :action => nil,
          :owner => nil,
          :message => {
            :name => "",
            :value => audit.audited_changes,
            :association => nil
          },
          :timestamp => audit.created_at.to_time.strftime("%s%3N")
        })
      end
    end
  end
end
