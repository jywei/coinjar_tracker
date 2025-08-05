class AddIndexesToPriceSnapshots < ActiveRecord::Migration[8.0]
  def change
    # Add indexes for frequently queried fields
    add_index :price_snapshots, :captured_at
    add_index :price_snapshots, [:currency_id, :captured_at]
  end
end
