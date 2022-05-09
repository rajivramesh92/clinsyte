describe EventIndependentSurveySender do

  describe "#get_time_zone_diff" do
    context "when this function is invoked for a receipient" do
      context "when receipient is from Time Zone 'America/Los_Angeles'" do
        let!(:user1) { FactoryGirl.create(:user, :time_zone => 'America/Los_Angeles') }
        it "should return the time difference in seconds with +ve and -ve info" do
          expect(EventIndependentSurveySender.new.get_time_zone_diff(user1)).to eq(ActiveSupport::TimeZone.new(user1.time_zone).utc_offset)
        end
      end

      context "when receipient is from Time Zone 'Chennai'" do
        let!(:user1) { FactoryGirl.create(:user, :time_zone => 'Chennai') }
        it "should return the time difference in seconds with +ve and -ve info" do
          expect(EventIndependentSurveySender.new.get_time_zone_diff(user1)).to eq(ActiveSupport::TimeZone.new(user1.time_zone).utc_offset)
        end
      end
    end
  end

  describe "#get_interval" do
    context "when the user in some TimeZone" do
      let!(:user) { FactoryGirl.create(:user, :time_zone => 'Chennai') }
      let!(:survey_configuration) { FactoryGirl.create(:survey_configuration, :schedule_time => '8:00:00') }

      before do
        d = Date.today
        t = Time.parse("00:00:00")
        dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
        Timecop.freeze(dt)
      end

      it "should return the time after which the survey needs to be scheduled" do
        # Current time in users time zone is 5:30
        # Survey needs to be sent at 8:00
        # difference is 2.5 hrs
        expect(EventIndependentSurveySender.new.get_interval(survey_configuration.schedule_time, user)).to eq(2.5*60*60)
      end
    end

    context "when the user in some TimeZone" do
      let!(:user) { FactoryGirl.create(:user, :time_zone => 'Pacific Time (US & Canada)') }
      let!(:survey_configuration) { FactoryGirl.create(:survey_configuration, :schedule_time => '8:00:00') }

      before do
        d = Date.yesterday
        t = Time.parse("00:00:00")
        dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
        Timecop.freeze(dt)
      end

      it "should return the time after which the survey needs to be scheduled" do
        # User is 8 hours behind UTC
        # Survey needs to be sent at 8:00
        # difference is 16 hrs
        expect(EventIndependentSurveySender.new.get_interval(survey_configuration.schedule_time, user)).to eq(16*60*60)
      end
    end

    context "when the user in some TimeZone" do
      let!(:user) { FactoryGirl.create(:user, :time_zone => 'Chennai') }
      let!(:survey_configuration) { FactoryGirl.create(:survey_configuration, :schedule_time => '3:00:00') }

      before do
        d = Date.today
        t = Time.parse("00:00:00")
        dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
        Timecop.freeze(dt)
      end

      it "should return the time after which the survey needs to be scheduled" do
        # Survey needs to be sent after 21.5 hours as the time has alreday passed in +5:30 Time zone.
        # So the survey is scheduled for the next day
        expect(EventIndependentSurveySender.new.get_interval(survey_configuration.schedule_time, user)).to eq(21.5*60*60)
      end
    end
  end

end