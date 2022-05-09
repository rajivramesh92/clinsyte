class Effect < ActiveRecord::Base
	has_and_belongs_to_many :strains
end
