class DescriptiveAnswer < Answer

  has_encrypted_column :description

  # Validations
  validates_presence_of :description

end
