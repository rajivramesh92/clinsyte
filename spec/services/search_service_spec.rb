describe SearchService do

  describe '#search' do
    before do
      FactoryGirl.create_list(:user , 20)
      FactoryGirl.create_list(:user , 20 , first_name: "Utkarsh")
    end

    context "when the collection passed is empty" do
      it "should return empty collection" do
        expect(SearchService.new(User.none , [{key: "email" , value: "test"}]).search).to eq(User.none)
      end
    end

    context "when the collection passed is nil" do
      it "should return with an exception message" do
        expect do
          SearchService.new(nil, [{key: "email", value: "test"}]).search
        end.to raise_exception("Invalid input")
      end
    end

    context "when the search options passed is empty" do
      it "should return the collection being passed" do
        expect(SearchService.new(User.all, []).search).to eq(User.all)
      end
    end

    context "when the search options is nil" do
      it "should return collection being passed" do
        expect(SearchService.new(User.all, nil).search).to eq(User.all)
      end
    end

    context "when both collection and search options passed are nil" do
      it "should return with an exception message" do
        expect do
          SearchService.new(nil , nil).search
        end.to raise_exception("Invalid input")
      end
    end

    context "when single search option is provided" do
      it "should return results matching the value of search option provided" do
        expect(SearchService.new(User.all, [{key: "email", value: "test"}]).search).to be_all { |user| user.email.starts_with?("test")}
      end
    end

    context "when multiple search options are provided" do
      it "should return results with the combination of all the search options " do
        expect(SearchService.new(User.all, [{key: "email", value: "test"} , {key: "gender", value: "Male"}]).search).to be_all { |user| user.email.starts_with?("test") or user.gender.starts_with?("Male")}
      end
    end

    context "when name is provided in the search options" do
      it "should return results matching the name value provided" do
        expect(SearchService.new(User.all, [{key: "first_name" , value: "Utka"}]).search).to be_all{ |user| user.first_name.starts_with?("Utka") }
        expect(SearchService.new(User.all, [{key: "first_name" , value: "Utka"}]).search.count).to be(20)
      end
    end

  end
end