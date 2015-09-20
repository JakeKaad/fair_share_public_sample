class AddAddressToMembers < ActiveRecord::Migration
  def change
    add_column :members, :street_address, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :zip, :string
  end
end
