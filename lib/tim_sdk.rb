require "tim_sdk/version"
require 'tim_sdk/sign'
require 'tim_sdk/api'

module TimSdk

  class TimServerError < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end

end
