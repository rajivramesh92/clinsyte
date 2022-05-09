describe NumericalCodeGenerator do

  describe "#generate" do
    context "when the length is passed" do
      context "when the length is valid" do
        it "should return the number in specified length of digits" do
          pin = described_class.new(10).generate
          expect(pin).to be_kind_of(Numeric)
          expect(pin.to_s.length).to eq(10)
        end
      end

      context "when the length is invalid" do
        it "should raise 'Invalid length' error" do
          expect do
            described_class.new("something")
          end.
          to raise_exception("Invalid length")
        end
      end
    end

    context "when the length is not passed" do
      it "should return 6 digit number" do
        pin = described_class.new.generate
        expect(pin).to be_kind_of(Numeric)
        expect(pin.to_s.length).to eq(6)
      end
    end
  end
end