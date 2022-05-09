describe Phenotype do

  describe 'validations' do
        # Add required attributes here
    required_attributes = [
      :name,
      :variation
    ]

    required_attributes.each do | attribute |
        it { is_expected.to validate_presence_of(attribute) }
      end
    end

  describe 'Assosiations' do 
    it { is_expected.to belong_to(:variation) }
  end

end
