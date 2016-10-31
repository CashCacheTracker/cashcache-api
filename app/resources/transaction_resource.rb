class TransactionResource < JSONAPI::Resource
  attributes(
    :coordinate,
    :date,
    :description,
    :is_split,
    :location,
    :note,
    :value
  )

  def coordinate
    coord = @model.coordinate
    return { longitude: nil, latitude: nil } if coord.nil?
    { longitude: coord.x, latitude: coord.y }
  end

  def coordinate=(coord)
    factory = ::RGeo::Geographic.simple_mercator_factory
    long = coord.fetch('longitude', nil)
    lat = coord.fetch('latitude', nil)
    point = factory.point(long, lat)
    @model.coordinate = point
  end
end
