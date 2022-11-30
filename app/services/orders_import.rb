class OrdersImport
  def initialize(orders)
    @orders = orders
  end

  def import
    @orders.each do |order|
      next if Order.where({ id: order['id'] }).exists?

      order = Order.new({
        id: order['id'],
        merchant_id: order['merchant_id'],
        shopper_id: order['shopper_id'],
        amount: (order['amount'].to_f * 100), # convert amount to cents $1 => 100 cents of $
        created_at: order['created_at'],
        completed_at: order['completed_at'],
      })

      order.save!

      yield(order) if block_given?
    end
  end
end