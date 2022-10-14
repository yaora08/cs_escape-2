class AddIndexToUsersNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notification, :boolean, default: false
  end
end
