require 'liquid'
require 'yaml'

class Page

	Liquid::Template.file_system = Liquid::LocalFileSystem.new('./templates/_includes') 
 
	attr_reader :layout_file, :config, :content, :page

	def initialize(args)

		file = File.read( args[:in] || './templates/sample.html' ).split('---')
		
		@config = YAML.load file[1]
		@content   = file[2]

		@layout_file = config['layout'] || './templates/_layouts/default.liquid'
	end

	def parse_templates
		@template = Liquid::Template.parse File.read(layout_file) 
	end

	def parse_page
		@page = Liquid::Template.parse( content )
	end

	def render
		@template.render( {'content' => page.render}.merge config)
	end

	def publish(args = {})
		config.merge! args
		File.open(config['destination'],'wb') do |f|
			f.write self.render
		end
	end
end