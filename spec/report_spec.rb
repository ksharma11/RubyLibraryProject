
require 'spec_helper'

describe Report do
  let(:report) { Report.new }
  let(:order) { report.orders.first }
  let(:widget_source_object) { WidgetDetails.find_by_name('ACompany') }

  describe '#initializing' do
    it 'should initialize with orders from last month by default' do
      expect(order).to be_an_instance_of(Order)
      expect(report.orders.size).to eq 100
    end
  end

  context 'for reporting period' do
    describe '#total_revenue' do
      it 'totals billing amounts for each source into a grand total' do
        allow(report).to receive(:total_billed_for_source).and_return(10)
        expect(report.total_revenue).to eq 60
      end
    end

    describe '#total_bill' do
      it 'calculates total amount company should bill the affiliate or reseller' do
        expect(WidgetDetails).to receive(:find_by_name).and_return(widget_source_object)
        expect(report).to receive(:total_billed_for_source).with(widget_source_object)
        report.total_bill('ACompany')
      end
    end

    describe '#total_profit' do
      it 'calculates total profit for the affiliate or reseller named' do
        expect(WidgetDetails).to receive(:find_by_name).and_return(widget_source_object)
        expect(report).to receive(:profit_for_source).with(widget_source_object)
        report.total_profit('ACompany')
      end
    end

    describe '#total_billed_for_source' do
      it 'calculates total cost for each source (quantity * cost per unit)' do
        allow(report).to receive(:total_quantity_sold).with(widget_source_object).and_return(5)
        allow(widget_source_object).to receive(:cost_per_unit).with(5).and_return(15)
        expect(report.total_billed_for_source(widget_source_object)).to eq 75
      end
    end

    describe '#profit_for_source' do
      it 'totals the profit for the source specified' do
        allow(report).to receive(:revenue_for_source).with(widget_source_object).and_return(50)
        allow(report).to receive(:total_billed_for_source).with(widget_source_object).and_return(30)
        expect(report.profit_for_source(widget_source_object)).to eq 20
      end
    end

    describe '#total_quantity_sold' do
      let(:mock_orders) do
        [
          Order.new(source_name: 'ACompany', quantity: 15),
          Order.new(source_name: 'ACompany', quantity: 6),
          Order.new(source_name: 'ACompany', quantity: 2003),
          Order.new(source_name: 'Direct', quantity: 100)
        ]
      end

      it 'sums quantity values for all orders from the source specified' do
        allow(report).to receive(:orders).and_return(mock_orders)
        expect(report.total_quantity_sold(widget_source_object)).to eq 2024
      end
    end

    describe '#revenue_for_source' do
      it 'calculates total revenue for source specified' do
        allow(report).to receive(:total_quantity_sold).with(widget_source_object).and_return(300)
        # ACompany's price is $75 per unit
        expect(report.revenue_for_source(widget_source_object)).to eq 22_500
      end
    end
  end
end
