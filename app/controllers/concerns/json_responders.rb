# frozen_string_literal: true

module JsonResponders
  def render_success(data, status: :ok)
    render json: data, status: status
  end

  def render_create(data)
    render_success(data, :created)
  end

  def render_error(error, status = :bad_request)
    render json: error, status: status
  end

  def render_unprocessable_entity(error)
    render_error(error, :unprocessable_entity)
  end

  def render_unauthorized(error)
    render_error(error, :unauthorized)
  end

  def render_forbidden(error)
    render_error(error, :forbidden)
  end

  def render_not_found(error)
    render_error(error, :not_found)
  end
end
