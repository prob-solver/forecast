module Api
  module V1
    class BaseController < ApplicationController
      skip_forgery_protection
      layout false
      rescue_from LocationService::LocationNotFound,
                  with: :record_not_found
      rescue_from ForecastService::ForestBadRequest,
                  LocationService::InvalidQueryString,
                  ActionController::ParameterMissing,
                  with: :bad_request

      private

      def record_not_found(_exception)
        render json: {
          error: "record_not_found",
          message: "Record not found"
        }, status: 404
      end

      def bad_request(exception)
        render json: {
          error: "bad_request",
          message: "Bad request"
        }, status: 400
      end
    end
  end
end