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

  it 'should return a list of IP addresses' do
    response = TimSdk::Api.invoke_fetch_ip_list
    expect(response[:ActionStatus]).to eq('OK')
    expect(response[:ErrorCode]).to eq(0)
    expect(response).to have_key(:IPList)
  end

end
