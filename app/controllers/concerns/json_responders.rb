# frozen_string_literal: true

module JsonResponders
  def render_success(data, status = :ok)
    render json: data, status: status
  end

  def render_created(data)
    render_success(data, :created)
  end

  def render_error(error, status = :bad_request)
    render json: error, status: status
  end

  def render_unprocessable_entity(error)
    render_error(error, :unprocessable_entity)
  end

  def render_unauthorized(error = { error: 'You are unauthorized for this request' })
    render_error(error, :unauthorized)
  end

  def render_forbidden(error = { error: 'You are forbidden for this request' })
    render_error(error, :forbidden)
  end

  def render_not_found(error = { error: 'Record not found' })
    render_error(error, :not_found)
  end
end
