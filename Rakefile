require 'rake'

files=Rake::FileList["*.gem"]

def bump_version(gemspec)
	# s.version     = '0.0.4'
	# s.date        = '2016-12-05'
	out=[]
	File.read(gemspec).split(/\n/).each { |line|
		re=/^(?<ws>\s+)(?<key>s[.](version|date))(?<eql>\s*=\s*)'(?<val>[-\.\d]+)'\s*$/
		m = line.match(re)
		unless m.nil?
			case m["key"]
			when "s.version"
				puts "bump %s%s%s'%s'" % [ m[:ws], m[:key], m[:eql], m[:val] ]
				ver = m["val"]
				n = ver.match(/(?<maj>\d+)\.(?<min>\d+)\.(?<foo>\d+)/)
				if n.nil?
					raise "Error parsing version string: #{ver}"
				else
					ver = "%s.%s.%s" % [ n[:maj], n[:min], n[:foo].to_i+1 ]
					line="%s%s%s'%s'" % [ m[:ws], m[:key], m[:eql], ver]
				end
				puts line
			when "s.date"
				puts "bump %s%s%s'%s'" % [ m[:ws], m[:key], m[:eql], m[:val] ]
				date = Time.new.strftime("%Y-%m-%d")
				line="%s%s%s'%s'" % [ m[:ws], m[:key], m[:eql], date]
				puts line
			end
		end
		out << line
	}
	puts "Writing updated gemspec: #{gemspec}"
	File.open(gemspec, "w") { |fd|
		out.each { |line|
			fd.puts line
		}
	}
end

desc "Bump version and timestamp in gemspec"
task :bump_version do
	ts=Time.now.strftime("%Y-%m-%d")
	gemspec="nautilus_scripts.gemspec"
	bump_version(gemspec)
end

desc "Build gem"
task :build_gem do
	system("gem build nautilus_scripts.gemspec")
end

desc "Push gem"
task :push, [:file] do |t, args|
	if args[:file].nil?
		puts "Error: specify gem to push: #{args}"
	else
		system("gem push #{args[:file]}")
	end
end

desc "Setup bundle"
task :bundle_install do
	system("bundle install --path .bundle")
end

desc "Run tests"
task :test do
	system("bundle exec rspec")
end

desc "it does a thing"
task :work, [:option, :foo, :bar] do |t, args|
	puts "work", args
end
