require 'rails_helper'

RSpec.describe 'Endpoints that are associated with managing Users' do
  let(:headers) do 
    { 
      headers: { 
        'Content-Type': 'application/json',
        'Host': 'example.org',
        'Cookie': ''
      }
    }
  end
  let(:parameters) {{ email: 'jack@example.org', name: 'Jack Ma', password: 'Password1' }}
  let(:params) { parameters }
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  
  describe 'POST /v1/users' do
    subject { post '/v1/users', params: params, headers: headers }

    context 'given a POST request to create a user is made ' do
      context 'when user attribute(s) are valid' do
        it 'creates a new user' do
          expect { subject }.to change { User.count }.by(1)

          expect(response).to have_http_status(:created)
          expect(response).to match_response_schema('v1/user')
        end
      end
    end
  end
end
