Sequel.migration do
  up do
    create_table :ignore_rules do
      primary_key :id
      String :rule, unique: true
    end
  end

  down do
    drop_table :ignore_rules
  end
end
