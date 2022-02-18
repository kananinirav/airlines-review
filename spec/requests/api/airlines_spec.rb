require 'swagger_helper'

RSpec.describe 'api/airlines', type: :request do
  path '/api/v1/airlines' do
    post 'Creates a Airlines' do
      tags 'Airlines'
      consumes 'application/json', 'application/xml'
      parameter name: :airline, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          image_url: { type: :string }
        },
        required: %w[name]
      }

      response '200', 'Airlines created' do
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
                                             name: { type: :string },
                                             image_url: { type: :string },
                                             slug: { type: :string },
                                             avg_score: { type: :integer }
                                           } },
                             relationships: { type: :object,
                                              properties: {
                                                reviews: { type: :object,
                                                           properties: {
                                                             data: { type: :array,
                                                                     items: {
                                                                       type: :object,
                                                                       properties: {
                                                                         title: { type: :string },
                                                                         description: { type: :string },
                                                                         score: { type: :integer },
                                                                         airline_id: { type: :integer }
                                                                       }
                                                                     } }
                                                           } }
                                              } }
                           }
                         } }
               }
        let(:airline) do
          { name: 'Airline Test', image_url: 'https://open-flights.s3.amazonaws.com/Southwest-Airlines.png' }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:airline) { { name1: 'Airline Test' } }
        run_test!
      end
    end
  end

  path '/api/v1/airlines' do
    get 'Get all airlines' do
      tags 'Airlines'
      produces 'application/json', 'application/xml'
      response '200', 'Airlines found' do
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
                                             name: { type: :string },
                                             image_url: { type: :string },
                                             slug: { type: :string },
                                             avg_score: { type: :integer }
                                           } },
                             relationships: { type: :object,
                                              properties: {
                                                reviews: { type: :object,
                                                           properties: {
                                                             data: { type: :array,
                                                                     items: {
                                                                       type: :object,
                                                                       properties: {
                                                                         title: { type: :string },
                                                                         description: { type: :string },
                                                                         score: { type: :integer },
                                                                         airline_id: { type: :integer }
                                                                       }
                                                                     } }
                                                           } }
                                              } }
                           }
                         } },
                 included: { type: :array,
                             items: {
                               type: :object,
                               properties: {
                                 id: { type: :string },
                                 type: { type: :string },
                                 attributes: { type: :object,
                                               properties: {
                                                 title: { type: :string },
                                                 description: { type: :string },
                                                 score: { type: :integer },
                                                 airline_id: { type: :integer }
                                               } }
                               }
                             } }
               },
               required: %w[name image_url slug avg_score]

        let(:id) { Airline.create(name: 'test', image_url: 'test') }
        run_test!
      end

      response '404', 'Airlines not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/airlines/{slug}' do
    get 'Find Airlines using slug' do
      tags 'Airlines'
      produces 'application/json', 'application/xml'
      parameter name: :slug, in: :path, type: :string, example: 'united-airlines'
      response '200', 'Airlines found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     type: { type: :string },
                     attributes: { type: :object,
                                   properties: {
                                     name: { type: :string },
                                     image_url: { type: :string },
                                     slug: { type: :string },
                                     avg_score: { type: :integer }
                                   } },
                     relationships: { type: :object,
                                      properties: {
                                        reviews: { type: :object,
                                                   properties: {
                                                     data: { type: :array,
                                                             items: {
                                                               type: :object,
                                                               properties: {
                                                                 title: { type: :string },
                                                                 description: { type: :string },
                                                                 score: { type: :integer },
                                                                 airline_id: { type: :integer }
                                                               }
                                                             } }
                                                   } }
                                      } }
                   }
                 },
                 included: { type: :array,
                             items: {
                               type: :object,
                               properties: {
                                 id: { type: :string },
                                 type: { type: :string },
                                 attributes: { type: :object,
                                               properties: {
                                                 title: { type: :string },
                                                 description: { type: :string },
                                                 score: { type: :integer },
                                                 airline_id: { type: :integer }
                                               } }
                               }
                             } }
               }

        let(:id) { Airline.create(name: 'Airline', image_url: '') }
        run_test!
      end
    end
  end

  path '/api/v1/airlines/{slug}' do
    delete 'Delete Airlines using slug' do
      tags 'Airlines'
      produces 'application/json', 'application/xml'
      parameter name: :slug, in: :path, type: :string, example: 'fack-airline'
      response '204', 'Airlines Deleted' do
        run_test!
      end
    end
  end
end
