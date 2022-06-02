class CreateUptimes < ActiveRecord::Migration[7.0]
  def change
    create_table :uptimes do |t|
      t.string :host
      t.integer :interval
      t.boolean :cancelled

      t.timestamps
    end
  end
end
