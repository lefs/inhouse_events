module GeneratorSpecHelpers
  def provide_routes_file
    create_file_from_template('templates/routes.rb', 'config')
  end

  def provide_application_js_file
    create_file_from_template('templates/application.js',
                              'app/assets/javascripts')
  end

  private

  def create_file_from_template(tmpl_path, dest_path)
    tmpl = File.expand_path(tmpl_path, File.dirname(__FILE__))
    dest = File.join(destination_root, dest_path)
    FileUtils.mkdir_p(dest)
    FileUtils.cp tmpl, dest
  end
end
