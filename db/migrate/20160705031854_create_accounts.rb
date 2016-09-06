class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name
      t.integer :balance_type
      t.boolean :tax_advantaged, :default => false
      t.string :ticker

      t.timestamps
    end
  end
end
