# frozen_string_literal: true

module CustomException
  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthUserNotFound < StandardError; end
end
