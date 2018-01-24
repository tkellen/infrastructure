Sequel.migration do

  up do
    # Lodging types.
    create_table(:lodging_type) do
      primary_key :id
      column :name, String, :null=>false

      index :name, :unique=>true
    end

    # Unit displays for expense tracking system.
    create_table(:unit) do
      primary_key :id

      column :name, String, :null=>false
      column :abbr, String

      index :name, :unique=>true
    end

    # Add units.
    self[:unit].insert_multiple([
      {:name => 'Miles', :abbr =>'m'},
      {:name => 'Kilometers', :abbr => 'km'},
      {:name => 'Pounds', :abbr => 'lb'},
      {:name => 'Kilograms', :abbr => 'kg'},
      {:name => 'Meters', :abbr => 'm'},
      {:name => 'Feet', :abbr => 'ft'}
    ])

    # Country details for a given adventure.
    create_table(:country) do
      primary_key :id

      column :name, String, :null=>false
      column :currency_symbol, String, :null=>false
      column :currency_name, String, :null=>false
      column :notes, String, :text=>true

      index :name, :unique=>true
    end

    # Master record for adventure.
    create_table(:adventure) do
      primary_key :id

      column :name, String, :null=>false

      foreign_key :currency_country_id, :country, :null=>false
      foreign_key :dist_unit_id, :unit, :null=>false
      foreign_key :alt_unit_id, :unit, :null=>false
      foreign_key :speed_unit_id, :unit, :null=>false

      index :name, :unique=>true
    end

    # Subdivide adventure into legs.
    create_table(:leg) do
      primary_key :id

      column :ex_rate_avg, BigDecimal, :default=>BigDecimal.new("0.1E1"), :size=>[10, 2], :null=>false
      column :name, String

      foreign_key :adventure_id, :adventure, :null=>false
      foreign_key :country_id, :country, :null=>false

      index :adventure_id
      index :country_id
    end

    # Record data about actual day on the road.
    create_table(:day) do
      primary_key :id

      column :datestamp, Date, :null=>false
      column :dist, BigDecimal, :default=>BigDecimal.new("0.0"), :size=>[6, 2]

      foreign_key :leg_id, :leg, :null=>false
      foreign_key :lodging_type_id, :lodging_type, :null=>false
      foreign_key :transport_type_id, :transport_type, :null=>false
      foreign_key :track_id, :track

      index [:datestamp, :leg_id], :unique=>true
      index :leg_id
    end

    # Categorize expenses.
    create_table(:expense_type) do
      primary_key :id

      column :name, String, :null=>false
      column :daily, TrueClass, :default=>false, :null=>false

      index :name, :unique=>true
    end

    # Log expenses to a given day.
    create_table(:expense) do
      primary_key :id

      column :item, String, :text=>true, :null=>false
      column :amount, BigDecimal, :size=>[10, 2], :null=>false
      column :notes, String, :text=>true
      column :paidbydonation, TrueClass, :default=>false, :null=>false
      column :fiscalyear, Date

      foreign_key :expense_type_id, :expense_type, :null=>false
      foreign_key :adventure_id, :adventure
      foreign_key :day_id, :day

      index :day_id
    end

  end

  down do
    drop_table(:expense)
    drop_table(:expense_type)
    drop_table(:day)
    drop_table(:leg)
    drop_table(:adventure)
    drop_table(:country)
    drop_table(:unit)
    drop_table(:lodging_type)
  end

end
