require 'faraday'

module TimSdk
  class Api

    def self.connection
      @connection ||= Faraday.new('https://console.tim.qq.com', params: {
          sdkappid:    TimSdk.configuration.app_id,
          identifier:  TimSdk.configuration.admin_account,
          usersig:     TimSdk::Sign.signature(TimSdk.configuration.admin_account),
          random:      rand(0..4294967295),
          contenttype: :json
      }) do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    # 获取服务器 IP 地址
    # 基于安全等考虑，您可能需要获知服务器的 IP 地址列表，以便进行相关限制。App 管理员可以通过该接口获得 SDK、第三方回调所使用到的服务器 IP 地址列表或 IP 网段信息。
    def self.invoke_fetch_ip_list
      response = connection.post('/v4/ConfigSvc/GetIPList') do |request|
        request.body = {}.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

  end
end