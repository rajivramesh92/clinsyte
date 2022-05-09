describe Genetic do

  describe 'validations' do
    # Add required attributes here
    required_attributes = [
      :name,
      :patient
    ]

    required_attributes.each do | attribute |
        it { is_expected.to validate_presence_of(attribute) }
      end
    end

  describe 'Assosiations' do 
    it { is_expected.to belong_to(:patient).class_name(:User) }
    it { is_expected.to have_many(:variations) }
  end

end
