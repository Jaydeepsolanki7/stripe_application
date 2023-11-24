class Stripe::CheckoutController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create_checkout_session
    debugger
    @product = Product.find(params[:id])
    
    session = Stripe::Checkout::Session.create(
        customer: current_user.stripe_customer_id,
        payment_method_types: ['card'],
        metadata: {
    
        product_id: @product.id,
        user_id: current_user.id,
        },

        line_items: [{
          price_data: {
            currency: 'usd',
            product_data: {
              name: @product.name,
            },
            unit_amount: @product.price,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: root_url,
        cancel_url: root_url,
  )
  flash[:success] = "Order is completed"
  redirect_to session.url, allow_other_host: true
  end

  def webhook_subcription
    debugger
    webhook_secret = 'whsec_GknVcc7nU6kwzVxHWQqpPfU7oYM7ItJU'
    payload = request.body.read
    if !webhook_secret.empty?
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, webhook_secret
        )
      rescue JSON::ParserError => e
        status 400
        return
      end
    else
      data = JSON.parse(payload, symbolize_names: true)
      event = Stripe::Event.construct_from(data)
    end
    event_type = event['type']
    data = event['data']
    data_object = data['object']

    if event.type == 'customer.subscription.deleted'
      puts "Subscription canceled: #{event.id}"
    end

    if event.type == 'customer.subscription.updated'

      puts "Subscription updated: #{event.id}"
    end

    if event.type == 'customer.subscription.created'
      puts "Subscription created: #{event.id}"
    end

    if event.type == 'customer.subscription.trial_will_end'
      puts "Subscription trial will end: #{event.id}"
    end

    render json: {message: "success"}
  end
end