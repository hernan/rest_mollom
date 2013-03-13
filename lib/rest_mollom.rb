require 'oauth'
require 'json'
require 'rest_mollom/mollom_api'
require 'rest_mollom/content_response'
require "rest_mollom/version"

class RMollom
  include RestMollom
  
  attr_accessor :api
  
  #
  # options:
  # :site => api endpoint, default to production url
  # :public_key => mollom public_key
  # :private_key => mollom private_key
  #
  def initialize(options={})
    @debug = options.delete :debug
    @api = MollomApi.new(options)
  end
  
  def check_content(content={})
    response = @api.content(:create, content)
    return nil if response[:status] == 'error'
    
    ContentResponse.new response
  end
  
  def create_captcha(content={})
    content = {:type => 'image'}.merge!(content)
    @api.captcha(:create, content)
  end
  
  def valid_captcha?(content={})
    response = @api.captcha :verify, content
    response['captcha']['solved'] == '1'
  end

  
  protected
  def log(message)
    puts message if @debug
  end
end

