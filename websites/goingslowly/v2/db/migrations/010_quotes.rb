Sequel.migration do

  up do
    # Record quotes we like.
    create_table(:quote) do
      primary_key :id
      column :date_published, Date, :default=>Sequel::CURRENT_DATE, :null=>false
      column :quote, String, :text=>true, :null=>false
      column :author, String, :null=>false
      column :details, String, :text=>true
      column :published, TrueClass, :default=>false, :null=>false

      foreign_key :photo_id, :photo
    end
  end

  down do
    drop_table(:quote)
  end

end
