require 'yaml'
require 'fileutils'
struct = YAML.load_file('structureExample.yml')
st = struct['classes']
puts struct.inspect
modulesDirectory = struct['directory']




def createClassFile(classToCreate, directory)
	path = classToCreate.split('_');
	filename = path.pop
	path = directory + '/' + path.join('/')

	FileUtils::mkpath path
	classFile = File.open(path + '/' + filename + '.php', 'w')
	classFile.puts("<?php\n")
end

st.each  do |parentClass,childClasses|
	puts parentClass
	childClasses.each do |classToCreate|
		puts "\t"+classToCreate
		createClassFile classToCreate, modulesDirectory
	end
end
