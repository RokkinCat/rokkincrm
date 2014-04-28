Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :name
      String :email
      String :crypted_password
      String :server
      String :imap_username
      String :imap_password

      index :email, unique: true
      index :imap_username, unique: true
    end
  end

  down do
    drop_table :users
  end
end
