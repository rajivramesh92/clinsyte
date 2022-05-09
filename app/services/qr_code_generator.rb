require 'rqrcode'

# A class to generate QR code for the string passed.

class QRCodeGenerator

  attr_reader :input, :format

  def initialize(input, format = 'png')
    raise 'Invalid input passed' unless input.present?
    @input = input
    @format = format.to_s.downcase
  end

  def generate
    RQRCode::QRCode.new(input, :size => 8, :level => :h)
    .send("as_#{format}")
  end
end