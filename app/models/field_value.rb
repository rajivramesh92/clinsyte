class FieldValue < ActiveRecord::Base

  # Assosiations
  belongs_to :entity, :polymorphic => true

  # Audit
  audited :associated_with => :entity

  # Validations
  validates_presence_of :name
  validates_inclusion_of :name, :in => ["as needed", "n times a day", "every n hours", "no more than n times a day"]
  validates :value, :presence => true, format: { with: /\A\d+\z/, message: "needs to be numeric" }, :unless => :validate_field?

  private

  def validate_field?
    return true if self.name == 'as needed'
  end

end
