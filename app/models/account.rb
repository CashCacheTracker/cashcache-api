class Account < ApplicationRecord
  enum balance_type: {
    cash: 0,
    asset: 1,
    debt: 2
  }
end
