class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.float :value
      t.string :note
      t.date :date
      t.string :description
      t.string :location
      t.boolean :is_split, :default => false

      t.timestamps
    end
  end
end
