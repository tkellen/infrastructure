Sequel.migration do

  up do
    # Track our monthly budget
    create_table(:budget) do
      primary_key :id

      column :name, String, :text=>true, :null=>false
      column :total, BigDecimal, :default=>BigDecimal.new("0.0"), :null=>false
      column :goal, BigDecimal, :default=>BigDecimal.new("0.0"), :null=>false
    end
  end

  down do
    drop_table(:budget)
  end

end
