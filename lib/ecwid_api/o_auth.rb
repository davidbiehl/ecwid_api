require "cgi"
require "ostruct"

module EcwidApi
  # Public: Authentication objects manage OAuth authentication with an Ecwid
  #         store.
  #
  # Examples
  #
  #   app = EcwidApi::Authentication.new do |config|
  #     # see initialize for configuration
  #   end
  #
  #   app.oauth_url  # send the user here to authorize the app
  #
  #   token = app.access_token(params[:code]) # this is the code they provide
  #                                           # to the redirect_uri
  #   token.access_token
  #   token.store_id      # these are what you need to access the API
  #
  class OAuth
    CONFIG = %w(client_id client_secret scope request_uri)
    attr_accessor *CONFIG

    # Public: Initializes a new Ecwid Authentication for OAuth
    #
    # Examples
    #
    #   app = EcwidApi::Authentication.new do |config|
    #     config.client_id     = "some client id"
    #     config.client_secret = "some client secret"
    #     config.scope         "this_is_what_i_want_to_do oh_and_that_too"
    #     config.request_uri   = "https://example.com/oauth"
    #   end
    #
    def initialize
      yield(self) if block_given?
      CONFIG.each do |method|
        raise Error.new("#{method} is required to initialize a new EcwidApi::Authentication") unless send(method)
      end
    end

    # Public: The URL for OAuth authorization.
    #
    # This is the URL that the user will need to go to to authorize the app
    # with the Ecwid store.
    #
    def oauth_url
      "https://my.ecwid.com/api/oauth/authorize?" + oauth_query
    end

    # Public: Obtain the access token in order to use the API
    #
    # code - the temporary code obtained from the authorization callback
    #
    # Examples
    #
    #   token = app.access_token(params[:code])
    #   token.access_token  # the access token that authenticates each API request
    #   token.store_id      # the authenticated Ecwid store_id
    #
    # Returns an OpenStruct which responds with the information needed to
    # access the API for a store.
    def access_token(code)
      response = connection.post("/api/oauth/token",
        client_id:     client_id,
        client_secret: client_secret,
        code:          code,
        request_uri:   request_uri,
        grant_type:    "authorization_code"
      )

      if response.success?
        OpenStruct.new(response.body)
      else
        raise Error.new(response.body["error_description"])
      end
    end

    private

    # Private: The query parameters for the OAuth authorization request
    #
    # Returns a String of query parameters
    def oauth_query
      {
        client_id:     client_id,
        scope:         scope,
        response_type: "code",
        request_uri:   request_uri
      }.map do |key, val|
        "#{CGI.escape(key.to_s)}=#{CGI.escape(val.to_s)}"
      end.join(?&)
    end

    # Private: Returns a connection for obtaining an access token from Ecwid
    #
    def connection
      @connection ||= Faraday.new "https://my.ecwid.com" do |conn|
        conn.request  :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.adapter  Faraday.default_adapter
      end
    end
  end
end