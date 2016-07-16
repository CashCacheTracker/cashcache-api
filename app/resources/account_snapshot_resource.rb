class AccountSnapshotResource < JSONAPI::Resource
  attributes :month, :note, :value
  has_one :account
end
