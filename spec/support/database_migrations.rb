module PublishingLogic
  module Migrations
    class AddProgrammes < ActiveRecord::Migration
      def self.up
        create_table :programmes do |t|
          t.boolean :publishing_enabled
          t.datetime :published_at
          t.datetime :published_until
          t.timestamps
        end

        add_index :programmes, [:published_at, :publishing_enabled, :published_until], :name => 'index_programmes_on_publishing_logic_fields'
      end

      def self.down
        remove_index :programmes, :name => 'index_programmes_on_publishing_logic_fields'
      end
    end

    class AddArticles < ActiveRecord::Migration
      def self.up
        create_table :articles do |t|
          t.boolean :publishing_enabled
          t.datetime :published_at
          t.timestamps
        end

        add_index :programmes, [:published_at, :publishing_enabled], :name => 'index_articles_on_publishing_logic_fields'
      end

      def self.down
        remove_index :articles, :name => 'index_articles_on_publishing_logic_fields'
      end
    end
  end
end

if ActiveRecord::Migrator.current_version != 2
  migrator = ActiveRecord::Migrator.new(:up, '', 2)
  migrator.instance_eval {
    migration_1 = ActiveRecord::MigrationProxy.new
    migration_1.instance_eval {
      @name = 'add_programmes'
      @version = 1
      @migration = PublishingLogic::Migrations::AddProgrammes
    }
    migration_2 = ActiveRecord::MigrationProxy.new
    migration_2.instance_eval {
      @name = 'add_articles'
      @version = 2
      @migration = PublishingLogic::Migrations::AddArticles
    }
    @migrations = [ migration_1, migration_2 ]
  }
  migrator.migrate
end
