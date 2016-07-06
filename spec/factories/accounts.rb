FactoryGirl.define do
  factory :account do
    name 'Shells Embargo'
    balance_type :cash
    tax_advantaged false
    ticker nil
  end
end
