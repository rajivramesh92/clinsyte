class UnavailableSlot < Slot

  # Validations
  validate :date_validity


  # Excludes unnecessary old unavailable slots
  # Considers only slots which are added for today and later
  default_scope { where("date >= ?", Date.today) }

  private

  # Checks if from_time is less than to_time
  def date_validity
    self.errors.add(:date, "is invalid") if self.date < Date.today
  end

end