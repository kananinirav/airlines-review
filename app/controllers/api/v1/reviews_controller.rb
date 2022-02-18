module Api
  module V1
    class ReviewsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        begin
          review = airline.reviews.new(review_params)

          if review.save
            render json: ReviewSerializer.new(review).serialized_json
          else
            render json: { error: review.errors.full_messages }, status: 422
          end
        rescue
          render json: {}, status: 422
        end
      end

      def destroy
        review = Review.find(params[:id])

        if review.destroy
          head :no_content
        else
          render json: { error: review.errors.full_messages }, status: 422
        end
      end

      private

      def airline
        @airline ||= Airline.find(params[:airline_id])
      end

      def review_params
        params.require(:review).permit(:title, :description, :score, :airline_id)
      end
    end
  end
end