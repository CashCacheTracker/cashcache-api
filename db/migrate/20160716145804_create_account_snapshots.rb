class CreateAccountSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :account_snapshots do |t|
      t.float :value
      t.string :note
      t.date :month
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
