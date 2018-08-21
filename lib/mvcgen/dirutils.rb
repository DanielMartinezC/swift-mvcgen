require 'fileutils'

module MVCgen
	class DirUtils
		# Return a directory with the project libraries.
	    def self.gem_libdir
	      t = ["#{File.dirname(File.expand_path($0))}/../lib/#{MVCgen::NAME}",
	           "#{Gem.dir}/gems/#{MVCgen::NAME}-#{MVCgen::VERSION}/lib/#{MVCgen::NAME}"]
	      t.each {|i| return i if File.readable?(i) }
	      raise "both paths are invalid: #{t}"
	    end

	    # Returns the directories inside a given one
	    def self.directories_in(directory)
	    	expanded_dir = File.expand_path(directory)
	    	return Dir.glob(File.join(expanded_dir,'*')).select {|f| File.directory? f}
	    end
	end
end