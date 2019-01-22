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
			# self.add_files_togroup(filespath, proj, proj.main_group, proj.targets.first)
			self.addxcodefiles(filespath,proj.main_group,proj.targets.first)
			
			proj.save
			puts "Finish adding files"
		end

		def self.is_resource_group(file)
			extname = file[/\.[^\.]+$/]
			if extname == '.bundle' || extname == '.xcassets' then
				return true
			end
			return false
		end
		
		# def self.add_files_togroup(direc, project, group, target)
		# 	if File.exist?(Dir.glob(direc))
		
		# 		Dir.glob(direc) do |entry|
		# 			filePath = File.join(group.path, entry)
		
		# 			# puts filePath
		
		# 			if filePath.to_s.end_with?(".DS_Store", ".xcconfig") then
		# 				# ignore
		
		# 			elsif filePath.to_s.end_with?(".lproj") then
		# 				if @variant_group.nil?
		# 					@variant_group = group.new_variant_group("Localizable.strings");
		# 				end
		# 				string_file = File.join(filePath, "Localizable.strings")
		# 				fileReference = @variant_group.new_reference(string_file)
		# 				target.add_resources([fileReference])
		
		# 			elsif self.is_resource_group(entry) then
		# 				fileReference = group.new_reference(filePath)
		# 				target.add_resources([fileReference])
		# 			elsif !File.directory?(filePath) then
		
		# 				fileReference = group.new_reference(filePath)
		# 				if filePath.to_s.end_with?(".swift", ".mm", ".m", ".cpp") then
		# 					target.add_file_references([fileReference])		
		# 				elsif filePath.to_s.end_with?(".pch") then
		
		# 				elsif filePath.to_s.end_with?("Info.plist") && entry == "Info.plist" then
		
		# 				elsif filePath.to_s.end_with?(".h") then
		# 					# target.headers_build_phase.add_file_reference(fileReference)
		# 				elsif filePath.to_s.end_with?(".framework") || filePath.to_s.end_with?(".a") then
		# 					target.frameworks_build_phases.add_file_reference(fileReference)
		# 				elsif 
		# 					target.add_resources([fileReference])
		# 				end
		# 			elsif File.directory?(filePath) && entry != '.' && entry != '..' then
		
		# 				subGroup = group.find_subpath(entry, true)
		# 				subGroup.set_source_tree(group.source_tree)
		# 				subGroup.set_path(File.join(group.path, entry))
		# 				add_files_togroup(project, target, subGroup)
		
		# 			end
		# 		end
		# 	end
		# end
		
		def self.addxcodefiles(direc, current_group, main_target)
			Dir.glob(direc) do |item|
				next if item == '.' or item == '.DS_Store'
					if File.directory?(item)
						new_folder = File.basename(item)
						created_group = current_group.new_group(new_folder)
						self.addxcodefiles("#{item}/*", created_group, main_target)
				elsif self.is_resource_group(item) then
					# fileReference = current_group.new_reference(filePath)
					# i = current_group.new_reference(item)
					# main_target.add_resources([fileReference])
					ain_target.add_frameworks_bundles([item])
				# elsif item == "Assets.xcassets"
				# 	main_target.add_frameworks_bundles([item])
				# 	break
				else
					# i = current_group.new_reference(filePath)
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