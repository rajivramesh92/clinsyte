class SurveyConfiguration < ActiveRecord::Base

  # Assosiation
  belongs_to :survey
  belongs_to :sender, :class_name => 'User'
  has_many :receipients, {
    :as => :survey,
    :class_name => SurveyReceipient,
    :dependent => :destroy
  }

  # Validations
  validates_presence_of :survey
  validates_presence_of :sender
  validates_presence_of :from_date
  validates_presence_of :days

  # Scope to filter the Surveys that can be checked for scheduling.
  # i.e the from date is less than or equal to current date.
  scope :eligible_to_validate, -> { where("from_date <= ? ", Time.now.utc.to_date) }

  # Instance Methods

  # Method to check if a survey configuration is to be scheduled today or not
  def eligible_to_send?
    if last_acknowledged.nil?
      is_acknowledgeable?
    elsif
      next_valid_timestamp = last_acknowledged.to_i + days.days.to_i
      next_valid_date = DateTime.strptime(next_valid_timestamp.to_s,'%s').to_date
      next_valid_date.eql?(Time.now.utc.to_date)
    end
  end

  # Survey configuration is acknowlledgeable if -
  #   current utc date is equal to from date
  def is_acknowledgeable?
    from_date.eql?(Time.now.utc.to_date)
  end

  # Method to update when the survey configuration was last acknowledged.
  # This helps to calculate when the survey configuration needs to be considered while scheduling.
  def update_last_acknowledged
    self.update(:last_acknowledged => DateTime.now)
  end

end
