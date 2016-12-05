require 'rake'

files=Rake::FileList["*.gem"]

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
