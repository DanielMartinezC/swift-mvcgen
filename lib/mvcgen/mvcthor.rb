require 'thor'
require 'mvcgen'

module MVCgen
  class MVCThor < Thor
	desc "generate", "Generate a MVC module"
	option :language, :required => false, :default => 'swift', :type => :string, :desc => "The language of the generated module (swift)"
	option :template, :required => false, :default => 'default', :type => :string , :desc => "Template for the generation"
	option :path, :required => true, :type => :string , :desc => "Path where the output module is going to be saved"
	
	def generate(name)
		MVCgen::Generator.generate_mvc(options[:template], options[:language], name, options[:path])
	end

	desc "templates", "Get a list of available templates"
	def templates()
		puts MVCgen::TemplateManager.templates_description()
	end
  end
end