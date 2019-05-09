require 'rails_helper'

RSpec.describe 'Endpoints for retrieving details about the current user' do
  let!(:tokenized_user) { TokenizedUser.call(create(:user)) }
  let(:headers) do
    {
      'X-Access-Token': tokenized_user.jwt,
      Host: 'example.org',
      Cookie: ''
    }
  end
  let(:params) { {} }
  let(:user_id) { JWT.decode(tokenized_user.jwt, nil, false).first['id'] }
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET /v1/me' do
    before do
      get '/v1/me', params: params, headers: headers
    end

    context 'given a GET request to retrieve current user details' do
      context 'when X-Access-Token is supplied' do
        it 'returns user details' do
          expect(response).to have_http_status(:success)
          expect(response).to match_response_schema('v1/me')
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
end
