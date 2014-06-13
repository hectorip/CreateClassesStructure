require 'yaml'
require 'fileutils'
require 'colorize'


class StructureClassCreator

	def initialize(fileToLoad)
		struct = YAML.load_file(fileToLoad)
		@classes = struct['classes']
		@directory = struct['directory']
		@directoryMappings = struct['directory_mapping']
	end



	def createClassFile()

		path = @classToCreate.split('_');
		filename = path.pop
		path.map!{ |dir| dir = self.getDirectoryMapping(dir)}
		path = @directory + '/' + path.join('/')

		FileUtils::mkpath path
		name = path + '/' + filename + '.php'
		classFile = File.open(name, 'a+')
		

		fileContents = @contents.sub '#className', @classToCreate
		fileContents = fileContents.sub '#parentClass', @parentClass

		if File.zero?(name)
			classFile.puts(fileContents)
			puts "\n\t" + name + ' created and saved'.green
		else
			puts "\n\t" + name + ' already exists'.blue
		end

	end

	
	def createClasses()

		@classes.each  do |parentClass,parentValues|
			@parentClass = parentClass

			templateFile = File.open(parentValues['template'],'rb')
			@contents =templateFile.read
			
			puts @parentClass

			parentValues['childClasses'].each do |classToCreate|

				@classToCreate = classToCreate
				self.createClassFile

			end
		end

	end

	def getDirectoryMapping(directory)
		if @directoryMappings[directory]

			return @directoryMappings[directory]
			
		end
		return directory
	end

end
