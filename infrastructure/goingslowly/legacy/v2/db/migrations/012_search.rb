Sequel.migration do

  up do
    # Track searches
    create_table(:search_history) do
      primary_key :id

      column :stamp, DateTime, :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :query, String, :text=>true
      column :ip, :cidr, :null=>false
    end

  end

  down do
    drop_table(:search_history)
  end

end
