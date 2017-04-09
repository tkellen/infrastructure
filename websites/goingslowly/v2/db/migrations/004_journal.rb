Sequel.migration do

  up do
    # Authors for journal entries
    create_table(:author) do
      primary_key :id

      column :name, String
      column :email, String

      index :email, :unique=>true
      index :name, :unique=>true
    end

    # Share random bits of javascript between journal entries
    create_table(:widget) do
      primary_key :id

      column :name, String, :null=>false
      column :code, String, :null=>false

      index :name, :unique=>true
    end

    # Rating levels for journal entries
    create_table(:rating) do
      primary_key :id

      column :name, String, :null=>false
      column :display, String

      index :name, :unique=>true
    end

    # Overall sections for journal entries
    create_table(:section) do
      primary_key :id

      column :name, String, :null=>false
      column :ordering, Integer

      index :name, :unique=>true
    end

    # Tagging for journal entries
    create_table(:topic) do
      primary_key :id

      column :name, String
      column :title, String
      column :description, String, :text=>true, :null=>false
      column :is_country, TrueClass, :default=>false, :null=>false
      column :show, TrueClass, :default=>false, :null=>false

      foreign_key :section_id, :section

      index :name, :unique=>true
    end

    # Shared title prefixes for journal entries
    create_table(:prefix) do
      primary_key :id

      column :name, String, :text=>true, :null=>false

      index :name, :unique=>true
    end

    # Journal entries
    create_table(:journal) do
      primary_key :id

      column :href, String, :unique=>true
      column :title, String
      column :body, String, :text=>true
      column :stamp, DateTime, :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :published, TrueClass, :default=>false, :null=>false
      column :filed, TrueClass, :default=>false, :null=>false
      column :commissioned, TrueClass, :default=>false, :null=>false
      column :locked, TrueClass, :default=>false, :null=>false
      column :date_publish, Date
      column :js, String, :text=>true
      column :nocomments, TrueClass, :default=>false, :null=>false

      foreign_key :day_id, :day
      foreign_key :author_id, :author, :null=>false
      foreign_key :rating_id, :rating, :null=>false
      foreign_key :photo_id, :photo, :null=>false, :default => 1
      foreign_key :prefix_id, :prefix, :null=>false

      index [:published, :date_publish, :stamp]
      index [:published, :date_publish, "date(stamp)".lit]
      index [:published, :date_publish, "date_trunc('month',stamp)".lit]
      index [:published, :date_publish, "date_trunc('year',stamp)".lit]
      index [:published, :date_publish, "(date_part('month',stamp)::text||date_part('day',stamp))".lit]
      index [:published, :date_publish, :rating_id]
    end

    # Journal entry comments
    create_table(:journal_comment) do
      primary_key :id

      column :name, String, :null=>false
      column :email, String
      column :body, String, :text=>true, :null=>false
      column :stamp, DateTime, :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :url, String
      column :ip, :cidr
      column :published, TrueClass, :default=>true, :null=>false
      column :authorpost, TrueClass, :default=>false, :null=>false
      column :alerts, TrueClass, :default=>false, :null=>false
      column :captcha, String

      foreign_key :journal_id, :journal, :null=>false

      index [:journal_id, :published]
    end

    # Assign topics to journals
    create_table(:journals_topics) do
      foreign_key :journal_id, :journal, :null=>false
      foreign_key :topic_id, :topic, :null=>false

      index [:topic_id]
      index [:journal_id, :topic_id], :unique=>true
    end

    # Assign widgets to journals
    create_table(:journals_widgets) do
      foreign_key :journal_id, :journal, :null=>false
      foreign_key :widget_id, :widget, :null=>false

      index :widget_id
      index [:journal_id, :widget_id], :unique=>true
    end

    # Assign locations for journal entries
    create_table(:journals_locations) do
      foreign_key :location_id, :location, :null=>false
      foreign_key :journal_id, :journal, :null=>false

      index [:location_id, :journal_id], :unique=>true
    end

  end

  down do
    drop_table(:journals_locations)
    drop_table(:journals_widgets)
    drop_table(:journals_topics)
    drop_table(:journal_comment)
    drop_table(:journal)
    drop_table(:prefix)
    drop_table(:topic)
    drop_table(:section)
    drop_table(:rating)
    drop_table(:widget)
    drop_table(:author)
  end

end
