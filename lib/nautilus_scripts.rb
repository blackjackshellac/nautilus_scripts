
module Nautilus
	GEOMETRY_RE=/(?<w>\d+)x(?<h>\d+)\+(?<x>\d+)\+(?<y>\d+)/
	GEOMETRY_KEYS=[:x, :y, :w, :h]

	# Document the responsibility of the class
  #
  # == Nautilus::Scripts class
  #
  # Helpers for handling NAUTILUS_SCRIPT environment variables in ruby scripts placed in
  # ~/.local/share/nautilus/scripts
	#
  # == Formatting
  #
  # Embody +parameters+ or +options+ in Teletype Text tags. You can also use
  # *bold* or *italics* but must use HTML tags for <b>multiple words</b>,
	# <i>like this</i> and <tt>like this</tt>.
	class Scripts
		include Enumerable

		##
		# Constructor for Scripts class
		#
		# === Arguments
		#
		# * +items+ - optionally set paths to be manipulated, only if NAUTILUS_SCRIPT
		# environment variables are not set
		#
		def initialize(items=nil)
			@items = []
			Scripts.selected_uris(items).each { |item|
				@items << defile(item)
			}
		end

		##
		# Convert file URI to filesystem path
		#
		# === Arguments
		#
		# * +item+ - file URI to convert to a filesystem path
		#
		def self.defile(item)
			item.sub(/^file:\/\//, "").gsub(/%20/, " ")
		end

		# Convert filesystem path to file URI
		def self.refile(item)
			item.sub(/^/, "file://").gsub(/\s/, "%20")
		end

		##
		# Returns the URI for the current directory from where the script was run.
		#
		# === Arguments
		#
		# * +default+ - value to use if Environment variable is not set
		#
		# === Environment Variable
		#
		# NAUTILUS_SCRIPT_CURRENT_URI=file:///home/tmp/bjs/nexus_5/links/20161202/Internal%20shared%20storage/DCIM/Camera
		#
		def self.current_uri(default="")
			ENV['NAUTILUS_SCRIPT_CURRENT_URI']||default
		end

		##
		# Returns the list of selected files as filesystem paths
		#
		# === Arguments
		#
		# * +default+ - value to use if Environment variable is not set
		#
		# === Environment Variable
		#
		# NAUTILUS_SCRIPT_SELECTED_FILE_PATHS='/home/tmp/bjs/nexus_5/links/20161202/Internal shared storage/DCIM/Camera/IMG_20131122_111539.jpg
		#
		def self.selected_file_paths(default="")
			(ENV['NAUTILUS_SCRIPT_SELECTED_FILE_PATHS']||default).split(/\n/)
		end

		##
		#
		# Returns the list of selected files as URIs
		#
		# === Arguments
		#
		# * +default+ - value to use if Environment variable is not set
		#
		# === Environment Variable
		#
		# NAUTILUS_SCRIPT_SELECTED_URIS='file:///home/tmp/bjs/nexus_5/links/20161202/Internal%20shared%20storage/DCIM/Camera/IMG_20131122_111539.jpg
		#
		def self.selected_uris(default="")
			(ENV['NAUTILUS_SCRIPT_SELECTED_URIS']||default).split(/\n/)
		end

		##
		# Returns the window geometry extracted from the environment variable as a hash
		#
		# === Arguments
		#
		# * +default+ - value to use if Environment variable is not set
		#
		# === Environment Variable
		#
		# NAUTILUS_SCRIPT_WINDOW_GEOMETRY=1540x808+26+23
		def self.window_geometry(default="")
			geo=ENV['NAUTILUS_SCRIPT_WINDOW_GEOMETRY']||default
			m=geo.match(GEOMETRY_RE)
			h={}
			[:x, :y, :w, :h].map { |k| h[k]=m.nil? ? nil : m[k] }
			return h
		end

		##
		# Iterator
		#
		# === Arguments
		#
		# * +block+ - block from caller
		#
		# === Example
		#
		# s = Nautilus::Scripts.new
		# s.each { |path|
		#    puts path
		# }
		#
		# === Yields
		#
		# * +item+ - each selected filesystem path
		#
		def each(&block)
			@items.each { |item|
				block.call(item)
			}
		end
	end
end
