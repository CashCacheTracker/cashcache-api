# JSON API request wrappers
%w(get post put patch delete).each do |method|
  define_method "j#{method}" do |url, options={}|
    options = options.deep_dup

    options[:headers] ||= {}
    options[:headers].merge!({
      'Accept' => JSONAPI::MEDIA_TYPE,
      'Content-Type' => JSONAPI::MEDIA_TYPE
    });

    options[:params] ||= {}
    options[:params] = options[:params].to_json unless options[:params].empty?

    status = send(method, url, options)

    status
  end
end

# Response helpers
def jbody
  JSON.parse(response.body) rescue {}
end

def jdata
  jbody['data']
end

def jerrors
  jbody['errors']
end

def jmeta
  jbody['meta']
end
