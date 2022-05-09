class EventDependentSurvey < ActiveRecord::Base

  # Assosiations
  belongs_to :survey
  belongs_to :physician, :class_name => 'User'
  has_many :receipients, {
    :as => :survey,
    :class_name => SurveyReceipient,
    :dependent => :destroy
  }

  # Validations
  validates_presence_of :survey
  validates_presence_of :physician
  validates_presence_of :time

end