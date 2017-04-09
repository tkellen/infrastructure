Sequel.migration do

  up do
    create_table(:chatters) do
      primary_key :id
      foreign_key :member_id, :members, {:null=>false}
      column :stamp, DateTime, {:null=>false,:default=>:now.sql_function}
      column :connections, Integer, {:null=>false,:default=>1}
      index :member_id
    end
  end

  down do
    drop_table(:chatters)
  end

end

