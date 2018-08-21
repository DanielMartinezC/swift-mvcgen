require 'fileutils'
require 'xcodeproj'

module MVCgen
	# Cosntants
	class Generator
		# Constants
		LANGUAGES = ["swift", "podfile"]
		REPLACEMENT_KEY = "MVCGEN"

		def self.add_to_xcode(path, name, filespath)
			puts "Adding files to xcode project..."
			# proj = Xcodeproj::Project.new("#{path}/#{name}.xcodeproj")
			# app_target_dev = proj.new_target(:application, "#{name} - Development", :ios, '10.0')
			# header_ref = proj.main_group.new_file('./Class.swift')

			project_file = "#{path}/#{name}.xcodeproj"
			proj = Xcodeproj::Project.open(project_file)

			# TODO: view this to improve path files: allowable_project_paths
			self.addxcodefiles(filespath,proj.main_group,proj.targets.first)
			
			proj.save
			puts "Finish adding files"
		end

		def self.addxcodefiles(direc, current_group, main_target)
			Dir.glob(direc) do |item|
				next if item == '.' or item == '.DS_Store'
					if File.directory?(item)
					new_folder = File.basename(item)
					created_group = current_group.new_group(new_folder)
					self.addxcodefiles("#{item}/*", created_group, main_target)
				elsif item == "Assets.xcassets"
					main_target.add_frameworks_bundles([item])
					break
				else 
				  i = current_group.new_file(item)
				  main_target.add_file_references([i])
				end
			end
		end

		# Main method that generate the MVC files structure
		def self.generate_mvc(template, language, name, path)

			puts "Generating MVC-Module"
			puts "Template: #{template}"
			puts "Language: #{language}"
			puts "Name: #{name}"
			puts "Path: #{path}"

			# Copy language files to project folder
			path_from = MVCgen::FileManager.path_from(template, language)
			path_to = MVCgen::FileManager.destination_mvc_path(path, name)
			MVCgen::FileManager.copy(path_from, path_to)

			# Copy podfile to project folder
			podfile_path = MVCgen::FileManager.path_from(template, "podfile")
			expand_path = File.expand_path(path)
			MVCgen::FileManager.copy(podfile_path, expand_path)

			# TODO: later if needed
			files = MVCgen::FileManager.files_in_path(expand_path)
			rename_files(files,name)
			self.add_to_xcode(path, name, path_to)
		end

		# Rename all the files in the files array
		# - It renames the name of the file 
		# - It renames the content of the file
		def self.rename_files(files, name)
			files.each do |file|
				rename_file_content(file, name)
				# if file.include? (MVCgen::Generator::REPLACEMENT_KEY)
				# 	rename_file(file, name)
				# end
			end
		end

		# Rename a given file
		# - It renames the name of the file
		# - It renames the content of the file
		def self.rename_file(file, name)
			new_path = file.gsub((MVCgen::Generator::REPLACEMENT_KEY), name)
			MVCgen::FileManager.move(file, new_path)
			rename_file_content(new_path, name)
		end

		# Rename the file content
		# @return: An String with the every MVC replaced by 'name'
		def self.rename_file_content(filename, name)
			# Reading content
			file = File.open(filename, "rb")
			content = file.read
			file.close

			# Replacing content
			content = content.gsub((MVCgen::Generator::REPLACEMENT_KEY), name)

			# Saving content with replaced string
			File.open(filename, "w+") do |file|
   				file.write(content)
			end
		end
	end
end