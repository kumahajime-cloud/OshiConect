class CreateOshis < ActiveRecord::Migration[7.0]
  def change
    create_table :oshis do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :oshis, [:user_id, :name], unique: true
  end
end
