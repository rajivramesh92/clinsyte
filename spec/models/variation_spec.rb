describe Variation do

  describe 'validations' do
    # Add required attributes here
    required_attributes = [
      :name,
      :chromosome,
      :position,
      :genotype,
      :maf,
      :genetic
    ]

    required_attributes.each do | attribute |
        it { is_expected.to validate_presence_of(attribute) }
      end
    end

  describe 'Assosiations' do 
    it { is_expected.to belong_to(:genetic) }
    it { is_expected.to have_many(:phenotypes) }
  end

end
