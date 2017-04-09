Sequel.migration do

  up do
    # track 404 pages
    create_table(:fourohfour) do
      primary_key :id
      column :url, String, {:null=>false}
      column :count, Integer, {:null=>false,:default=>0}
      column :referrer, String
      index :url
    end
  end

  down do
    drop_table(:fourohfour)
  end
end
