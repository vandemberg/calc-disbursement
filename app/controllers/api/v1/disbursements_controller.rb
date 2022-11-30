class Api::V1::DisbursementsController < Api::V1::ApplicationController
  def index
    disbursements = Disbursement.all
    year = safe_params[:year]
    week = safe_params[:week]
    merchant_id = safe_params[:merchant_id]

    if merchant_id.present?
      disbursements = disbursements.where(merchant_id: merchant_id)
    end

    if merchant_id.present? and year.present?
      disbursements = disbursements.where(year: year)
    end

    if merchant_id.present? and year.present? and week.present?
      disbursements = disbursements.where(week: week)
    end

    render({ json: disbursements, status: :ok })
  end

  def create
    week = params[:week]
    merchant_id = params[:merchant_id]
    year = params[:year]
    disbursement = Disbursement.where(week: params[:week], merchant_id: params[:merchant_id]).first

    if not disbursement.present?
      disbursement = Disbursement.create(year: year, week: week, merchant_id: merchant_id, status: :processing)
      DisbursementProcessJob.perform_async(disbursement.id)
    end

    render(json: disbursement, status: :created)
  end

  private

  def safe_params
    params.permit(:merchant_id, :year, :week)
  end
end
