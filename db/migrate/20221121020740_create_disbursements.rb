class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.integer :year
      t.integer :week
      t.integer :value
      t.integer :status

      t.timestamps
    end
  end
end
