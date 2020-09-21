RSpec.describe TimSdk do

  let(:version) { TimSdk::VERSION }
  before(:all) do
    TimSdk.configure do |config|
      config.app_id        = 'you app id'
      config.admin_account = 'you admin account'
      config.app_key       = 'you app key'
    end
  end

  it 'has a version number' do
    expect(TimSdk::VERSION).eql? version
  end

  it 'should be signed successfully' do
    signature = TimSdk::Sign.signature('10001')
    expect(signature).not_to be_nil
    expect(signature.size).to be > 0
    signature = TimSdk::Sign.signature('10001', 7 * 24 * 60 * 60)
    expect(signature).not_to be_nil
    expect(signature.size).to be > 0
    signature = TimSdk::Sign.signature_with_user_buf('10001', 7 * 24 * 60 * 60, 'foo')
    expect(signature).not_to be_nil
    expect(signature.size).to be > 0
  end

  it 'should be imported successfully' do
    response = TimSdk::Api.invoke_account_import('foo')
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be imported multi account successfully' do
    response = TimSdk::Api.invoke_multi_account_import(%w[foo bar])
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be kick account successfully' do
    response = TimSdk::Api.invoke_kick('foo')
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be check account successfully' do
    response = TimSdk::Api.invoke_account_check(%w[foo bar])
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be query account state successfully' do
    response = TimSdk::Api.invoke_query_state(%w[foo bar])
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
    response = TimSdk::Api.invoke_query_state(%w[foo bar], 1)
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be import message successfully' do
    response = TimSdk::Api.invoke_import_msg(
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
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be withdraw message successfully' do
    response = TimSdk::Api.invoke_admin_msg_withdraw('foo', 'bar', '1927400049_48863998_1599827627')
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be set account portrait successfully' do
    response = TimSdk::Api.invoke_portrait_set('foo', [
        { tag: 'Tag_Profile_IM_Nick', value: 'vincent', },
        { tag: 'Tag_Profile_IM_Image', value: 'https://example.com/avatar.png' },
    ])
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be get account portrait successfully' do
    response = TimSdk::Api.invoke_portrait_get(%w[foo bar], %w[Tag_Profile_IM_Nick Tag_Profile_IM_Image])
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should be delete account successfully' do
    response = TimSdk::Api.invoke_account_delete(%w[foo bar])
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
  end

  it 'should return app info' do
    response = TimSdk::Api.invoke_fetch_app_info
    expect(response[:ErrorInfo]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
    expect(response).to have_key(:Result)
  end

  it 'should return message histories' do
    response = TimSdk::Api.invoke_fetch_history('C2C', '2020091116')
    expect(response).to have_key(:ActionStatus)
    expect(response).to have_key(:ErrorInfo)
    expect(response).to have_key(:ErrorCode)
  end

  it 'should return a list of IP addresses' do
    response = TimSdk::Api.invoke_fetch_ip_list
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
    expect(response).to have_key(:IPList)
  end

end
