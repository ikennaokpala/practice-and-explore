require 'rails_helper'

RSpec.describe 'Endpoints that are associated with user session management' do
  let(:headers) do
    {
      Host: 'example.org',
      Cookie: ''
    }
  end
  let(:parameters) {{ email: 'jack.ma@example.org', password: 'Password1' }}
  let!(:user) { create(:user, email: 'jack.ma@example.org', password: 'Password1') }
  let(:params) { parameters }
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:expected) { user.as_json.slice('id', 'email', 'name') }
  let!(:tokenized_user) { TokenizedUser.call(user) }
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

  describe 'DELETE /v1/access-tokens' do
    let(:x_access_token) { tokenized_user.jwt }
    let(:headers) do
      {
        'X-Access-Token': x_access_token,
        Host: 'example.org',
        Cookie: ''
      }
    end

    before { delete '/v1/access-tokens',  params: params, headers: headers }

    context 'given a login request has been made' do
      context 'when X-Access-Token is supplied' do
        it 'signs user out by flushing via access payload' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when X-Access-Token is not supplied' do
        let(:headers) do
          {
            'X-Access-Token': '',
            Host: 'example.org',
            Cookie: ''
          }
        end

        it 'returns not found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST /v1/access-tokens/refresh' do
    let(:parameters) {{ refresh_token: tokenized_user.refresh_token }}
    let(:headers) do
      {
        Host: 'example.org',
        Cookie: ''
      }
    end

    before { post '/v1/access-tokens/refresh',  params: params, headers: headers }

    context 'given a token refresh request has been made' do
      context 'when refresh_token is supplied' do
        it 'returns refreshes the user access token' do
          expect(response).to have_http_status(:success)
          expect(JWT.decode(response_body[:jwt], nil, false).first.values).not_to be_empty
        end
      end

      context 'when refresh_token is not supplied' do
        let(:parameters) {{ refresh_token: nil }}
        let(:headers) do
          {
            'X-Access-Token': '',
            Host: 'example.org',
            Cookie: ''
          }
        end

        it 'returns not found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
