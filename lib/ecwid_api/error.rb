module EcwidApi
  class Error < StandardError; end;

  class ResponseError < Error
    def initialize(response)
      if response.respond_to?(:reason_phrase)
        super("#{response.reason_phrase} (#{response.status})")
      else
        super "The Ecwid API responded with an error (#{response.status})"
      end
    end
  end
end