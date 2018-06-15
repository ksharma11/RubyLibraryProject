require 'spec_helper'

describe WidgetDetails do
  describe '#find_by_name' do
    it 'returns its widget details' do
      expect(WidgetDetails.find_by_name("Direct")).to be_an_instance_of(WidgetDetails)
      expect(WidgetDetails.find_by_name("Direct").name).to eq("Direct")
      expect(WidgetDetails.find_by_name("Direct").price).to eq(100)
      expect(WidgetDetails.find_by_name("Direct").affiliate).to eq(false)
      expect(WidgetDetails.find_by_name("Direct").reseller).to eq(false)
    end

    it "when the widget is not listed in the yaml" do
      expect(WidgetDetails.find_by_name('No Soy un Widget')).to be_nil
    end
  end

  describe "#widget_sale_source_names" do
    it 'returns array of widget source names' do
      expect(WidgetDetails.widget_source_names).to eq(["Direct",
                                                       "ACompany",
                                                       "AnotherCompany",
                                                       "EvenMoreCompany",
                                                       "ResellThis",
                                                       "SellMoreThings"
                                                      ])
    end
  end

  describe '#source_creator' do
    it 'gives all 6 sources' do
      expect(WidgetDetails.widget_source_creator.count).to eq 6
    end

    it 'gives the full source objects and attributes' do
      widget_source = WidgetDetails.widget_source_creator.first
      expect(widget_source.name).to eq 'Direct'
      expect(widget_source.price).to eq 100
      expect(widget_source.affiliate).to be false
      expect(widget_source.reseller).to be false
    end
  end

  describe '#cost_per_unit' do
    let(:direct_source) { WidgetDetails.new(name: 'Direct', price: 100, affiliate: false, reseller: false) }
    let(:affiliate_source) { WidgetDetails.new(name: 'ACompany', price: 75, affiliate: true, reseller: false) }
    let(:reseller_source) { WidgetDetails.new(name: 'SellMoreThings', price: 85, affiliate: false, reseller: true) }

    it 'gives the cost per unit for a direct sale' do
      expect(direct_source.cost_per_unit).to eq 100
    end
    it 'gives the cost per unit for a reseller' do
      expect(reseller_source.cost_per_unit).to eq 50
    end
    context 'gives the cost per unit for an affiliate, with quantity discounts' do
      it 'gives no discount for 500 units or fewer sold' do
        expect(affiliate_source.cost_per_unit(500)).to eq 60
      end
      it 'gives a discount for 501-1000 units sold' do
        expect(affiliate_source.cost_per_unit(700)).to eq 50
      end
      it 'gives a bigger discount for 1001 units or more sold' do
        expect(affiliate_source.cost_per_unit(1001)).to eq 40
      end
    end
  end
end
