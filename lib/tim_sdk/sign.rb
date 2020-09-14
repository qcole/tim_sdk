require 'tim_sdk/configuration'
require 'base64'
require 'openssl'
require 'json'
require 'zlib'

module TimSdk
  class Sign
    class << self

      def signature(identifier, expire = 24 * 60 * 60)
        do_signature(identifier, expire, nil)
      end

      def signature_with_user_buf(identifier, expire, user_buf)
        do_signature(identifier, expire, user_buf)
      end

      private

      def do_signature(identifier, expire = 180 * 86400, user_buf = nil)
        timestamp       = Time.now.to_i
        raw_data        = {}
        base64_user_buf = nil
        unless user_buf.nil?
          base64_user_buf = Base64.encode64(user_buf)
          raw_data.merge!('TLS.userbuf' => base64_user_buf)
        end
        raw_data.merge!('TLS.sig'        => hmac_sha256(identifier, timestamp, expire, base64_user_buf),
                        'TLS.expire'     => expire.to_i,
                        'TLS.sdkappid'   => TimSdk.configuration.app_id,
                        'TLS.ver'        => '2.0',
                        'TLS.time'       => timestamp,
                        'TLS.identifier' => identifier.to_s)
        raw_sig  = raw_data.to_json.gsub(/,/, ', ').gsub(/:/, ': ')
        sig_zlib = Zlib::Deflate.deflate(raw_sig)
        base64_encode(sig_zlib)
      end

      def hmac_sha256(identifier, curr_time, expire, base64_user_buf = nil)
        data = ["TLS.identifier:#{identifier}", "TLS.sdkappid:#{TimSdk.configuration.app_id}", "TLS.time:#{curr_time}", "TLS.expire:#{expire}"]
        data << "TLS.userbuf:#{base64_user_buf}" if base64_user_buf
        data_string = "#{data.join("\n")}\n"
        Base64.strict_encode64(
            OpenSSL::HMAC.digest('sha256', TimSdk.configuration.app_key, data_string)
        )
      end

      def base64_encode(data)
        Base64.strict_encode64(data).gsub('+', '*').gsub('/', '-').gsub('=', '_')
      end

    end
  end
end