namespace :setup do
  desc "Import database by JSON or CSV files"
  task :database => :environment do
    puts "#### Starting import database JSON ####\n\n"

    # import merchants
    puts "\n\n==> Importing Merchants\n"
    ActiveRecord::Base.transaction do
      merchants_path = Rails.root.join('dump', "merchants.json")
      merchants_json = File.read(merchants_path)
      merchants = JSON.parse(merchants_json)['RECORDS']
    
      MerchantsImport.new(merchants).import do |merchant|
        puts "====> merchant #{merchant.email} importated with success"
      end
    end

    # import shoppers
    puts "\n\n==> Importing Shoppers\n"
    ActiveRecord::Base.transaction do
      shoppers_path = Rails.root.join('dump', "shoppers.json")
      shoppers_json = File.read(shoppers_path)
      shoppers = JSON.parse(shoppers_json)['RECORDS']
    
      ShoppersImport.new(shoppers).import do |shooper|
        puts "====> shooper #{shooper.email} importated with success"
      end
    end

    # import orders
    puts "\n\n==> Importing Orders\n"
    ActiveRecord::Base.transaction do
      orders_path = Rails.root.join('dump', "orders.json")
      orders_json = File.read(orders_path)
      orders = JSON.parse(orders_json)['RECORDS']
    
      OrdersImport.new(orders).import do |order|
        puts "====> shooper #{order.amount} at #{order.created_at} importated with success"
      end
    end

    puts "\n\n# Ending database import"
  end
end
