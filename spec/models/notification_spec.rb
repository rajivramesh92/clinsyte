describe Notification do

  # Add required attributes here
  required_attributes = [
    :sender,
    :recipient,
    :category
  ]

  required_attributes.each do | attribute |
    it { is_expected.to validate_presence_of(attribute) }
  end

  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }

end
