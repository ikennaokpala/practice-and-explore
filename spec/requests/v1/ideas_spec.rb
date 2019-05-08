require 'rails_helper'

RSpec.describe 'Endpoints that are associated with managing Ideas' do
  describe 'POST /v1/ideas' do
    let(:headers) do 
      { 
        headers: { 
          'Content-Type': 'application/json',
          'Host': 'example.org',
          'Cookie': ''
        }
      }
    end
    let(:params) {{ content: 'the-content', impact: 8, ease: 8, confidence: 8 }}
    let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
    let(:average_score) { response_body[:average_score] }
    let(:created_at) { response_body[:created_at] }
    let(:latest_idea) { Idea.last }

    subject { post '/v1/ideas',  params: params, headers: headers }
    
    it 'creates an Idea successfully' do
      expect { subject }.to change { Idea.count }.by(1)

      expect(response).to have_http_status(:success)
      expect(average_score).to eq(8)
      expect(created_at).to eq(latest_idea.created_at.to_i)
      expect(response).to match_response_schema('v1/idea')
    end
  end
end
