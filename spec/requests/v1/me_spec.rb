require 'rails_helper'

RSpec.describe 'Endpoints for retrieving details about the current user' do
  let(:x_access_token) { 'eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE1NTczNzM2MjQsImlkIjo0MywiZW1haWwiOiJqYWNrQGV4YW1wbGUub3JnIiwibmFtZSI6IkphY2sgTWEiLCJ1aWQiOiI0ODNjZTNlMS00ZDViLTQ3MWEtOGFlMC05OTFkNGY3NmNkMDIiLCJleHAiOjE1NTczNzM2MjR9.ezFsCJ9neTXwsTegDkeXQ1k1cnvdOmzaFojxkqtL0BsLWLzJQy0ifDFX1Iz19f33xn0ooMKHBhVNsRq9eB_LtAXCMufHVsPSDIuHBw4fX9jQ1NrMIwy-3sYPQy7rKxByk29LUOPR8zWkWvmCv_hYKpRWEiI2wdv_Ngv3nDwemWiMmMex0eQIVILRwAiRg-dVIBSaAwb0RSrmArhrodK5QmJ1hSkJF5XaLPEWHgAEku_nAPmEL37Efq7jEPKvfWQNYGMtxgccx3v5DvzoY8BDzVpXPq24Ub-OvyhoZc5er_odL3pqS5NvDOcoiyUx1YUImP78_eMVh8axWAXcT6Ykeg' }
  let(:headers) do
    {
      'X-Access-Token': x_access_token,
      Host: 'example.org',
      Cookie: ''
    }
  end
  let(:params) { {} }
  let(:user_id) { JWT.decode(x_access_token, nil, false).first['id'] }
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET /v1/me' do
    before do
      create(:user, id: user_id)
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
