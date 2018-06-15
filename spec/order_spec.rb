require 'spec_helper'

describe Order do
  describe '#initializing' do
    let(:quantity) { 10 }
    it "Valid Widget details" do
      expect { Order.new(quantity: quantity, source_name: "ResellThis", amount_paid: 500 ) }.not_to raise_error
    end

    it 'sets the total amount paid equal to source price times quantity' do
      widget_source = instance_double(WidgetDetails, name: 'test', price: 10)
      allow(WidgetDetails).to receive(:find_by_name).and_return(widget_source)
      order = Order.new(quantity: quantity, amount_paid: widget_source.price * quantity)
      expect(order.amount_paid).to eq 100
    end
  end

  describe '#generate_random' do
    it 'generates as many orders as requested' do
      expect(Order.generate_randomized_orders(100).size).to eq 100
      expect(Order.generate_randomized_orders(42).size).to eq 42
    end
  end

  describe '#random_order' do
    it " generates random order" do
      order = Order.random_order
      expect(order.quantity).to be_between(1,100)
      expect(WidgetDetails.widget_source_names).to include order.source_name
    end
  end
end
