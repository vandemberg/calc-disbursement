class MerchantsImport
  def initialize(merchants)
    @merchants = merchants
  end

  def import
    @merchants.each do |merchant|
      next if Merchant.where({ id: merchant['id'] }).exists?

      merchant = Merchant.new({
        id: merchant['id'],
        name: merchant['name'],
        email: merchant['email'],
        cif: merchant['cif'],
      })

      merchant.save!

      yield(merchant) if block_given?
    end
  end
end