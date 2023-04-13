class RenameColumnIsp < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :ISP
    add_column :posts, :provider, :string
  end
end
