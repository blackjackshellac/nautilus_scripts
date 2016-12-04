
module Nautilus
	GEOMETRY_RE=/(?<w>\d+)x(?<h>\d+)\+(?<x>\d+)\+(?<y>\d+)/
	GEOMETRY_KEYS=[:x, :y, :w, :h]

	class Scripts
		include Enumerable

		def initialize(items=nil)
			@items = []
			Scripts.selected_uris(items).each { |item|
				@items << defile(item)
			}
		end

		# Convert file URI to filesystem path
		def defile(item)
			item.sub(/^file:\/\//, "").gsub(/%20/, " ")
		end

		# Convert filesystem path to file URI
		def refile(item)
			item.sub(/^/, "file://").gsub(/\s/, "%20")
		end

		#NAUTILUS_SCRIPT_CURRENT_URI=file:///home/tmp/bjs/nexus_5/links/20161202/Internal%20shared%20storage/DCIM/Camera
		def self.current_uri(default="")
			ENV['NAUTILUS_SCRIPT_CURRENT_URI']||default
		end

		#NAUTILUS_SCRIPT_SELECTED_FILE_PATHS='/home/tmp/bjs/nexus_5/links/20161202/Internal shared storage/DCIM/Camera/IMG_20131122_111539.jpg
		def self.selected_file_paths(default="")
			(ENV['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS']||default).split(/\n/)
		end

		#NAUTILUS_SCRIPT_SELECTED_URIS='file:///home/tmp/bjs/nexus_5/links/20161202/Internal%20shared%20storage/DCIM/Camera/IMG_20131122_111539.jpg
		def self.selected_uris(default="")
			(ENV['NAUTILUS_SCRIPT_SELECTED_URIS']||default).split(/\n/)
		end

		#NAUTILUS_SCRIPT_WINDOW_GEOMETRY=1540x808+26+23
		def self.window_geometry(default="")
			geo=ENV['NAUTILUS_SCRIPT_WINDOW_GEOMETRY']||default
			m=geo.match(GEOMETRY_RE)
			h={}
			[:x, :y, :w, :h].map { |k| h[k]=m.nil? ? nil : m[k] }
			return h
		end

		def each(&block)
			@items.each { |item|
				block.call(item)
			}
		end
	end
end
