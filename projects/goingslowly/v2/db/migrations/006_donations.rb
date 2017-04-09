Sequel.migration do

  up do
    # Record donations
    create_table(:donation) do
      primary_key :id

      column :amount, BigDecimal, :size=>[10, 2], :null=>false
      column :amount_spent, BigDecimal, :default=>BigDecimal.new("0.0"), :size=>[10, 2], :null=>false
      column :date_donated, Date, :default=>Sequel::CURRENT_DATE, :null=>false
      column :notes, String, :text=>true

      foreign_key :contact_id, :contact, :null=>false
    end

    create_table(:expense_donation) do
      primary_key :id

      foreign_key :expense_id, :expense, :null=>false
      foreign_key :donation_id, :donation, :null=>false

      index [:expense_id, :donation_id], :unique=>true
    end
  end

  down do
    drop_table(:expense_donation)
    drop_table(:donation)
  end

end
