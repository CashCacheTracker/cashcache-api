class TransactionResource < JSONAPI::Resource
  attributes :date, :description, :is_split, :location, :note, :value
end
