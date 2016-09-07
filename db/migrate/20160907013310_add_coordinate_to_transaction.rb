class AddCoordinateToTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :coordinate, :st_point
  end
end
