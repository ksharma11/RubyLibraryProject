require 'date'
class Order
  ORDER_DATE = "2018-06-15 23:59:59 -0700" #This is assumed order_date
  def initialize(attributes)
    @quantity = attributes[:quantity]
    @source_name = attributes[:source_name]
    @amount_paid = attributes[:amount_paid]
  end

  attr_accessor :quantity,
                :source_name,
                :amount_paid

  def self.within_last_month?
    Date.today - Date.parse(ORDER_DATE) <= 30
  end

  def self.generate_randomized_orders(number)
    orders=[]
    number.times do
      orders << random_order
    end
    orders
  end

  def self.random_order
    quantity = rand(100)
    source_object = WidgetDetails.widget_source_creator.sample
    new(quantity: quantity, source_name: source_object.name, amount_paid: source_object.price * quantity)
  end
end
