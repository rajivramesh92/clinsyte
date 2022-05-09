class SurveyReceipient < ActiveRecord::Base

  # Assosiations
  belongs_to :survey, :polymorphic => true

  def receiver
    User.find(self.receiver_id) rescue nil
  end

end
