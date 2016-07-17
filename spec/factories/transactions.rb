FactoryGirl.define do
  factory :transaction do
    value 3.50
    note "Came with extra onion. The cashier seemed nice."
    date { 1.day.ago.to_date }
    description "Footlong Sub"
    location "Jumbo Sandwich Co"
    is_split true # Split the bill, assumes party of two, 50/50
  end
end
