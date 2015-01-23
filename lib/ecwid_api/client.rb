module EcwidApi
  # Public: Client objects manage the connection and interface to a single Ecwid
  # store.
  #
  # Examples
  #
  #   client = EcwidApi::Client.new(store_id: '12345', token: 'the access_token')
  #   client.get "/products"
  #
  class Client
    extend Forwardable

    # The default base URL for the Ecwid API
    DEFAULT_URL = "https://app.ecwid.com/api/v3"

    # Public: Returns the Ecwid Store ID
    attr_reader :store_id
    attr_reader :token
    attr_reader :adapter

    attr_reader :connection, :categories, :orders, :products

    # Public: Initializes a new Client to interact with the API
    #
    # store_id - the Ecwid store_id to interact with
    # token    - the authorization token provided by oAuth. See the
    #            Authentication class
    #
    def initialize(store_id, token, adapter = Faraday.default_adapter)
      @store_id, @token, @adapter = store_id, token, adapter

      @connection = Faraday.new store_url do |conn|
        conn.request  :oauth2, token, param_name: :token
        conn.request  :json

        conn.response :json, content_type: /\bjson$/
        conn.response :logger

        conn.adapter  adapter
      end

      @categories = Api::Categories.new(self)
      @orders     = Api::Orders.new(self)
      @products   = Api::Products.new(self)
    end

    # Public: The URL of the API for the Ecwid Store
    def store_url
      "#{DEFAULT_URL}/#{store_id}"
    end

    def_delegators :connection, :get, :post, :put, :delete
  end
end