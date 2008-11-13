Gem::Specification.new do |s|
  s.name = %q{ruby-hackvm}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["BadBoy_"]
  s.date = %q{2008-11-13}
  s.default_executable = %q{hackvm.rb}
  s.description = %q{a virtual machine for hackers.}
  s.email = %q{}
  s.executables = ["hackvm.rb"]
  s.extra_rdoc_files = ["bin/hackvm.rb", "README.textile"]
  s.files = ["samples/helloworld.hvm", "Rakefile", "ruby-hackvm.gemspec", "bin/hackvm.rb", "Manifest", "README.textile"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/BadBoy/ruby-hackvm}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby-hackvm", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-hackvm}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{a virtual machine for hackers.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
