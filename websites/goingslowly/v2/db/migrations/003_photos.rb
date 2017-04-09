Sequel.migration do

  up do
    # Photo set, mapping to flickr and smugmug.
    create_table(:photo_set) do
      primary_key :id

      column :name, String
      column :ordering, Integer
      column :s_cat_id, String
      column :s_subcat_id, String
      column :s_album_id, String
      column :f_set_id, String

      foreign_key :leg_id, :leg

      index :leg_id
    end

    # Photo record, mapping to any service needed.
    create_table(:photo) do
      primary_key :id

      column :name, String
      column :date_taken, DateTime
      column :f_url_base, String
      column :f_url_orig, String
      column :f_id, String
      column :s_id, String
      column :type, String
      column :filename, String
      column :uploaded, TrueClass, :null=>false, :default=>false
      column :uploading, TrueClass, :null=>false, :default=>false

      foreign_key :photo_set_id, :photo_set, :key=>[:id]

      index :f_id, :unique=>true
      index :s_id, :unique=>true
    end
  end

  down do
    drop_table(:photo)
    drop_table(:photo_set)
  end

end
