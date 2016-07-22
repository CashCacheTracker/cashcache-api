class NetWorthSnapshotResource < JSONAPI::Resource
  primary_key :month
  attributes :month, :total
end
