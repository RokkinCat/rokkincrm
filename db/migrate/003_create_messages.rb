Sequel.migration do
  up do
    create_table :messages do
      primary_key :id

      String :message_id
      String :subject
      String :from

      column :to, 'text[]'
      column :cc, 'text[]'
      column :bcc, 'text[]'
      column :attachments, 'text[]'
      column :references, 'text[]'

      String :body
      String :rfc822

      DateTime :sent_at
      DateTime :created_at
    end
  end

  down do
    drop_table :messages
  end
end
