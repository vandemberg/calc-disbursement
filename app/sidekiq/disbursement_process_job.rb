class DisbursementProcessJob
  include Sidekiq::Job

  def perform(disbursement_id)
    disbursement = Disbursement.find(disbursement_id)

    merchant_id = disbursement.merchant_id
    week = disbursement.week
    time = Time.current.change(year: disbursement.year)
    time = time.beginning_of_year + week.weeks
    
    orders = Order.where({
      merchant_id: merchant_id,
      created_at: time.beginning_of_week..time.end_of_week,
    }).where('completed_at IS NOT NULL')

    value = 0
    orders.each do |order|
      value += CalcDisbursement.new(order.amount).calc
    end

    disbursement.update({
      value: value,
      status: :calculated,
    })
  end
end
