require 'yaml'
class WidgetDetails
  attr_accessor :name, :price, :affiliate, :reseller
  def initialize(attributes)
    @name = attributes[:name]
    @price = attributes[:price]
    @affiliate = attributes[:affiliate]
    @reseller = attributes[:reseller]
  end

  def self.find_by_name(name)
    widget_source_creator.select { |source| source.name == name }.first
  end

  def self.widget_source_names
    widget_source_creator.collect { |source| source.name }
  end

  def cost_per_unit(quantity=0)
    return 50 if reseller?
    return affiliate_cost_per_unit(quantity) if affiliate?
    return 100
  end

  def affiliate_cost_per_unit(quantity)
    return 40 if quantity > 1000
    return 50 if quantity > 500
    return 60
  end

  def self.widget_source_creator
    raw_given_data.collect do |raw_data|
      new(
        name: raw_data["name"],
        price: raw_data["price"],
        affiliate: raw_data["affiliate"],
        reseller: raw_data["reseller"]
      )
    end
  end
  private

  def self.raw_given_data
    [
      "direct",
      "a_company",
      "another_company",
      "even_more_company",
      "resell_this",
      "sell_more_things"
    ].map{ |source| YAML.load(File.read("fixtures/raw_data.yml")).fetch(source)}
  end

  def affiliate?
    affiliate
  end

  def reseller?
    reseller
  end
end
