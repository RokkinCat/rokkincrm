Sequel.migration do
  up do
    alter_table :users do
      add_column :last_fetch, DateTime
    end
  end

  down do
    alter_table :users do
      drop_column :last_fetch
    end
  end
end
