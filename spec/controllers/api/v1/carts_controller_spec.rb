require "rails_helper"

describe Api::V1::CartsController do
  render_views

  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:product_ingredient) { create :product_ingredient }

  let(:cart) {
    {
      total: 110,
      shipping_fee: 10,
      subtotal: 100,
      customer_attributes: {
        email: 'foo@de.com'
      },
      cart_products_attributes: [
        {product_id: product_ingredient.product.id, quantity: 1,
          cart_product_ingredients_attributes: [
            {
              ingredient_id: product_ingredient.ingredient.id,
              percentage: 1,
              weight: 10,
              price: 20
            }
          ]
        }
      ]
    }
  }

  describe "POST checkout" do
    let(:stripe_helper) { StripeMock.create_test_helper }

    before :each do
      cart_product = create :cart_product
      @cart = cart_product.cart

      @cart_attribute = {
        total: 120,
        customer_attributes: {
          id: @cart.customer.id,
          addresses_attributes: [
            {
              street_address: "327/38 Albany",
              city: "Sydney",
              state: "NSW",
              zip: "2056"
            }
          ]
        }
      }
    end

    it "raises error while paying" do
      StripeMock.start
      StripeMock.prepare_card_error(:card_declined)

      post :checkout, { id: @cart.id, cart: @cart_attribute, format: :json }

      StripeMock.stop
    end
  end

  describe "POST create" do
    it "create a pending cart with its customer" do
      post :create, { cart: cart, format: :josn }

      data = JSON.parse(response.body)

      expect(response).to have_http_status(200)
    end
  end
end
