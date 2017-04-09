Sequel.migration do

  up do
    # Members of our website.
    create_table(:member) do
      primary_key :id
      column :name, String
      column :email, String
      column :date_joined, DateTime, :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
    end

    # Email lists.
    create_table(:email_list) do
      primary_key :id
      String :name, :text=>true, :null=>false

      index [:name], :name=>:email_list_name_key, :unique=>true
    end

    # Assign members to email lists
    create_table(:email_list_member) do
      primary_key :id
      column :confirmed, TrueClass, :default=>false, :null=>false
      column :key, String
      column :unsubscribed, TrueClass, :default=>false, :null=>false

      foreign_key :email_list_id, :email_list, :null=>false
      foreign_key :member_id, :member, :null=>false
    end

  end

  down do
    drop_table(:email_list_member)
    drop_table(:email_list)
    drop_table(:member)
  end
end
