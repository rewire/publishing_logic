class PublishingLogicFieldsGenerator < Rails::Generator::NamedBase
  def initialize(args, options)
    super(args, options)
  end

  def manifest
    record do |m|
      class_name.camelize.constantize # Raise an error if model does not yet exist
      m.migration_template 'db/migrate/add_publishing_logic_fields.rb.erb', 'db/migrate', :assigns => {
        :migration_name => "AddPublishingLogicFieldsTo#{class_name.pluralize.gsub(/::/, '')}"
      }, :migration_file_name => "add_publishing_logic_fields_to_#{file_path.gsub(/\//, '_').pluralize}"
    end
  end
end
