# frozen_string_literal: true

module Api
  module V2
    class ApiController < ApplicationController
      before_action :authorization

      private

      def authorization
        jwt_token = request.headers['Authorization']
        if jwt_token.nil?
          render json: { error: 'Mankas kodo' }, status: 401 and return false
        end

        jwt_token = jwt_token.gsub(/Bearer /,"")
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
