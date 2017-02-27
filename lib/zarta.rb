require_relative 'zarta/main'
require_relative 'zarta/dungeon'
require_relative 'zarta/player'
require_relative 'zarta/weapon'
require_relative 'zarta/enemy'

game = Zarta::Engine.new
game.play
