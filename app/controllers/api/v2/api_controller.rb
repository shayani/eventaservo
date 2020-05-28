# frozen_string_literal: true

module Api
  module V2
    class ApiController < ApplicationController
      before_action :authorization

      private

      def authorization
        return true if Rails.env.development? && params[:d].present? # DEBUG ONLY

        jwt_token = request.headers['Authorization'].gsub(/Bearer /,"")
        return false if jwt_token.nil?

        begin
          payload = JWT.decode(jwt_token, Rails.application.secrets.secret_key_base)[0]
          @user ||= User.find(payload['user_id'])
        rescue Exception
          render json: { error: 'Ne valida' }, status: 401
        end
      end
    end
  end
end
