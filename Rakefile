require "rubygems"
require "rake"
require "rake/rdoctask"
require "rspec"
require "rspec/core/rake_task"

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "vidibus-user"
    gem.summary = %Q{Single sign-on for Vidibus applications.}
    gem.description = %Q{Provides single sign-on and a local user model.}
    gem.email = "andre@vidibus.com"
    gem.homepage = "http://github.com/vidibus/vidibus-user"
    gem.authors = ["Andre Pankratz"]
    gem.add_dependency "rails", "~> 3.0.0"
    gem.add_dependency "mongoid", "~> 2.0.0.beta.20"
    gem.add_dependency "warden"
    gem.add_dependency "oauth2"
    gem.add_dependency "vidibus-secure"
    gem.add_dependency "vidibus-uuid"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Rspec::Core::RakeTask.new(:rcov) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rcov = true
  t.rcov_opts = ["--exclude", "^spec,/gems/"]
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?("VERSION") ? File.read("VERSION") : ""
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "vidibus-user #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
  rdoc.options << "--charset=utf-8"
end
