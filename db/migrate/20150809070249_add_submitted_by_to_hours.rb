class AddSubmittedByToHours < ActiveRecord::Migration
  def change
    add_column :hours, :submitted_by, :integer
  end
end
