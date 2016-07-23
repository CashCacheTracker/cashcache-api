require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:transaction_data) do
    {
      type: 'transactions',
      attributes: {
        date: 7.days.ago.to_date,
        value: 20,
        description: 'Groceries',
        location: 'Whole Foods',
        'is-split': false,
        note: 'So many limes!'
      }
    }
  end

  describe 'index' do
    it 'lists transactions' do
      n = rand(2..10)
      for i in 1..n do create(:transaction, description: "Transaction #{i}") end

      jget transactions_path

      expect(status).to eq 200
      expect(jdata.length).to eq n
    end
  end

  describe 'create' do
    it 'creates transaction' do
      jpost transactions_path, params: {
        data: transaction_data
      }

      expect(status).to eq 201
      transaction = Transaction.find jdata['id']
      expect(transaction.date).to eq transaction_data[:attributes][:date]
      expect(transaction.value).to eq transaction_data[:attributes][:value]
      expect(transaction.description).to eq transaction_data[:attributes][:description]
      expect(transaction.location).to eq transaction_data[:attributes][:location]
      expect(transaction.note).to eq transaction_data[:attributes][:note]
      expect(transaction.is_split).to be transaction_data[:attributes][:'is-split']
    end

    it 'creates transaction with minimal data' do
      transaction_data[:attributes].except!(:location, :note, :'is-split')

      jpost transactions_path, params: {
        data: transaction_data
      }

      expect(status).to eq 201
      transaction = Transaction.find jdata['id']
      expect(transaction.date).to eq transaction_data[:attributes][:date]
      expect(transaction.value).to eq transaction_data[:attributes][:value]
      expect(transaction.description).to eq transaction_data[:attributes][:description]
      expect(transaction.is_split).to be false
    end
  end

  describe 'update' do
    it 'updates transaction' do
      record = create(:transaction)
      transaction_data[:id] = record.id

      jpatch "#{transactions_path}/#{record.id}", params: {
        data: transaction_data
      }
      record.reload

      expect(status).to eq 200
      expect(record.date).to eq transaction_data[:attributes][:date]
      expect(record.value).to eq transaction_data[:attributes][:value]
      expect(record.description).to eq transaction_data[:attributes][:description]
      expect(record.location).to eq transaction_data[:attributes][:location]
      expect(record.note).to eq transaction_data[:attributes][:note]
      expect(record.is_split).to eq transaction_data[:attributes][:'is-split']
    end
  end
end
