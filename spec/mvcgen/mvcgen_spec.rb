require 'spec_helper'

describe MVCgen do
	context "when generating path" do
		it "should return nil if no valid template" do
			valid_template = MVCgen::FileManager.is_template_valid("asdgas")
			expect(valid_template).to be(false)
		end
		it "should return nil if no valid language" do
			valid_template = MVCgen::FileManager.is_template_valid("asdgas")
			expect(valid_template).to be(false)
		end
		it "should return nil if no valid language when getting path" do
			path = MVCgen::FileManager.path_from("default", "asgass")
			expect(path).to be(nil)
		end
		it "should return nil if no valid template when getting path" do
			path = MVCgen::FileManager.path_from("asga", "swift")
			expect(path).to be(nil)
		end
		it "should append the name to the given user path" do
			to_path = MVCgen::FileManager.destination_mvc_path("path/", "pepito")
			expect(to_path).to eq(File.join(File.expand_path("path/"),"pepito"))
		end
	end
	context "copying a folder to a diferent place" do
		before (:each) do
			Dir.mkdir 'foo'
			Dir.mkdir 'foo/subfoo'
		end

		it "should copy a given folder properly" do
			MVCgen::FileManager.copy('foo','test_foo')
			expect(File.directory?('test_foo/subfoo')).to eq(true)
		end

		after (:each) do
			FileUtils.rm_rf('foo')
			FileUtils.rm_rf('test_foo')
		end
	end
end

describe MVCgen::Generator do
	context "when renaming file content" do 
		before (:each) do
			File.open("test.txt", 'w') {|f| f.write("I'm a #{MVCgen::Generator::REPLACEMENT_KEY} file") }
		end

		it "should rename every MVC word to the given name" do
			MVCgen::Generator.rename_file_content("test.txt","RENAMED")
			file = File.open("test.txt", "rb")
			content = file.read
			expect(content).to eq("I'm a RENAMED file")
		end

		after (:each) do
			FileUtils.rm('test.txt')
		end
	end

	context "when renaming file" do
		before (:each) do
			File.open("#{MVCgen::Generator::REPLACEMENT_KEY}test.txt", 'w') {|f| f.write("I'm a #{MVCgen::Generator::REPLACEMENT_KEY} file") }
		end

		it "every file should be renamed in rename_files" do
			expect(MVCgen::Generator).to receive(:rename_file)
			MVCgen::Generator.rename_files(["#{MVCgen::Generator::REPLACEMENT_KEY}file.txt"], "pepito")
		end

		it "should raise a SyntaxError exeption if there's a file in the template without the proper name" do
			expect{MVCgen::Generator.rename_files(["asgasgs.txt"], "pepito")}.to raise_error
		end

		it "should rename the MVC in name to the given name" do
			file = "#{MVCgen::Generator::REPLACEMENT_KEY}test.txt"
			name = "RENAMED"
			MVCgen::Generator.rename_file(file, name)
			expect(File.exist? "RENAMEDtest.txt").to eq(true)
		end

		it "should rename the file content after the file name rename" do
			file = "#{MVCgen::Generator::REPLACEMENT_KEY}test.txt"
			name = "RENAMED"
			expect(MVCgen::Generator).to receive(:rename_file_content)
			MVCgen::Generator.rename_file(file, name)
		end

		after (:each) do
			File.delete "#{MVCgen::Generator::REPLACEMENT_KEY}test.txt" if File.exist? "#{MVCgen::Generator::REPLACEMENT_KEY}test.txt"
			File.delete "RENAMEDtest.txt" if File.exist? "RENAMEDtest.txt"
		end
	end
end

describe MVCgen::DirUtils do
	context "getting directories" do
		before (:each) do
			Dir.mkdir 'foo'
			Dir.mkdir 'foo/subfoo'
		end

		it "should return the directories inside a given one" do
			expect(MVCgen::DirUtils.directories_in('foo').count).to eq(1)
		end

		after (:each) do
			FileUtils.rm_rf('foo')
		end
	end
end

describe VipeMVCgenrgen::TemplateManager do
	context "getting templates" do
		before (:each) do
			Dir.mkdir 'foo'
			Dir.mkdir 'foo/subfoo'
			Dir.mkdir 'foo/subfoo2'
		end

		it "should return the proper templates in templates directory" do
			MVCgen::TemplateManager.stub(:templates_dir).and_return('foo/')
			expect(MVCgen::TemplateManager.templates_paths.count).to eq(2)
		end

		after (:each) do
			FileUtils.rm_rf('foo')
		end
	end
end
