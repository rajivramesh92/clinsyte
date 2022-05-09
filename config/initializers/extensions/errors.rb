ActiveModel::Errors.class_eval do

  def customized_full_messages
    customized.map do | field, msg |
      "#{field.to_s.titleize.capitalize} #{msg}".gsub(".", " ").humanize
    end
  end

  def customized
    messages.map do | field, msgs |
      { field => msgs.last }
    end.
    inject({}) do | base, element |
      base.merge(element)
    end
  end

  def full_unique_messages
    messages.map do | field, msgs |
      "#{field.to_s.capitalize} #{msgs.last}"
    end
  end

end