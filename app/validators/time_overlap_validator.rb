class TimeOverlapValidator < ActiveModel::Validator

  def validate(record)
    record.errors.add(:slot, 'already exists') if time_overlap?(record)
  end

  private

  def time_overlap?(record)
    matching_slots = Slot.where(:physician_id => record.physician_id, :type => record.type)
    if record.type.eql?('AvailableSlot')
      slots = matching_slots.send(record.day).to_a rescue []
    else
      slots = matching_slots.where(:date => record.date).to_a rescue []
    end
    slots.any? { |slot| (slot.from_time...slot.to_time).overlaps?(record.from_time.to_i...record.to_time.to_i) }
  end

end