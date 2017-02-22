# coding utf-8
lib = File.extend_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name           = "zarta"
  spec.version        = '0.0.1'
  spec.date           = '2017-02-23'
  spec.authors        = ["Chris Robertson"]
  spec.email          = ["chrisxrobertson@gmail.com"]
  spec.summary        = "Zarta's A Ruby Text Adventure"
  spec.description    = %q{In the spirit of roguelikes (except completely text based),
                            explore through various levels of the Ruby Dungeon, fighting
                            monsters and levelling up, until you find the mythical Ruby of Zot.}
  spec.homepage       = "https://github.com/Chris-Robertson/zarta"
  spen.license        = "MIT"

  spec.files          = ['lib/zarta.rb', 'lib/zarta/main.rb',]
  spec.executables    = ['bin/zarta.rb']
  spec.test_files     = ['tests/test_zarta.rb']
  spec.require_paths  = ["lib"]
end
