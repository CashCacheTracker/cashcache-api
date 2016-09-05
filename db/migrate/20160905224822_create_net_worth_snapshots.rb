class CreateNetWorthSnapshots < ActiveRecord::Migration
  def change
    create_view :net_worth_snapshots
  end
end
