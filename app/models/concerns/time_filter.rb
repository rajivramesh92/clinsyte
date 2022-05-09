module Concerns
  module TimeFilter
    extend ActiveSupport::Concern

    class_methods do

      def filter_by_time(filter_string)
        return all if filter_string.blank?

        filters = ['weeks', 'days', 'months', 'years']
        filter = nil

        begin
          @condition = Date.strptime(filter_string, "%d/%m/%Y")
        rescue
          filters.each do | value |
            if filter_string.pluralize.include? value
              filter = value
              break
            end
          end
          filter_value = /\d+/.match(filter_string).try(:[], 0).to_i
          @condition = filter_value.send(filter).ago rescue nil
        end

        self.where("DATE(created_at) >= ? ", @condition) rescue "Invalid filter"
      end

    end
  end
end