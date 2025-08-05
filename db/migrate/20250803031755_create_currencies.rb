class CreateCurrencies < ActiveRecord::Migration[8.0]
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.string :symbol, null: false
      t.timestamps
    end

    # Add database-level uniqueness constraints
    add_index :currencies, :name, unique: true
    add_index :currencies, :symbol, unique: true
  end
end
