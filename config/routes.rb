Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get('disbursements', to: 'disbursements#index')
      get('disbursements/:merchant_id', to: 'disbursements#index')
      get('disbursements/:merchant_id/:year', to: 'disbursements#index')
      get('disbursements/:merchant_id/:year/:week', to: 'disbursements#index')
      
      post('disbursements/:merchant_id/:year/:week', to: 'disbursements#create')
    end
  end
end
