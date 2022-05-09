class SlotSerializer < BaseSerializer

  attributes :id,
    :day,
    :from_time,
    :to_time,
    :date,
    :type

  private

  def type
    object.type == 'AvailableSlot' ? 'available' : 'unavailable'
  end

end