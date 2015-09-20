class AddArchivedToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :archived, :boolean
    add_column :activities, :archived, :boolean
    add_column :subactivities, :archived, :boolean
  end
end
