Sequel.migration do

  up do
    # members
    create_table(:members) do
      primary_key :id
      column :name, String, {:null=>false,:unique=>true}
      column :email, String
    end

    # photos
    create_table(:photos) do
      primary_key :id
      foreign_key :member_id, :members, {:null=>false}
      column :title, String
      column :description, String
      column :date_added, Date, {:null=>false,:default=>:now.sql_function}
      index :member_id
    end
  end

  down do
    # drop all tables
    drop_table(:photos)
    drop_table(:members)
  end

end

