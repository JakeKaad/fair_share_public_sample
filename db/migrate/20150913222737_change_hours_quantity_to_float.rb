class ChangeHoursQuantityToFloat < ActiveRecord::Migration
  def change
    change_column :hours, :quantity, :float
  end
end
