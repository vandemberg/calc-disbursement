class ShoppersImport
  def initialize(shoppers)
    @shoppers = shoppers
  end

  def import
    @shoppers.each do |shopper|
      next if Shopper.where({ id: shopper['id'] }).exists?

      shopper = Shopper.new({
        id: shopper['id'],
        name: shopper['name'],
        email: shopper['email'],
        nif: shopper['nif'],
      })

      shopper.save!

      yield(shopper) if block_given?
    end
  end
end