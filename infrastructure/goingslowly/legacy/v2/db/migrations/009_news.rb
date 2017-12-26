Sequel.migration do

  up do
    # Record places we've been in the media.
    create_table(:news) do
      primary_key :id

      column :date_sent, Date, :default=>Sequel::CURRENT_DATE, :null=>false
      column :title, String, :null=>false
      column :details, String, :text=>true
      column :url, String
      column :published, TrueClass, :default=>false, :null=>false

      index :published
    end
  end

  down do
    drop_table(:news)
  end

end
