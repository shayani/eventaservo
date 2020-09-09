# frozen_string_literal: true

module Api
  module V3
    class ApiController < ApplicationController
      before_action :authorization

      private

      def authorization
        # return true if request.env["REMOTE_ADDR"] == "127.0.0.1"

        jwt_token = request.headers['Authorization']
        if jwt_token.nil?
          render json: { error: 'Mankas kodo' }, status: 401 and return false
        end

        jwt_token = jwt_token.gsub(/Bearer /,"")
        begin
          payload = JWT.decode(jwt_token, Rails.application.credentials.dig(:secret_key_base))[0]
          @user ||= User.find(payload['user_id'])
        rescue Exception
          render json: { error: 'Ne valida' }, status: 401
        end
      end
    end
  end
end
