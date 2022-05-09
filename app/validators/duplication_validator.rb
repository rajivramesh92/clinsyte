class DuplicationValidator < ActiveModel::Validator

  def initialize(options)
    super
    @fields = options[:fields]
  end

  def validate(record)
    @fields.each do |field|
      record.errors.add(field.to_sym, 'already exists') if already_exists?(record, field)
    end
  end

  private

  def already_exists?(record, field)
    record = User.where("CAST(#{field} AS text) ilike ? and status = ?", record.send(field).to_s, 0) rescue []
    record.present?
  end

end