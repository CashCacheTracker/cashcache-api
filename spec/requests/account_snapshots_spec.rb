require 'rails_helper'

RSpec.describe 'AccountSnapshots', type: :request do
  let(:account_snapshot_data) do
    {
      type: 'account_snapshots',
      attributes: {
        value: 42,
        note: 'a note goes here',
        month: 1.month.ago.at_beginning_of_month.to_date
      },
      relationships: {
        account: {
          data: {
            type: "accounts",
            id: account_record.id
          }
        }
      }
    }
  end

  let(:account_record) do
    create(:account, name: "Test account")
  end

  describe 'index' do
    it 'lists account snapshots' do
      n = rand(2..10)
      for i in 1..n do create(:account_snapshot, note: "Snapshot #{i}") end

      jget account_snapshots_path

      expect(status).to eq 200
      expect(jdata.length).to eq n
    end
  end

  describe 'create' do
    it 'creates account snapshot' do
      jpost account_snapshots_path, params: {
        data: account_snapshot_data
      }

      expect(status).to eq 201
      account_snapshot = AccountSnapshot.find jdata['id']
      expect(account_snapshot.value).to eq account_snapshot_data[:attributes][:value]
      expect(account_snapshot.note).to eq account_snapshot_data[:attributes][:note]
      expect(account_snapshot.month).to eq account_snapshot_data[:attributes][:month]
      expect(account_snapshot.account.id).to eq account_record.id
    end
  end

  describe 'update' do
    it 'updates account snapshot' do
      record = create(:account_snapshot)
      account_snapshot_data[:id] = record.id

      jpatch "#{account_snapshots_path}/#{record.id}", params: {
        data: account_snapshot_data
      }
      record.reload

      expect(status).to eq 200
      expect(record.value).to eq account_snapshot_data[:attributes][:value]
      expect(record.note).to eq account_snapshot_data[:attributes][:note]
      expect(record.month).to eq account_snapshot_data[:attributes][:month]
      expect(record.account.id).to eq account_record.id
    end
  end
end
