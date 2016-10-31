require 'rails_helper'

def create_accounts(n)
  (1..n).each { |i| create(:account, name: "Account #{i}") }
end

RSpec.describe 'NetWorthSnapshots', type: :request do
  describe 'index' do
    it 'lists net worth snapshots' do
      account_count = 3
      month_count = 6
      account_value = 100
      create_accounts(account_count)
      accounts = Account.all

      # Create a snapshot for each of the #{account_count} accounts
      # across #{month_count} months
      (1..month_count).each do |month_age|
        month = month_age.months.ago.at_beginning_of_month.to_date
        (0...account_count).each do |i|
          create(
            :account_snapshot,
            value: account_value,
            month: month,
            account: accounts[i]
          )
        end
      end

      jget net_worth_snapshots_path

      expect(status).to eq 200
      expect(jdata.length).to eq month_count # One snapshot per month

      # Each month's snapshot sums account snapshots correctly
      sum = account_value * account_count
      (0...month_count).each do |i|
        expect(jdata[i]['attributes']['total']).to eq sum
      end
    end
  end
end
