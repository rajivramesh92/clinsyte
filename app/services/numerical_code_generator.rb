class NumericalCodeGenerator

  DEFAULT_LENGTH = 6

  def initialize(length = DEFAULT_LENGTH)
    raise "Invalid length" unless length.is_a?(Numeric)
    @length = length
  end

  def generate
    collection = (1..9).to_a.shuffle

    @length.times.map do | time |
      collection.sample
    end
    .join.to_i
  end
end