Sequel.migration do

  up do
    create_table(:chats) do
      primary_key :id
      foreign_key :member_id, :members, {:null=>false}
      column :stamp, DateTime, {:null=>false,:default=>:now.sql_function}
      column :message, String
      index :member_id
    end
  end

  down do
    drop_table(:chats)
  end

end

