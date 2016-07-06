class AccountResource < JSONAPI::Resource
  attributes :balance_type, :name, :tax_advantaged, :ticker
end
