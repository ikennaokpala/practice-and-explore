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
  let(:parameters) {{ content: 'the-content', impact: 8, ease: 8, confidence: 8 }}
  let(:params) { parameters }
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:idea) { create(:idea) }
  let(:ideas) { create_list(:idea, 3) }
  let(:idea_id) { idea.id }

  describe 'POST /v1/ideas' do
    let(:average_score) { response_body[:average_score] }
    let(:created_at) { response_body[:created_at] }
    let(:latest_idea) { Idea.last }

    subject { post '/v1/ideas',  params: params, headers: headers }

    context 'when Idea attributes are valid' do
      it 'creates an Idea successfully' do
        expect { subject }.to change { Idea.count }.by(1)

        expect(response).to have_http_status(:success)
        expect(average_score).to eq(8)
        expect(created_at).to eq(latest_idea.created_at.to_i)
        expect(response).to match_response_schema('v1/idea')
      end
    end

    context 'when idea attribute(s) are invalid' do
      context 'given content is not as expected' do
        let(:content_errors) { response_body[:content] }

        context 'when content is empty' do
          let(:parameters) {{ content: '', impact: 8, ease: 8, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(content_errors).to match_array(['is required'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when content is more than 255 characters long' do
          let(:parameters) {{ content: SecureRandom.alphanumeric(256), impact: 8, ease: 8, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(content_errors).to match_array(['should not be more than 255 charaters long'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end
      end

      context 'given impact is not as expected' do
        let(:impact_errors) { response_body[:impact] }

        context 'when impact is nil' do
          let(:parameters) {{ content: 'the-content', impact: nil, ease: 8, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(impact_errors).to match_array(['is required', 'should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when impact is below 1' do
          let(:parameters) {{ content: 'the-content', impact: 0, ease: 8, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(impact_errors).to match_array(['should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when impact is above 10' do
          let(:parameters) {{ content: 'the-content', impact: 11, ease: 8, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(impact_errors).to match_array(['should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end
      end

      context 'given ease is not as expected' do
        let(:ease_errors) { response_body[:ease] }

        context 'when ease is nil' do
          let(:parameters) {{ content: 'the-content', impact: 8, ease: nil, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(ease_errors).to match_array(['is required', 'should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when ease is below 1' do
          let(:parameters) {{ content: 'the-content', impact: 8, ease: 0, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(ease_errors).to match_array(['should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when ease is above 10' do
          let(:parameters) {{ content: 'the-content', impact: 8, ease: 11, confidence: 8 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(ease_errors).to match_array(['should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end
      end

      context 'given confidence is not as expected' do
        let(:confidence_errors) { response_body[:confidence] }

        context 'when confidence is nil' do
          let(:parameters) {{ content: 'the-content', impact: 8, ease: 8, confidence: nil }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(confidence_errors).to match_array(['is required', 'should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when confidence is below 1' do
          let(:parameters) {{ content: 'the-content', impact: 8, ease: 8, confidence: 0 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(confidence_errors).to match_array(['should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end

        context 'when confidence is above 10' do
          let(:parameters) {{ content: 'the-content', impact: 8, ease: 8, confidence: 11 }}

          it 'returns an unprocessable Idea' do
            expect { subject }.to change { Idea.count }.by(0)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(confidence_errors).to match_array(['should be between 1 and 10'])
            expect(response).to match_response_schema('v1/idea_error')
          end
        end
      end
    end
  end

  describe 'DELETE /v1/ideas/:id' do
    before { idea }

    subject { delete '/v1/ideas/' + idea_id.to_s, headers: headers }

    context 'given an Idea id is to be removed' do
      context 'when an existing Idea id is supplied' do
        it 'deletes the Idea successfully' do
          expect { subject }.to change { Idea.count }.by(-1)

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when a non-existing Idea id is supplied' do
        let(:idea_id) { 'non-existing-id' }

        it 'does not delete the Idea successfully' do
          expect { subject }.to change { Idea.count }.by(0)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET /v1/ideas' do
    before do
      Kaminari.configure do |config|
        @default_per_page = config.default_per_page
        config.default_per_page = 2
      end
    end

    after do
      Kaminari.configure do |config|
        config.default_per_page = @default_per_page
      end
    end

    context 'given that a GET request for ideas is made' do
      let(:page) { 1 }
      let(:parameters) { { page: page } }
      let(:outcome) { ideas.map {|idea| V1::IdeaSerializer.new(idea).as_json } }

      before do
        ideas

        get '/v1/ideas', params: params, headers: headers
      end

      context 'when ideas exist' do
        context 'when on page is not defined' do
          let(:parameters) { {} }

          it 'returns per page ideas' do  
            expect(response_body).to match_array(outcome.first(2))
            expect(response_body.count).to eq(2)
            expect(response).to match_response_schema('v1/ideas')
          end
        end

        context 'when on page 1' do
          it 'returns per page ideas' do  
            expect(response_body).to match_array(outcome.first(2))
            expect(response_body.count).to eq(2)
            expect(response).to match_response_schema('v1/ideas')
          end
        end

        context 'when on next page' do
          let(:page) { 2 }

          it 'returns per page ideas' do  
            expect(response_body).to match_array(outcome.last(1))
            expect(response_body.count).to eq(1)
            expect(response).to match_response_schema('v1/ideas')
          end
        end
      end

      context 'when ideas do not exist' do
        let(:ideas) { [] }

        it 'returns empty' do  
          expect(response_body).to match_array([])
        end
      end
    end
  end

  describe 'PUT /v1/ideas/:id' do
    let(:parameters) { { content: 'changed-content', impact: 1, ease: 2, confidence: 3 } }
    let(:outcome) { V1::IdeaSerializer.new(idea.reload).as_json }

    before { idea }

    subject { put '/v1/ideas/' + idea_id.to_s, params: params, headers: headers }

    context 'given a PUT request to update ideas is made' do
      before { subject }

      context 'when idea attribute(s) are valid' do
        it 'updates the attribute(s)' do
          expect(response).to have_http_status(:success)
          expect(response_body).to include(outcome)
          expect(response).to match_response_schema('v1/idea')
        end
      end

      context 'when idea attribute(s) are invalid' do
        let(:parameters) { { content: '', impact: 11, ease: 12, confidence: 13 } }

        it 'updates the attribute(s)' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to match_response_schema('v1/idea_error')
        end
      end
    end
  end
end
