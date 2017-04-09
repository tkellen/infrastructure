Sequel.migration do

  up do
    # Categorize contacts.
    create_table(:contact_type) do
      primary_key :id
      String :name, :text=>true, :null=>false

      index [:name], :name=>:contact_type_name_key, :unique=>true
    end

    # Master contact record.
    create_table(:contact) do
      primary_key :id

      column :address, String
      column :email_one, String
      column :phone_home, String
      column :phone_mobile, String
      column :name_one, String
      column :name_two, String
      column :email_two, String
      column :archived, TrueClass, :default=>false, :null=>false
      column :notes, String, :text=>true

      foreign_key :contact_type_id, :contact_type, :null=>false
      foreign_key :country_id, :country
    end

    # Lists for contacts
    create_table(:contact_list) do
      primary_key :id

      column :name, String, :null=>false
      column :notes, String, :text=>true

      index :name, :unique=>true
    end

    # Assign members to contact lists
    create_table(:contact_list_member) do
      primary_key :id

      foreign_key :contact_list_id, :contact_list, :null=>false
      foreign_key :contact_id, :contact, :null=>false
      column :cardsent, TrueClass, :default=>false, :null=>false

      index [:contact_list_id, :contact_id], :name=>:contact_list_member_contact_list_id_contact_id, :unique=>true
    end
  end

  down do
    drop_table(:contact_list_member)
    drop_table(:contact_list)
    drop_table(:contact)
    drop_table(:contact_type)
  end

end
