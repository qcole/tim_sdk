require 'faraday'

module TimSdk
  class Api

    def self.connection
      Faraday.new('https://console.tim.qq.com', params: {
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

    # 导入单个帐号
    def self.invoke_account_import(identifier, nick = nil, face_url = nil)
      response = connection.post('/v4/im_open_login_svc/account_import') do |request|
        request_body = { :Identifier => identifier.to_s }
        request_body.merge!(:Nick => nick) if nick
        request_body.merge!(:FaceUrl => face_url) if face_url
        request.body = request_body.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 导入多个账号
    def self.invoke_multi_account_import(accounts)
      response = connection.post('/v4/im_open_login_svc/multiaccount_import') do |request|
        request.body = {
            :Accounts => accounts.map(&:to_s)
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 删除账号
    def self.invoke_account_delete(accounts)
      response = connection.post('/v4/im_open_login_svc/account_delete') do |request|
        request.body = {
            :DeleteItem => accounts.map do |account|
              {
                  :UserID => account.to_s
              }
            end
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 查询账号
    def self.invoke_account_check(accounts)
      response = connection.post('/v4/im_open_login_svc/account_check') do |request|
        request.body = {
            :CheckItem => accounts.map do |account|
              {
                  :UserID => account.to_s
              }
            end
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 失效帐号登录态
    def self.invoke_kick(identifier)
      response = connection.post('/v4/im_open_login_svc/kick') do |request|
        request.body = {
            :Identifier => identifier.to_s
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 查询帐号在线状态
    def self.invoke_query_state(accounts, is_need_detail = 0)
      response = connection.post('/v4/openim/querystate') do |request|
        request.body = {
            :To_Account   => accounts.map(&:to_s),
            :IsNeedDetail => is_need_detail
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 导入单聊消息
    def self.invoke_import_msg(from_account, to_account, msg_random, msg_timestamp, sync_from_old_system, msg_body)
      response = connection.post('/v4/openim/importmsg') do |request|
        request.body = {
            :SyncFromOldSystem => sync_from_old_system,
            :From_Account      => from_account.to_s,
            :To_Account        => to_account.to_s,
            :MsgRandom         => msg_random.to_i,
            :MsgTimeStamp      => msg_timestamp.to_i,
            :MsgBody           => msg_body
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 撤回单聊消息
    def self.invoke_admin_msg_withdraw(from_account, to_account, msg_key)
      response = connection.post('/v4/openim/admin_msgwithdraw') do |request|
        request.body = {
            :From_Account => from_account.to_s,
            :To_Account   => to_account.to_s,
            :MsgKey       => msg_key.to_s,
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 设置资料
    def self.invoke_portrait_set(account, items)
      response = connection.post('/v4/profile/portrait_set') do |request|
        request.body = {
            :From_Account => account.to_s,
            :ProfileItem  => items.map do |item|
              {
                  :Tag   => item[:tag],
                  :Value => item[:value],
              }
            end
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 拉取资料
    def self.invoke_portrait_get(accounts, tags)
      response = connection.post('/v4/profile/portrait_get') do |request|
        request.body = {
            :To_Account => accounts.map(&:to_s),
            :TagList    => tags.map(&:to_s),
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 拉取运营数据
    def self.invoke_fetch_app_info(fields = [])
      response = connection.post('/v4/openconfigsvr/getappinfo') do |request|
        request.body = {
            :RequestField => fields
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 下载消息记录
    def self.invoke_fetch_history(chat_type, msg_time)
      response = connection.post('/v4/open_msg_svc/get_history') do |request|
        request.body = {
            :ChatType => chat_type,
            :MsgTime  => msg_time,
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 获取服务器 IP 地址
    def self.invoke_fetch_ip_list
      response = connection.post('/v4/ConfigSvc/GetIPList') do |request|
        request.body = {}.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 创建群组
    def self.create_group(owner_account, name, type, member_list)
      response = connection.post('/v4/group_open_http_svc/create_group') do |request|
        request.body = {
          "Owner_Account": owner_account,
          "Type": type, 
          "Name": name, 
          "MemberList": member_list
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 获取群详细资料
    def self.invoke_get_group_info(group_ids)
      response = connection.post('/v4/group_open_http_svc/get_group_info') do |request|
        request.body = {
          "GroupIdList": group_ids,
          "ResponseFilter": {
            "GroupBaseInfoFilter": [ 
              "Type",
              "Name",
              "Introduction",
              "Notification"
            ],
            "MemberInfoFilter": [ 
                "Account", 
                "Role"
            ]
          }
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 导入群组资料
    def self.invoke_import_group(owner_account, type='Private', items)
      response = connection.post('/v4/group_open_http_svc/import_group') do |request|
        request.body = {
          "Owner_Account": owner_account,
          "Type": type, 
          "GroupId": items[:group_id], 
          "Name": items[:name], 
          "company_id": items[:company_id],
          "FaceUrl": items[:face_url]
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 导入群文本消息
    def self.invoke_import_group_msg(group_id, from_account, content)
      response = connection.post('/v4/group_open_http_svc/import_group_msg') do |request|
        request.body = {
          "GroupId": group_id,
          "MsgList": [{
            "From_Account": from_account, 
            "SendTime": Time.now.to_i,
            "MsgBody": [{
              "MsgType": "TIMTextElem",
              "MsgContent": {
                "Text": content
              }
            }]
          }]
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 导入群成员
    def self.invoke_import_group_member(group_id, member_list)
      response = connection.post('/v4/group_open_http_svc/import_group_member') do |request|
        request.body = {
          "GroupId": group_id,
          "MemberList": member_list
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 修改群基础资料
    def self.modify_group_base_info(group_id, items)
      response = connection.post('/v4/group_open_http_svc/modify_group_base_info') do |request|
        items["GroupId"] = group_id
        request.body = items.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 添加群成员
    def self.add_group_member(group_id, member_list, silence = 0)
      response = connection.post('/v4/group_open_http_svc/add_group_member') do |request|
        request.body = {
          "GroupId": group_id,
          "MemberList": member_list,
          "Silennce": silence
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 删除群成员
    def self.delete_group_member(group_id, member_to_del_account, silence = 0)
      response = connection.post('/v4/group_open_http_svc/delete_group_member') do |request|
        request.body = {
          "GroupId": group_id,
          "MemberToDel_Account": member_to_del_account,
          "Silennce": silence
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 解散群组
    def self.destroy_group(group_id)
      response = connection.post('/v4/group_open_http_svc/destroy_group') do |request|
        request.body = {
          "GroupId": group_id
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 发送单聊消息
    def self.sendmsg(to_account, message)
      response = connection.post('/v4/openim/sendmsg') do |request|
        request.body = { 
          "SyncOtherMachine": 2, # 消息不同步至发送方
          "To_Account": to_account,
          "MsgLifeTime": 604800,     # 消息保存7天
          "MsgRandom": rand(4294967295),
          "MsgBody": [
            {
              "MsgType": "TIMTextElem",
              "MsgContent": {
                "Text": message
              }
            }
          ],
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end 

    # 发送群聊消息
    def self.send_group_msg(group_id, from_account, message)
      response = connection.post('/v4/group_open_http_svc/send_group_msg') do |request|
        request.body = { 
          :GroupId => group_id,
          :From_Account => from_account,
          :Content => message,
          :MsgBody => [
            {
              "MsgType": "TIMTextElem", 
              "MsgContent": {
                  "Text": message
              }
          },
          ]
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    # 发送群聊系统消息
    def self.send_group_system_notification(group_id, message)
      response = connection.post('/v4/group_open_http_svc/send_group_system_notification') do |request|
        request.body = { 
          :GroupId => group_id,
          :Content => message
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end
    
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

    # 更新好友
    def self.invoke_friend_update(from_account, update_items)
      response = connection.post('/v4/sns/friend_update') do |request|
        request.body = { 
          :From_Account => from_account,
          :UpdateItem => update_items
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

    # 删除好友
    def self.invoke_friend_delete(from_account, to_accounts, delete_type = "Delete_Type_Single")
      response = connection.post('/v4/sns/friend_delete') do |request|
        request.body = { 
          :From_Account => from_account,
          :To_Account => to_accounts,
          :DeleteType => delete_type
        }.to_json
      end
    end

    # 删除全部好友
    def self.invoke_friend_delete_all(from_account, delete_type = 'Delete_Type_Both')
      response = connection.post('/v4/sns/friend_delete_all') do |request|
        request.body = { 
          :From_Account => from_account,
          :DeleteType => delete_type
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    ## 全员推送
    def self.all_member_push(text = "")
      response = connection.post('/v4/all_member_push/im_push') do |request|
        request.body = { 
          "From_Account": "admin",
          "MsgRandom": msg_random,
          "MsgLifeTime": 120,
          "MsgBody": [
              {
                  "MsgType": "TIMTextElem",
                  "MsgContent": {
                      "Text": text
                  }
              }
          ]
        }.to_json
      end
      raise TimServerError, "Response Status: #{response.status}" unless response.success?
      JSON.parse(response.body, symbolize_names: true) if response.success?
    end

    
  end
end