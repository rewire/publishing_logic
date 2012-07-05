ActiveRecord::Migration.instance_eval do
  create_table :programmes do |t|
    t.boolean :publishing_enabled
    t.datetime :published_at
    t.datetime :published_until
    t.timestamps
  end

  add_index :programmes, [:published_at, :publishing_enabled, :published_until], :name => 'index_programmes_on_publishing_logic_fields'

  create_table :articles do |t|
    t.boolean :publishing_enabled
    t.datetime :published_at
    t.timestamps
  end

  add_index :programmes, [:published_at, :publishing_enabled], :name => 'index_articles_on_publishing_logic_fields'
end
