module RestMollom
  class MollomApi  
    attr_accessor :private_key, :public_key, :conn_options

    def initialize(options)
      @private_key = options[:private_key]
      @public_key = options[:public_key]
      
      @conn_header = {'Accept' => 'application/json'}
      @conn_options = {
        :site               => options[:site] || 'http://dev.mollom.com/v1',
        :request_token_path => "",
        :authorize_path     => "",
        :access_token_path  => "",
        :http_method        => :get
      }
      
      @oa_consumer = OAuth::Consumer.new(@public_key, @private_key, @conn_options)
      @oa_access = OAuth::AccessToken.new(@oa_consumer)
      
    end
    
    def site(action, options={}, params={})
      path = '/site'
      params = nil if params.empty?
      
      response = case action
                  when :list
                    @oa_access.get path, @conn_header
                  when :show
                    @oa_access.post "#{path}/#{options[:public_key]}", params, @conn_header
                  when :create
                    if @conn_options[:site].match(/dev/)
                      Net::HTTP.post_form(URI("#{@conn_options[:site]}#{path}"), params)
                    else
                      @oa_access.post path, params, @conn_header
                    end
                  when :update
                    @oa_access.post "#{path}/#{options[:public_key]}", params, @conn_header
                  when :delete
                    @oa_access.post "#{path}/#{options[:public_key]}", params, @conn_header
                  end
      
      parse_response response
    end

    def blacklist(action, params={})
      path = '/blacklist'
      id = params.delete :id
      
      response = case action
                  when :list
                    @oa_access.get "#{path}/#{@public_key}", params, @conn_header
                  when :show
                    @oa_access.get "#{path}/#{@public_key}/#{id}", params, @conn_header
                  when :create
                    @oa_access.post "#{path}/#{@public_key}", params, @conn_header
                  when :update
                    @oa_access.post "#{path}/#{@public_key}/#{id}", params, @conn_header
                  when :delete
                    @oa_access.post "#{path}/#{@public_key}/#{id}/delete", params, @conn_header
                  end
      
      parse_response response
    end

    def whitelist(action, params={})
      path = '/whitelist'
      id = params.delete :id
      
      response = case action
                  when :list
                    @oa_access.get "#{path}/#{@public_key}", params, @conn_header
                  when :show
                    @oa_access.get "#{path}/#{@public_key}/#{id}", params, @conn_header
                  when :create
                    @oa_access.post "#{path}/#{@public_key}", params, @conn_header
                  when :update
                    @oa_access.post "#{path}/#{@public_key}/#{id}", params, @conn_header
                  when :delete
                    @oa_access.post "#{path}/#{@public_key}/#{id}/delete", params, @conn_header
                  end
      
      JSON.parse response.body
    end
    
    def content(action, params={})
      path = '/content'
      id = params.delete :id
      
      response = case action
                  when :create
                    @oa_access.post path, params, @conn_header
                  when :update
                    @oa_access.post "#{path}/#{options[:id]}", params, @conn_header
                  else
                    reise 'Action not recognized'
                  end
      
      parse_response response
    end
    
    def captcha(action, params={})
      path = '/captcha'
      id = params.delete :id
      
      response = case action
                  when :create
                    @oa_access.post path, params, @conn_header
                  when :verify
                    @oa_access.post "#{path}/#{id}", params, @conn_header
                  end
      
      parse_response response
    end
    
    def feedback(action, params={})
      path = '/feedback'

      response = case action
                  when :create
                    @oa_access.post path, params, @conn_header
                  end
                  
      parse_response response
    end
    
    protected
    def parse_response(response)
      if response.code == '200'
        JSON.parse response.body
      else
        { :status => 'error', 
          :code => response.code, 
          :message => response.body }
      end
    end
  end
end
