class Report
  attr_accessor :orders

  def initialize
    @orders = Order.generate_randomized_orders(100) if Order.within_last_month?
  end

  def total_revenue
    total = 0
    WidgetDetails.widget_source_creator.each do |source|
      total += total_billed_for_source(source)
    end
    total
  end

  def total_bill(widget_source_name)
    return unless source_object = WidgetDetails.find_by_name(widget_source_name)
    total_billed_for_source(source_object)
  end

  def total_profit(widget_source_name)
    return unless source_object = WidgetDetails.find_by_name(widget_source_name)
    profit_for_source(source_object)
  end

  def total_billed_for_source(widget_source_name)
    quantity = total_quantity_sold(widget_source_name)
    quantity * widget_source_name.cost_per_unit(quantity)
  end


  def profit_for_source(widget_source_name)
    revenue_for_source(widget_source_name) - total_billed_for_source(widget_source_name)
  end

  def total_quantity_sold(widget_source_name)
    quantity = 0
    orders.each do |order|
      quantity += order.quantity if order.source_name == widget_source_name.name
    end
    quantity
  end

  def revenue_for_source(widget_source_name)
    total_quantity_sold(widget_source_name) * widget_source_name.price
  end
end
