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
    let(:expected) { User.last.as_json.slice('id', 'email', 'name') }
    let(:token_outcome) { JWT.decode(response_body[:jwt], nil, false).first.slice('id', 'email', 'name') }
    let(:refresh_outcome) { JWT.decode(response_body[:refresh_token], nil, false).first.slice('id', 'email', 'name') }

    subject { post '/v1/users', params: params, headers: headers }

    context 'given a POST request to create a user is made' do
      context 'when user attribute(s) are valid' do
        it 'creates a new user' do
          expect { subject }.to change { User.count }.by(1)

          expect(response).to have_http_status(:created)
          expect(response).to match_response_schema('v1/user')
          expect(expected).to include(token_outcome)
          expect(expected).to include(refresh_outcome)
        end
      end

      context 'when user attribute(s) are invalid' do
        let(:parameters) {{ email: 'example.org', name: '', password: 'pass' }}
        let(:outcome) {{ name: ['is required'], password: ['is too short (minimum is 8 characters)', 'Passoword is invalid. You need to provide at least 8 characters, including 1 uppercase letter, 1 lowercase letter, and 1 number)'], :email=>['Email is invalid.'] }}

        it 'returns requestas as unprocessable' do
          expect { subject }.to change { User.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to match_response_schema('v1/user_error')
          expect(response_body).to include(outcome)
        end
      end
    end
  end
end
