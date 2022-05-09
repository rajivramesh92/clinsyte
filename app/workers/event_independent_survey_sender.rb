# Worker to send the survey to all the patients of the Careteam
# from the configured Date
# recursivelly after the configured time interval
# at the specified time

# NOTE -> Surveys will be sent based on the Time Zone of the User
#         at the same time as configured by the Physician

# Run this command at UTC 00:00 to schedule the sidetiq worker time from that time
# and then from then on, it will run after every 24  hours

# Sidekiq.configure_server do |config|
#   Sidetiq::Clock.start!
# end

# This Worker is structured to run every day at midnight to handle all the cases

class EventIndependentSurveySender
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  # Specifies that Worker will be triggered daily at midnight according to UTC Timings.
  recurrence { daily }

  # Sidekiq config for this worker
  sidekiq_options :retry => 3, :queue => :surveys, :backtrace => true

  def perform
    SurveyConfiguration.eligible_to_validate.each do | survey_config |
      if survey_config.eligible_to_send?
        survey_config.update_last_acknowledged
        send_survey_to_receipient_time_zones(survey_config)
      end
    end
  end

  # Method to send Survey to all the Receipients at specified time considering user's Time Zones.
  def send_survey_to_receipient_time_zones(survey_config)
    receipients = survey_config.receipients.map(&:receiver_id)
    receipients.each do | receipient |
      time_interval = get_interval(survey_config.schedule_time, receipient) # gets the schedule time interval for the receipient in seconds
      EventIndependentSurveySubWorker.perform_in(time_interval.seconds, receipient, survey_config.id)
    end
  end

  # Method to calculate the time interval for triggereing the survey by the Sub Worker
  def get_interval(scheduled_time, receipient)
    receipients_time = get_receipients_time(receipient)
    receipients_date = receipients_time.to_date
    utc_date = Time.now.utc.to_date

    if utc_date.eql?(receipients_date)
      compensating_time = time_to_sec(scheduled_time) - time_to_sec(receipients_time)
      compensating_time >= 0 ? compensating_time : 86400 + compensating_time
    elsif utc_date > receipients_date
      get_time_zone_diff(receipient).abs + time_to_sec(scheduled_time)
    end
  end

  def get_receipients_time(receipient)
    time_zone_difference = get_time_zone_diff(receipient) # can be both +ve or -ve / is in seconds
    Time.now.utc + time_zone_difference
  end

  # Method to return Time zone difference, UTC as the base in seconds
  # Takes a default time zone if receiver's Time Zone is not supported
  def get_time_zone_diff(receipient)
    receipient = User.find(receipient)
    ActiveSupport::TimeZone.new(receipient.time_zone).utc_offset rescue ActiveSupport::TimeZone["UTC"].utc_offset
  end

  # Method to convert the scheduled time to seconds
  def time_to_sec(scheduled_time)
    scheduled_time.hour * 3600 + scheduled_time.min * 60 + scheduled_time.sec
  end

end
