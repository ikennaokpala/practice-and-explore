class V1::IdeasController < V1::BaseController
  def create
    @idea = Idea.new(params.permit(:content, :impact, :ease, :confidence))
    @idea.save!
    render json: @idea, serializer: V1::IdeaSerializer
  end
end
