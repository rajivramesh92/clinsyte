module Verifiable
  extend ActiveSupport::Concern

  included do | base |
    # Validations
    validates :verification_code, :presence => true, :uniqueness => true, :allow_nil => true

    # Callbacks
    before_create :set_default_verification_status
  end

  class_methods do
    def verifiable(fields_with_callbacks = {})
      @fields_with_callbacks = fields_with_callbacks
    end

    def verification_fields_with_callbacks
      @fields_with_callbacks
    end

    def verification_fields
      verification_fields_with_callbacks.keys
    end

    def is_verifiable_field?(field)
      verification_fields.include?(field.to_sym)
    end

    def callback_for(field)
      verification_fields_with_callbacks[field.to_sym]
    end
  end

  def set_default_verification_status
    consolidated_status = self.class.verification_fields.map do | field |
      { field => false }
    end.
    inject({}) do | base, field_with_status |
      base.merge(field_with_status)
    end

    self.verification_status = consolidated_status
  end

  def verify(field, verification_code)
    if valid_verification_code?(verification_code)
      self.send("#{field.to_s}_verify!")
    else
      self.errors.set(:verification_code, ["is invalid"])
      false
    end
  end

  def nullify_verification_code
    self.update_column :verification_code, nil
  end

  def set_verification_code
    self.update_column :verification_code, NumericalCodeGenerator.new.generate
  end

  def valid_verification_code?(verification_code)
    self.verification_code.present? && self.verification_code == verification_code
  end

  private

  def method_missing(method, *args, &block)
    super if self.class.verification_fields.empty?
    method_name = method.to_s

    if method_name.ends_with?("_verified?")
      field_name = method_name.gsub("_verified?", "")
      super unless self.class.is_verifiable_field?(field_name)
      !!self.verification_status[field_name]

    elsif method_name.ends_with?("_verify!")
      field_name = method_name.gsub("_verify!", "")
      super unless self.class.is_verifiable_field?(field_name)
      self.verification_status[field_name] ||= true
      self.update_column(:verification_code, nil)
      self.update_column(:verification_status, self.verification_status) and self.reload

    elsif method_name.starts_with?("send_") && method_name.ends_with?("_verification_code")
      field_name = method_name.gsub("send_", "").gsub("_verification_code", "")
      super unless self.class.is_verifiable_field?(field_name)
      self.set_verification_code
      self.send("#{self.class.callback_for(field_name)}") and self.reload

    else
      super
    end
  end

end