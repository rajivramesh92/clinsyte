class SurveyConfigurationSerializer < BaseSerializer

  attributes :id,
    :from_date,
    :days,
    :schedule_time,
    :survey

  private

  def survey
    Survey.unscoped do
      SurveyMinimalSerializer.new(object.survey)
    end
  end

  def schedule_time
    time = object.schedule_time
    time ? "#{time.hour.to_s.rjust(2,'0')}:#{time.min.to_s.rjust(2,'0')}:#{time.sec.to_s.rjust(2,'0')}" : nil
  end

end