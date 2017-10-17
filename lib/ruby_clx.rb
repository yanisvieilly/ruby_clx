require 'net/http'

class RubyClx
  attr_writer :config

  def initialize
    yield config if block_given?
  end

  def config
    @config ||= OpenStruct.new
  end

  def send(from:, to:, text:)
    url = URI.parse(format_url(from, to, text))

    res = Net::HTTP.get_response(url)

    { code: res.code, message: res.message, body: res.body }
  end

  private

  def format_url(from, to, text)
    "https://#{config.host}:#{config.port}/sendsms?username=#{config.username}"\
    "&password=#{config.password}&from=#{from}&to=#{CGI.escape(to)}"\
    "&text=#{text}&dlr-mask=#{config.mask}"\
    "&dlr-url=#{CGI.escape(config.dlr_url)}&id=#{config.sms_message_id}"
  end
end
