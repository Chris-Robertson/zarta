# frozen_string_literal: true

# coding utf-8
# lib = File.extend_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name           = 'zarta'
  spec.version        = '0.0.2'
  spec.date           = '2017-03-05'
  spec.authors        = ['Chris Robertson']
  spec.email          = ['chrisxrobertson@gmail.com']
  spec.summary        = 'Zarta’s A Ruby Text Adventure'
  spec.description    = 'In the spirit of roguelikes (except completely text
                        based), explore through various levels of the Zarta
                        dungeon, fighting monsters and levelling up, until you
                        find and kill the boss on the deepest level.'
  spec.homepage       = 'https://github.com/Chris-Robertson/zarta'
  spec.license        = 'MIT'
  spec.files          = %w[lib/zarta.rb lib/zarta/main.rb lib/zarta/dungeon.rb lib/zarta/enemy.rb lib/zarta/enemy.yml
                           lib/zarta/player.rb lib/zarta/rooms.yml lib/zarta/weapon.rb lib/zarta/weapons.yml]
  spec.executables    = ['zarta']
  spec.test_files     = ['tests/test_zarta.rb']
  spec.require_paths  = ['lib']
  spec.required_ruby_version = '>= 3.2.0'

  spec.add_runtime_dependency 'artii', '~> 2.1.2'
  spec.add_runtime_dependency 'pastel', '~> 0.8.0'
  spec.add_runtime_dependency 'terminal-table', '~> 3.0.2'
  spec.add_runtime_dependency 'tty', '~> 0.10'
  spec.add_runtime_dependency 'tty-prompt', '~> 0.23.1'
end
