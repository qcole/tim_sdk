module TimSdk
  module Api
    module Friendship

      # 添加好友
      def self.invoke_friend_add(from_account, friend_list)
        response = connection.post('/v4/sns/friend_add') do |request|
          request.body = { 
            :From_Account => from_account,
            :AddFriendItem => friend_list.map { |friend| { "To_Account": friend, "AddSource": "AddSource_Type_Server" }}
          }.to_json
        end
        raise TimServerError, "Response Status: #{response.status}" unless response.success?
        JSON.parse(response.body, symbolize_names: true) if response.success?
      end

      # 导入好友
      def self.invoke_friend_import(from_account, friend_list)
        response = connection.post('/v4/sns/friend_import') do |request|
          request.body = { 
            :From_Account => from_account,
            :AddFriendItem => friend_list.map { |friend| { "To_Account": friend, "AddSource": "AddSource_Type_Server" }}
          }.to_json
        end
        raise TimServerError, "Response Status: #{response.status}" unless response.success?
        JSON.parse(response.body, symbolize_names: true) if response.success?
      end

      # 拉取好友
      def self.invoke_friend_get(from_account, start_index = 0, standard_sequence = 0, custom_sequence = 0)
        response = connection.post('/v4/sns/friend_get') do |request|
          request.body = { 
            :From_Account => from_account,
            "StartIndex": start_index,
            "StandardSequence": standard_sequence,
            "CustomSequence": custom_sequence
          }.to_json
        end
        raise TimServerError, "Response Status: #{response.status}" unless response.success?
        JSON.parse(response.body, symbolize_names: true) if response.success?
      end

    end
  end
end