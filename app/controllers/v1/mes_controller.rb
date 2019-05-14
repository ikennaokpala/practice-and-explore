class V1::MesController < V1::BaseController
  def show
    @user = x_access_token.blank? ? User.new : User.find_by(id: payload['id'])
    return head :not_found unless @user.persisted?
    render json: @user, serializer: V1::MeSerializer
  end  
end
