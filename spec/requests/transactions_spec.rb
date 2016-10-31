require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
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
      (1..n).each { |i| create(:transaction, description: "Transaction #{i}") }

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

      record = Transaction.find jdata['id']
      attributes = transaction_data[:attributes]

      expect(status).to eq 201
      expect(record.date).to eq attributes[:date]
      expect(record.value).to eq attributes[:value]
      expect(record.description).to eq attributes[:description]
      expect(record.location).to eq attributes[:location]
      expect(record.note).to eq attributes[:note]
      expect(record.is_split).to be attributes[:'is-split']
    end

    it 'creates transaction with minimal data' do
      transaction_data[:attributes].except!(:location, :note, :'is-split')

      jpost transactions_path, params: {
        data: transaction_data
      }

      record = Transaction.find jdata['id']
      attributes = transaction_data[:attributes]

      expect(status).to eq 201
      expect(record.date).to eq attributes[:date]
      expect(record.value).to eq attributes[:value]
      expect(record.description).to eq attributes[:description]
      expect(record.is_split).to be false
    end

    it 'creates transaction with location coordinate' do
      transaction_data[:attributes][:coordinate] = {
        longitude: 12.3,
        latitude: 45.6
      }
      jpost transactions_path, params: {
        data: transaction_data
      }

      record = Transaction.find jdata['id']
      attributes = jdata['attributes']

      expect(status).to eq 201
      expect(record.coordinate.x).to eq 12.3
      expect(record.coordinate.y).to eq 45.6
      expect(attributes['coordinate']['longitude']).to eq 12.3
      expect(attributes['coordinate']['latitude']).to eq 45.6
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
      attributes = transaction_data[:attributes]

      expect(status).to eq 200
      expect(record.date).to eq attributes[:date]
      expect(record.value).to eq attributes[:value]
      expect(record.description).to eq attributes[:description]
      expect(record.location).to eq attributes[:location]
      expect(record.note).to eq attributes[:note]
      expect(record.is_split).to eq attributes[:'is-split']
    end
  end
end
