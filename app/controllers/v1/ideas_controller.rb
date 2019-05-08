class V1::IdeasController < V1::BaseController
  def create
    @idea = Idea.new(params.permit(:content, :impact, :ease, :confidence))
    if @idea.save
      render json: @idea, serializer: V1::IdeaSerializer
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end
end
