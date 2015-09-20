class AddArchivedToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :archived, :boolean
  end
end
