class V1::MesController < V1::BaseController
  def show
    token = request.headers["HTTP_HEADERS"][:'X-Access-Token']
    @user = token.blank? ? User.new : User.find_by(id: JWT.decode(token, nil, false).first['id'])
    if @user.persisted?
      render json: @user, serializer: V1::MeSerializer
    else
      render json: @user, status: :not_found
    end
  end  
end
