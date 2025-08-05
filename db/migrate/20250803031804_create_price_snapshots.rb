class CreatePriceSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :price_snapshots do |t|
      t.references :currency, null: false, foreign_key: true
      t.decimal :last, precision: 20, scale: 8, null: false
      t.decimal :bid, precision: 20, scale: 8, null: false
      t.decimal :ask, precision: 20, scale: 8, null: false
      t.datetime :captured_at, null: false
      t.timestamps
    end

    # Add indexes for frequently queried fields
    add_index :price_snapshots, :captured_at
    add_index :price_snapshots, [ :currency_id, :captured_at ]
  end
end
