class V1::MesController < V1::BaseController
  def show
    @user = x_access_token.blank? ? User.new : User.find_by(id: payload['id'])
    if @user.persisted?
      render json: @user, serializer: V1::MeSerializer
    else
      render json: @user, status: :not_found
    end
  end  
end
