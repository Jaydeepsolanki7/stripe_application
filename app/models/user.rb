class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  after_create :create_stripe_customer

  def create_stripe_customer
    customer = Stripe::Customer.create({
      email: email
    })
    update(stripe_customer_id: customer.id)
  end
end
