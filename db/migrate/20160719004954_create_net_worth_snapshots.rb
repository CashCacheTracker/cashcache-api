class CreateNetWorthSnapshots < ActiveRecord::Migration[5.0]
  def up
    execute "DROP VIEW IF EXISTS net_worth_snapshots"
    # TODO populate A/AS ids for sideloading?
    execute %{
      CREATE VIEW net_worth_snapshots AS
      SELECT month, SUM(account_snapshots.value) AS total
      FROM account_snapshots
      GROUP BY month
    }
  end

  def down
    execute "DROP VIEW IF EXISTS net_worth_snapshots"
  end
end
