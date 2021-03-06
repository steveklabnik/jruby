require 'rubygems'
require 'action_controller'
require 'action_controller/integration'
require 'benchmark'

env = {"QUERY_STRING"=>nil, "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"/foo/do_something", "HTTP_HOST"=>"www.example.com", "REMOTE_ADDR"=>"127.0.0.1", "SERVER_PORT"=>"80", "CONTENT_TYPE"=>"application/x-www-form-urlencoded", "CONTENT_LENGTH"=>nil, "HTTP_COOKIE"=>"", "HTTPS"=>"off", "HTTP_ACCEPT"=>"text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"}
data = nil

StubCGI = ActionController::Integration::Session::StubCGI
(ARGV[0] || 10).to_i.times {
  Benchmark.bm(30) {|bm|
    bm.report("StubCGI.new") { 100000.times { StubCGI.new(env, data) } }
    cgi = StubCGI.new(env, data)
    session_options = {:database_manager=>CGI::Session::CookieStore, :prefix=>"ruby_sess.", :session_path=>"/", :session_key=>"_session_id", :cookie_only=>true, :tmpdir=>"/Users/headius/NetBeansProjects/jruby/optz_tests/tmp/sessions/"}
    bm.report("CGIRequest.new") { 100000.times { ActionController::CgiRequest.new(cgi, session_options) } }
    bm.report("CGIResponse.new") { 100000.times { ActionController::CgiResponse.new(cgi) } }
  }
}