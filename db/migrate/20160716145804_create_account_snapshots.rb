class CreateAccountSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :account_snapshots, id: :uuid do |t|
      t.float :value
      t.string :note
      t.date :month
      t.references :account, type: :uuid, foreign_key:true

      t.timestamps
    end
  end
end
