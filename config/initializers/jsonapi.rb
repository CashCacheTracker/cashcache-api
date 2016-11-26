JSONAPI.configure do |config|
  config.default_paginator = :paged
  config.top_level_meta_include_page_count = true
  config.top_level_meta_include_record_count = true
  config.resource_key_type = :uuid
end
