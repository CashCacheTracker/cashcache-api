FactoryGirl.define do
  factory :account_snapshot do
    value 1500
    note "includes $500 account credit from intro offer"
    month 6.months.ago.at_beginning_of_month.to_date
    account
  end
end
