# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vidibus-user}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andre Pankratz"]
  s.date = %q{2011-05-09}
  s.description = %q{Provides single sign-on and a local user model.}
  s.email = %q{andre@vidibus.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/models/user.rb",
    "config/routes.rb",
    "lib/vidibus-user.rb",
    "lib/vidibus/user.rb",
    "lib/vidibus/user/callback_app.rb",
    "lib/vidibus/user/extensions.rb",
    "lib/vidibus/user/extensions/controller.rb",
    "lib/vidibus/user/mongoid.rb",
    "lib/vidibus/user/warden_strategy.rb",
    "spec/spec_helper.rb",
    "vidibus-user.gemspec"
  ]
  s.homepage = %q{http://github.com/vidibus/vidibus-user}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Single sign-on for Vidibus applications.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_runtime_dependency(%q<mongoid>, ["~> 2.0"])
      s.add_runtime_dependency(%q<warden>, [">= 0"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<vidibus-uuid>, [">= 0"])
      s.add_runtime_dependency(%q<vidibus-secure>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<relevance-rcov>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<mongoid>, ["~> 2.0"])
      s.add_dependency(%q<warden>, [">= 0"])
      s.add_dependency(%q<oauth2>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<vidibus-uuid>, [">= 0"])
      s.add_dependency(%q<vidibus-secure>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<relevance-rcov>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<mongoid>, ["~> 2.0"])
    s.add_dependency(%q<warden>, [">= 0"])
    s.add_dependency(%q<oauth2>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<vidibus-uuid>, [">= 0"])
    s.add_dependency(%q<vidibus-secure>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<relevance-rcov>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end

