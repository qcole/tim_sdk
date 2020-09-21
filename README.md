# TimSdk

[腾讯云即时通信IM](https://cloud.tencent.com/product/im) Ruby SDK。提供登录签名和部分常用的 API 接口。已经完成的功能：

- [x] 用户登录即时通信签名
    - [x] 服务端计算 UserSig

- [x] 账号管理
    - [x] 导入单个账号
    - [x] 导入多个帐号
    - [x] 删除帐号
    - [x] 查询帐号
    - [x] 失效帐号登录态
    - [x] 查询帐号在线状态

- [x] 单聊消息
    - [x] 导入单聊消息

- [x] 资料管理
    - [x] 设置资料
    - [x] 拉取资料

- [x] 运营管理
    - [x] 拉取运营数据
    - [x] 下载消息记录
    - [x] 获取服务器 IP 地址

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tim_sdk'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tim_sdk

## Usage

配置参数
```ruby
TimSdk.configure do |config|
  config.app_id        = 'you app id'
  config.admin_account = 'you admin account'
  config.app_key       = 'you app key'
end
```

生成UserSig
```ruby
TimSdk::Sign.signature('10001')
#=> eJyrVgrxCdYrzkxXslJQ8jA0dkoN99LOTXNONrHwca0K8Qmv0NY3zqxICfU3zAqscvMqLcxPNHYyLrdV0lEAa02tKMgsSgXqtjAzMTCAChanZCcWFGSmgAytzC9VAHIUgDyobFlqEUjCSM8AJlKSmQsywtDMwMDQ1MTcwgQqnpmSmleSmZYJ0WBoAJRWqgUASukybQ__
TimSdk::Sign.signature('10001', 7 * 24 * 60 * 60)
#=> eJyrVgrxCdYrzkxXslJQ8jA0dkoN99LOTXNONrHwca0K8Qmv0NY3zqxICfU3zAqscvMqLcxPNHYyLrdV0lEAa02tKMgsSgXqtjAzMTCAChanZCcWFGSmgAytzC9VAHIUgDyobFlqEUjCSM8AJlKSmQsywtDMwMDQ1MTcwgQqnpmSmleSmZYJ0WBoAJRWqgUASukybQ__
```

导入单个账号
```ruby
TimSdk::Api.invoke_account_import('foo')
#=> {:ActionStatus=>"OK", :ErrorCode=>0, :ErrorInfo=>""}
```

导入多个帐号
```ruby
TimSdk::Api.invoke_multi_account_import(%w[foo bar])
#=> {:ActionStatus=>"OK", :ErrorCode=>0, :ErrorInfo=>"", :FailAccounts=>[]}
```

删除帐号
```ruby
TimSdk::Api.invoke_account_delete(%w[foo bar])
#=> {:ActionStatus=>"OK", :ErrorCode=>0, :ErrorInfo=>"", :ResultItem=>[{:ResultCode=>0, :ResultInfo=>"", :UserID=>"bar"}, {:ResultCode=>0, :ResultInfo=>"", :UserID=>"foo"}]}
```

查询帐号
```ruby
TimSdk::Api.invoke_account_check(%w[foo bar])
#=> {:ActionStatus=>"OK", :ErrorCode=>0, :ErrorInfo=>"", :ResultItem=>[{:AccountStatus=>"Imported", :ResultCode=>0, :ResultInfo=>"", :UserID=>"bar"}, {:AccountStatus=>"Imported", :ResultCode=>0, :ResultInfo=>"", :UserID=>"foo"}]}
```

失效帐号登录态
```ruby
TimSdk::Api.invoke_kick('foo')
#=> {:ActionStatus=>"OK", :ErrorInfo=>"", :ErrorCode=>0}
```

查询帐号在线状态
```ruby
TimSdk::Api.invoke_query_state(%w[foo bar])
#=> {:ActionStatus=>"OK", :ErrorInfo=>"", :ErrorCode=>0, :QueryResult=>[{:To_Account=>"bar", :State=>"Offline", :Status=>"Offline"}, {:To_Account=>"foo", :State=>"Offline", :Status=>"Offline"}]}
```

导入聊天消息
```ruby
TimSdk::Api.invoke_import_msg(
    'foo',
    'bar',
    4122534,
    1556178721,
    2,
    [
        {
            "msg_type":    "TIMTextElem",
            "msg_content": {
                "text": "Hello World"
            }
        }
    ]
)
#=> {:ActionStatus=>"OK", :ErrorInfo=>"", :ErrorCode=>0}
```

设置资料
```ruby
TimSdk::Api.invoke_portrait_set('foo', [
    { tag: 'Tag_Profile_IM_Nick', value: 'vincent', },
    { tag: 'Tag_Profile_IM_Image', value: 'https://example.com/avatar.png' },
])
#=> {:ActionStatus=>"OK", :ErrorCode=>0, :ErrorInfo=>"", :ErrorDisplay=>""}
```

拉取资料
```ruby
TimSdk::Api.invoke_portrait_get(%w[foo bar], %w[Tag_Profile_IM_Nick Tag_Profile_IM_Image])
#=> {:UserProfileItem=>[{:To_Account=>"bar", :ResultCode=>0, :ResultInfo=>""}, {:To_Account=>"foo", :ProfileItem=>[{:Tag=>"Tag_Profile_IM_Nick", :Value=>"vincent"}, {:Tag=>"Tag_Profile_IM_Image", :Value=>"https://example.com/avatar.png"}], :ResultCode=>0, :ResultInfo=>""}], :CurrentStandardSequence=>0, :ActionStatus=>"OK", :ErrorCode=>0, :ErrorInfo=>"", :ErrorDisplay=>""}
```

拉取运营数据
```ruby
TimSdk::Api.invoke_fetch_app_info
#=> {:ErrorCode=>0, :ErrorInfo=>"OK", :Result=>[{:Date=>"20200914"}, {:Date=>"20200913"}, {:Date=>"20200912"}, {:Date=>"20200911"}, {:Date=>"20200910"}, {:Date=>"20200909"}, {:Date=>"20200908"}, {:Date=>"20200907"}, {:Date=>"20200906"}, {:Date=>"20200905"}, {:Date=>"20200904"}, {:Date=>"20200903"}, {:Date=>"20200902"}, {:Date=>"20200901"}, {:Date=>"20200831"}, {:Date=>"20200830"}, {:Date=>"20200829"}, {:Date=>"20200828"}, {:Date=>"20200827"}, {:Date=>"20200826"}, {:Date=>"20200825"}, {:Date=>"20200824"}, {:Date=>"20200823"}, {:Date=>"20200822"}, {:Date=>"20200821"}, {:Date=>"20200820"}, {:Date=>"20200819"}, {:Date=>"20200818"}, {:Date=>"20200817"}, {:Date=>"20200816"}]}
```

下载消息记录
```ruby
TimSdk::Api.invoke_fetch_history('C2C', '2020091116')
#=> {:ChatType=>"C2C", :MsgTime=>"2020091116", :File=>[{:URL=>"https://download.tim.qq.com/msg_history/4/f5da9cce4789eda2f72511ea89280c42a1292b80.gz", :ExpireTime=>"2020-09-15 15:50:07", :FileSize=>7273, :FileMD5=>"6fde5543bbc4a5aea5e35a64edf0553e", :GzipSize=>1535, :GzipMD5=>"92a00693794328453010e083e8193eed"}], :ActionStatus=>"OK", :ErrorInfo=>"", :ErrorCode=>0}
```

获取服务器 IP 地址
```ruby
TimSdk::Api.invoke_fetch_ip_list
#=> {:ActionStatus=>"OK", :ErrorCode=>0, :IPList=>["101.226.212.0/25", "101.226.233.0/25", "101.89.18.0/25", "101.91.60.0/25", "101.91.69.0/25", "101.91.96.0/25", "106.52.138.0/25", "106.52.142.0/25", "106.52.145.0/25", "106.52.14.0/25", "106.52.148.0/25", "106.52.159.0/25", "106.52.164.0/25", "106.52.165.0/25", "106.52.172.0/25", "106.52.178.0/25", "106.52.180.0/25", "106.52.183.0/25", "106.52.187.0/25", "106.52.190.0/25", "106.52.201.0/25", "106.52.29.0/25", "106.52.32.0/25", "106.53.102.0/25", "106.53.125.0/25", "106.53.203.0/25", "106.53.76.0/25", "106.55.14.0/25", "106.55.15.0/25", "106.55.17.0/25", "106.55.173.0/25", "106.55.18.0/25", "106.55.249.0/25", "106.55.253.0/25", "111.13.35.0/25", "111.161.111.0/25", "111.161.64.0/25", "111.30.138.0/25", "111.30.144.0/25", "111.30.155.0/25", "113.96.237.0/25", "116.128.138.0/25", "116.128.146.0/25", "116.128.160.0/25", "116.128.163.0/25", "117.135.172.0/25", "117.144.244.0/25", "117.184.248.0/25", "118.126.91.0/25", "118.89.30.0/25", "118.89.64.0/25", "119.29.105.0/25", "119.29.130.0/25", "119.29.147.0/25", "119.29.191.0/25", "119.29.72.0/25", "119.29.73.0/25", "119.29.74.0/25", "119.29.77.0/25", "119.45.147.0/25", "119.45.33.0/25", "119.45.41.0/25", "119.45.43.0/25", "119.45.44.0/25", "119.45.46.0/25", "119.45.47.0/25", "120.204.11.0/25", "120.232.21.0/25", "121.51.131.0/25", "121.51.132.0/25", "121.51.141.0/25", "121.51.158.0/25", "121.51.176.0/25", "121.51.74.0/25", "121.51.90.0/25", "123.126.122.0/25", "123.150.174.0/25", "123.151.137.0/25", "123.151.179.0/25", "123.151.190.0/25", "123.151.72.0/25", "123.151.79.0/25", "123.207.31.0/25", "125.39.133.0/25", "129.204.177.0/25", "129.204.186.0/25", "129.204.73.0/25", "129.211.162.0/25", "129.211.163.0/25", "129.211.181.0/25", "129.211.182.0/25", "134.175.142.0/25", "134.175.161.0/25", "134.175.205.0/25", "134.175.227.0/25", "14.18.180.0/25", "157.255.196.0/25", "157.255.243.0/25", "163.177.56.0/25", "180.163.32.0/25", "182.254.21.0/25", "182.254.34.0/25", "182.254.50.0/25", "182.254.51.0/25", "182.254.56.0/25", "182.254.57.0/25", "182.254.78.0/25", "182.254.86.0/25", "183.192.172.0/25", "183.192.173.0/25", "183.192.202.0/25", "183.194.184.0/25", "183.232.125.0/25", "183.232.95.0/25", "183.232.96.0/25", "183.3.225.0/25", "193.112.125.0/25", "193.112.151.0/25", "193.112.153.0/25", "193.112.169.0/25", "203.205.232.0/25", "203.205.254.0/25", "220.249.243.0/25", "223.167.154.0/25", "36.155.230.0/25", "42.194.134.0/25", "42.194.145.0/25", "42.194.168.0/25", "42.194.192.0/25", "42.194.224.0/25", "42.194.225.0/25", "58.247.206.0/25", "58.250.136.0/25", "58.60.9.0/25", "59.36.121.0/25", "59.37.116.0/25", "59.37.97.0/25", "61.151.206.0/25", "81.71.1.0/25", "81.71.3.0/25", "81.71.6.0/25", "182.254.116.116", "162.14.6.247"]}
```


## Development

运行 `rspec` 前请先配置正确的参数 
```ruby
# ./spec/tim_sdk_spec.rb
before(:all) do
  TimSdk.configure do |config|
    config.app_id        = 'you app id'
    config.admin_account = 'you admin account'
    config.app_key       = 'you app key'
  end
end
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JiangYongKang/tim_sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/JiangYongKang/tim_sdk/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Test project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/JiangYongKang/tim_sdk/blob/master/CODE_OF_CONDUCT.md).
