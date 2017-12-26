Sequel.migration do

  up do
    # Record nice message we've received.
    create_table(:letter) do
      primary_key :id
      column :date_sent, Date, :default=>Sequel::CURRENT_DATE, :null=>false
      column :author, String, :null=>false
      column :author_email, String, :null=>false
      column :location, String
      column :body, String, :text=>true, :null=>false
      column :published, TrueClass, :default=>false, :null=>false
      column :settings, String
      column :author_display, String
    end
  end

  down do
    drop_table(:letter)
  end

end
