#!/usr/bin/env ruby
#
# 

require 'tempfile'
require 'nautilus_scripts'

ME=File.basename($0, ".rb")
TMP=File.join("/var/tmp", ME)
FileUtils.mkdir_p(TMP)

tmp=Tempfile.open(ME)

#NAUTILUS_SCRIPT_SELECTED_URIS
#current=ENV["NAUTILUS_SCRIPT_SELECTED_URIS"]||ARGV[0]
#exit 1 if current.nil?

puts "Writing to #{tmp.path}"
tmp.write %x/set | grep NAUTILUS/

files=Nautilus::Scripts.new(ENV["NAUTILUS_SCRIPT_SELECTED_URIS"]||ARGV[0])

files.each { |current|
	tmp.puts "Current is #{current}"

	while File.symlink?(current)
		target = File.readlink(current)
		tmp.puts "File #{current} points to #{target}"
		current = target
	end
	
	if File.exist?(current)
		type=File.ftype(current)
		msg="Found target #{type} #{current}"
	else
		msg="Target not found #{current}"
	end
	tmp.puts msg
}

tmp.flush
persist=File.join(TMP, File.basename(tmp.path))
FileUtils.mv(tmp.path, persist)
tmp.close

#puts File.read(persist)
geo=Nautilus::Scripts.window_geometry
w=geo[:w].nil? ? "" : " --width=#{geo[:w]} "
h=geo[:h].nil? ? "" : " --height=#{geo[:h]} "

%x/zenity --text-info --filename=#{persist} #{w} #{h}/
