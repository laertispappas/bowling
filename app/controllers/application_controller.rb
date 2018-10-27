class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def bad_request(ex)
    render json: { message: ex.message }, status: 400
  end

  def not_found(ex)
    render json: { message: ex.message }, status: 404
  end
end
