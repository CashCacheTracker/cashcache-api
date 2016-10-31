require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  let(:account_data) do
    {
      type: 'accounts',
      attributes: {
        name: '401k ClockCo Shares',
        'balance-type': 'asset',
        'tax-advantaged': true,
        ticker: 'TOCK'
      }
    }
  end

  describe 'index' do
    it 'lists accounts' do
      n = rand(2..10)
      (1..n).each { |i| create(:account, name: "Account #{i}") }

      jget accounts_path

      expect(status).to eq 200
      expect(jdata.length).to eq n
    end
  end

  describe 'create' do
    it 'creates account' do
      jpost accounts_path, params: {
        data: account_data
      }

      account = Account.find jdata['id']
      attributes = account_data[:attributes]

      expect(status).to eq 201
      expect(account.name).to eq attributes[:name]
      expect(account.balance_type).to eq attributes[:'balance-type']
      expect(account.tax_advantaged).to be attributes[:'tax-advantaged']
      expect(account.ticker).to eq attributes[:ticker]
    end
  end

  describe 'update' do
    it 'updates account' do
      record = create(:account)
      account_data[:id] = record.id

      jpatch "#{accounts_path}/#{record.id}", params: {
        data: account_data
      }
      record.reload
      attributes = account_data[:attributes]

      expect(status).to eq 200
      expect(record.name).to eq attributes[:name]
      expect(record.balance_type).to eq attributes[:'balance-type']
      expect(record.tax_advantaged).to be attributes[:'tax-advantaged']
      expect(record.ticker).to eq attributes[:ticker]
    end
  end
end
