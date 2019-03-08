require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec', 'vcr_cassettes')
  c.allow_http_connections_when_no_cassette = false
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
end