Sequel.migration do

  up do
    # Location names for tracks to originate from.
    create_table(:location) do
      primary_key :id

      column :name, String
      column :lat, BigDecimal, :size=>[8, 4]
      column :lng, BigDecimal, :size=>[8, 4]
      column :marker, String, :text=>true
      column :date_added, Date, :default=>Sequel::CURRENT_DATE, :null=>false
    end

    # Transportation types.
    create_table(:transport_type) do
      primary_key :id

      column :name, String, :text=>true, :null=>false
      column :nodist, TrueClass, :default=>false, :null=>false

      index :name, :unique=>true
    end

    # Master record for a track.
    create_table(:track) do
      primary_key :id

      column :datestamp, Date
      column :dist, BigDecimal, :default=>BigDecimal.new("0.0"), :size=>[6, 2], :null=>false
      column :alt, Integer
      column :ascent, Integer, :default=>0, :null=>false
      column :descent, Integer, :default=>0, :null=>false

      foreign_key :start_location_id, :location, :key=>[:id]
      foreign_key :end_location_id, :location, :key=>[:id]

      index [:start_location_id], :name=>:track_start_location_id
    end

    # Points recorded along a track
    create_table(:track_point) do
      primary_key :id

      column :lat, BigDecimal, :size=>[8, 4], :null=>false
      column :lng, BigDecimal, :size=>[8, 4], :null=>false
      column :alt, Integer ,:null=>false
      column :dist, BigDecimal, :size=>[6, 2]
      column :speed, BigDecimal, :size=>[6, 2]

      foreign_key :track_id, :track, :null=>false, :key=>[:id]

      index :track_id
    end

    # Transportation used for a given track
    create_table(:track_transport) do
      primary_key :id

      foreign_key :track_id, :track, :null=>false
      foreign_key :transport_type_id, :transport_type, :null=>false

      index [:track_id, :transport_type_id], :unique=>true
    end
  end

  down do
    drop_table(:track_transport)
    drop_table(:track_point)
    drop_table(:track)
    drop_table(:transport_type)
    drop_table(:location)
  end

end
