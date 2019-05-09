require 'rails_helper'

RSpec.describe 'Endpoints that are associated with managing Ideas' do
  let(:headers) do 
    { 
      headers: { 
        'Content-Type': 'application/json',
        'Host': 'example.org',
        'Cookie': ''
      }
    }
  end
  let(:parameters) {{ email: 'jack.ma@example.org', password: 'Password1' }}
  let!(:user) { create(:user, email: 'jack.ma@example.org', password: 'Password1') }
  let(:params) { parameters }
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:expected) { user.as_json.slice('id', 'email', 'name') }
  let(:token_outcome) { JWT.decode(response_body[:jwt], nil, false).first.slice('id', 'email', 'name') }
  let(:refresh_outcome) { JWT.decode(response_body[:refresh_token], nil, false).first.slice('id', 'email', 'name') }

  describe 'POST /v1/access-tokens' do
    before { post '/v1/access-tokens',  params: params, headers: headers }

    context 'given a login request has been made' do
      context 'when login credentials are valid' do
        it 'authenticates user successfully' do
          expect(response).to have_http_status(:created)
          expect(expected).to include(token_outcome)
          expect(expected).to include(refresh_outcome)
          expect(response).to match_response_schema('v1/user')
        end
      end

      context 'when login credentials are invalid' do
        let(:parameters) {{ email: 'wrong.email@example.org', password: 'WrongPass1' }}

        it 'rejects authentication attempt' do
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
