# A module which gives a endpoint to list the records which matches
# the query given via params.
#
# Example:
# When this mixin is included the 'UsersController', then it creates
# '/users' endpoint which behaves in the following way.
#
# '/users' => Returns first 10 users
# '/users?search[name]=Co' => Returns first 10 users whose name is starting with 'Co'
# '/users?search[name]=Co&search[age]=20' => Returns first 10 users whose name is starting with 'Co' and age is 20
# '/users?page=10&count=5' => Returns first 5 records on 10th page
#

module Concerns
  module Searchable
    extend ActiveSupport::Concern

    included do
      cattr_reader :klass, :serializer
    end

    def index
      begin
        results = SearchService.new(klass, search_params).search
        success_serializer_responder(paginate(results), serializer)
      rescue RuntimeError => e
        error_serializer_responder(e.message)
      end
    end

    private

    def search_params
      params['search'].map do |key, value|
        {
          :key => key.to_s,
          :value => value.to_s
        }
      end rescue []
    end
  end
end
