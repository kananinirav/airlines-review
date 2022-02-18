# frozen_string_literal: true

# api module
module Api
  module V1
    class AirlinesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        airlines = Airline.all
        render json: AirlineSerializer.new(airlines, options).serialized_json
      end

      def show
        airlines = Airline.find_by(slug: params[:slug])

        render json: AirlineSerializer.new(airlines, options).serialized_json
      end

      def create
        begin
          airlines = Airline.new(airline_params)

          if airlines.save
            render json: AirlineSerializer.new(airlines).serialized_json
          else
            render json: { error: airlines.errors.full_messages }, status: 422
          end
        rescue
          render json: {}, status: 422
        end
      end

      def update
        begin
          airlines = Airline.find_by(slug: params[:slug])

          if airlines.update(airline_params)
            render json: AirlineSerializer.new(airlines, options).serialized_json
          else
            render json: { error: airlines.errors.full_messages }, status: 422
          end
        rescue
          render json: {}, status: 422
        end
      end

      def destroy
        airlines = Airline.find_by(slug: params[:slug])

        if airlines.destroy
          head :no_content
        else
          render json: { error: airlines.error.full_messages }, status: 422
        end
      end

      private

      def airline_params
        params.require(:airline).permit(:name, :image_url)
      end

      def options
        @options ||= { include: %i[reviews]}
      end
    end
  end
end
