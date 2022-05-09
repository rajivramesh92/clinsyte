class ListDrivenQuestion < Question

  # Enum
  enum :category => [
    :multi_select,
    :single_select
  ]

  # Assosiations
  belongs_to :list

  # Validations
  validates_presence_of :list
  validates_presence_of :category

end
