class Disbursement < ApplicationRecord
  enum status: [ :processing, :calculated, :paying, :paied ]

  belongs_to :merchant
end
