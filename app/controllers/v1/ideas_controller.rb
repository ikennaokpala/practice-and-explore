class V1::IdeasController < V1::BaseController
  before_action :authorize_access_request!

  def create
    @idea = Idea.new(permitted_params)
    if @idea.save
      render json: @idea, serializer: V1::IdeaSerializer
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @idea = Idea.find_by(id: params[:id])
    if @idea.nil?
      render json: nil, status: :unprocessable_entity
    else
      @idea.destroy
    end
  end

  def index
    render json: Idea.by_average_score(params[:page] || 1), each_serializer: V1::IdeaSerializer
  end

  def update
    @idea = Idea.find_by(id: params[:id])
    if @idea.update_attributes(permitted_params)
      render json: @idea, serializer: V1::IdeaSerializer
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:content, :impact, :ease, :confidence)
  end
end
