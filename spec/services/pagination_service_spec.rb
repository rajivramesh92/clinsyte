describe PaginationService do

  describe '#paginate' do
    context "when a collection is passed" do
      context "when the input is active record collection" do
        let!(:record) { FactoryGirl.create_list(:user , 25)}

        context "when both page and count parameters has been passed" do
          it "should return items on the specified page with the given offset" do
            expect(PaginationService.new(User.all, :page => 5, :count => 5).paginate).to eq(User.limit(5).offset(20))
          end
        end

        context "when only page parameter is provided" do
          context "when page is not exist(i.e no more elements on the collection)" do
            it "should return empty collection" do
              expect(PaginationService.new(User.all, :page => 1000).paginate).to eq([])
            end
          end

          context "when page dont have number of items requested" do
            let!(:symptoms) { FactoryGirl.create_list(:symptom , 23)}

            it "should return available items" do
              expect(PaginationService.new(Symptom.all, :page => 3).paginate).to eq(symptoms[-3..-1])
            end
          end
        end

        context "when neither page nor count parameters are provided" do
          it "should return with default page and per page params" do
            expect(PaginationService.new(User.all).paginate).to eq(User.first(10))
          end
        end
      end

      context "when the collection is an array" do 
        let(:array) { (1..1000).to_a }

        context "when no page parameters has been passed" do
          it "should return with default page elements" do 
            expect(PaginationService.new(array , :page => 2).paginate).to eq(array[10...20])
          end
        end

        context "when neither page nor count is passed" do
          it "should return with default page and per page elements" do
            expect(PaginationService.new(array).paginate).to eq(array[0...10])
          end
        end
      end

      context "when the collection being passed is empty" do
        it "should return with empty collection" do
          expect(PaginationService.new([]).paginate).to eq([])
        end
      end

      context "when the input is nil" do
        it "should return with empty collection" do
          expect(PaginationService.new(nil).paginate).to eq([])
        end
      end

      context "when the inputs are invalid" do
        it "should raise Invalid input exception" do
          expect do 
            PaginationService.new([], :page => "something", :count => {}).paginate
          end.to raise_exception("Inputs are invalid")
        end
      end
    end

  end 
end