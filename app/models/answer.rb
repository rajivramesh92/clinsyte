class Answer < ActiveRecord::Base

  belongs_to :question, :inverse_of => :answers
  belongs_to :creator, :class_name => 'User'
  belongs_to :request, :class_name => 'UserSurveyForm'

  # Validations
  validates_presence_of :question
  validates_presence_of :creator
  validates_presence_of :request

  # Encryptable columns
  has_encrypted_column :value, :description

end
