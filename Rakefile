require 'rake'

files=Rake::FileList["*.gem"]

desc "Build gem"
task :build do
	system("gem build nautilus_scripts.gemspec")
end

desc "Setup bundle"
task :bundle_install do
	system("bundle install --path .bundle")
end

desc "Run tests"
task :test do
	system("bundle exec rspec")
end
