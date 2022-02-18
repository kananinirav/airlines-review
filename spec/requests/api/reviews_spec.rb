require 'swagger_helper'

RSpec.describe 'api/reviews', type: :request do
  path '/api/v1/reviews' do
    post 'Creates a Reviews' do
      tags 'Reviews'
      consumes 'application/json'
      parameter name: :review, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          score: { type: :integer },
          airline_id: { type: :integer }
        },
        required: %w[title description airline_id]
      }

      response '200', 'Reviews created' do
        schema type: :object,
               properties: {
                 data: { type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :string },
                             type: { type: :string },
                             attributes: { type: :object,
                                           properties: {
                                             title: { type: :string },
                                             description: { type: :string },
                                             score: { type: :string },
                                             airline_id: { type: :integer }
                                           } }
                           }
                         } }
               }
        let(:review) do
          { title: 'Reviews Test', description: '', score: 3, airline_id: 1 }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:review) { { airline_id: 'Reviews Test' } }
        run_test!
      end
    end
  end

  path '/api/v1/reviews/{id}' do
    delete 'Delete Reviews using id' do
      tags 'Reviews'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :integer, example: 1
      response '204', 'Reviews Deleted' do
        run_test!
      end
    end
  end
end
