require 'rails/generators/active_record'

module PublishingLogic
  module Generators
    class FieldsGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_publishing_logic_fields_migration
        migration_template "migration.erb", "db/migrate/add_publishing_logic_fields_to_#{table_name}.rb"
      end
    end
  end
end
