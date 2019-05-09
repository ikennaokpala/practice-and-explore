class ApplicationController < ActionController::API
  def index
    render json: { see: 'https://small-project-api.herokuapp.com/api-docs' }
  end
end
