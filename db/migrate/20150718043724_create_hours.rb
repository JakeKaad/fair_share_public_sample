class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.belongs_to :member
      t.integer :quantity
      t.datetime :date_earned
      t.timestamps
    end
  end
end
