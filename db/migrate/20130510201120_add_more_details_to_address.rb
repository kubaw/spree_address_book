class AddMoreDetailsToAddress < ActiveRecord::Migration
  def change
    add_column addresses_table_name, :street, :string
    add_column addresses_table_name, :house_no, :string
    add_column addresses_table_name, :flat_no, :string
  end
  private
  
  def addresses_table_name
    table_exists?('addresses') ? :addresses : :spree_addresses
  end

end
