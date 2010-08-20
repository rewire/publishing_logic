class PublishingLogicFieldsGenerator < Rails::Generator::NamedBase
  default_options :use_published_until_field => true, :skip_admin_form => false

  def initialize(args, options)
    super(args, options)
  end

  def manifest
    record do |m|
      class_name.camelize.constantize # Raise an error if model does not yet exist
      m.migration_template 'db/migrate/add_publishing_logic_fields.rb.erb', 'db/migrate', :assigns => {
        :migration_name => "AddPublishingLogicFieldsTo#{class_name.pluralize.gsub(/::/, '')}",
        :use_published_until_field => options[:use_published_until_field]
      }, :migration_file_name => "add_publishing_logic_fields_to_#{file_path.gsub(/\//, '_').pluralize}"
      unless options[:skip_admin_form]
        m.template 'app/views/publishing_logic_fields.html.erb',
                   File.join('app', 'views', 'admin', plural_name, "_publishing_logic_fields.html.erb"),
                   :assigns => {
                     :use_published_until_field => options[:use_published_until_field]
                   }
      end
    end
  end

  protected
    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--no-published-until",
             "Don't add the published_until field to this model") { |v| options[:use_published_until_field] = false }
      opt.on("--skip-admin-form",
             "Don't generate the admin form partial for this model") { |v| options[:skip_admin_form] = true }
    end
end
