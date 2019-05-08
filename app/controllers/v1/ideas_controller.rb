class V1::IdeasController < V1::BaseController
  def create
    @idea = Idea.new(params.permit(:content, :impact, :ease, :confidence))
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
    render json: Idea.page(params[:page] || 1), each_serializer: V1::IdeaSerializer
  end
end
