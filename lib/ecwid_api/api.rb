module EcwidApi
  # Internal: A base class for common API functionality
  class Api
    # Private: Gets the Client
    attr_reader :client
    private     :client

    # Public: Initializes a new EcwidApi::CategoryApi
    #
    # client - The EcwidApi::Client to use with the API
    #
    def initialize(client = EcwidApi.default_client)
      @client = client
      raise Error.new("The client cannot be nil") unless client
    end
  end
end