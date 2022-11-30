require 'rails_helper'

RSpec.describe "Api::V1::Disbursements", type: :request do
  before(:all) do
    ['merchants', 'shoppers' ,'orders'].each do |table|
      table_path = Rails.root.join('dump', "#{table}.json")
      table_json = File.read(table_path)
      table_data = JSON.parse(table_json)['RECORDS']

      "#{table.capitalize}Import".constantize.new(table_data).import
    end

    @merchants = Merchant.all
    merchant_id = @merchants.first.id
    disbursement = Disbursement.create(year: 2018, week: 1, merchant_id: merchant_id, status: :processing)
    DisbursementProcessJob.new.perform(disbursement.id)
  end

  describe "GET /index" do
    context "list all disbursements" do
      it 'should return all disbursements' do
        get("/api/v1/disbursements")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to eq(1)
      end
    end

    context "list disbursements by merchant_id" do
      it "should return all merchant_id from first merchant" do
        get("/api/v1/disbursements/#{@merchants.first.id}")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to eq(1)
      end

      it "should return a empty disbursements list" do
        get("/api/v1/disbursements/#{@merchants.last.id}")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to be(0)
      end
    end

    context "list disbursements by merchant_id and year" do
      it "should return all merchant_id from first merchant" do
        get("/api/v1/disbursements/#{@merchants.first.id}/2018")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to eq(1)
      end

      it "should return a empty disbursements list" do
        get("/api/v1/disbursements/#{@merchants.first.id}/2019")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to be(0)
      end
    end

    context "list dibusrments by merchant_id and year and week" do
      it "should return all merchant_id from first merchant" do
        get("/api/v1/disbursements/#{@merchants.first.id}/2018/1")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to eq(1)
      end

      it "should return a empty disbursements list" do
        get("/api/v1/disbursements/#{@merchants.first.id}/2018/2")
        disbursements = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(disbursements.length).to be(0)
      end
    end
  end

  describe "POST /create" do
    it "should schedule a disbursement calc in specific year and week" do
      post("/api/v1/disbursements/#{@merchants.first.id}/2018/2")

      disbursement = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(disbursement['year']).to eq(2018)
      expect(disbursement['week']).to eq(2)
      expect(disbursement['status']).to eq('processing')
      expect(disbursement['value']).to eq(nil)
    end

    it "should return a already calculated disbursement calc" do
      post("/api/v1/disbursements/#{@merchants.first.id}/2018/1")
      disbursement = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(disbursement['year']).to eq(2018)
      expect(disbursement['week']).to eq(1)
      expect(disbursement['status']).to eq('calculated')
      expect(disbursement['value']).to eq(36729)
    end
  end
end
