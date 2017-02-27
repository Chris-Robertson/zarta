require 'tty'
require 'terminal-table'
require 'pastel'

# The catch-all module for ZARTA
module Zarta
  # Runs the game
  class Engine
    def initialize
      @dungeon = Zarta::Dungeon.new
      @player = Zarta::Player.new
    end

    def play
      test_hud = Zarta::HUD.new(@dungeon, @player)
      test_hud.create_hud_table

      test_room = Zarta::Room.new(@dungeon)
      puts "You are in a #{test_room.description} room."
      gets
    end
  end

  class Screen; end

  # Displays relevant information at the top of the game screen
  class HUD
    def initialize(dungeon, player)
      @dungeon = dungeon
      @player = player

      @pastel = Pastel.new
    end

    attr_accessor :dungeon, :player

    def create_hud_table
      hud_table = Terminal::Table.new
      hud_table.title = @pastel.bright_red(@dungeon.name)
      hud_table.style = { width: 80, padding_left: 3, border_x: '=' }
      hud_table.add_row [@player.name, 'LVL: 1']
      hud_table.add_row [display_health, "EXP: #{@player.xp}"]

      system 'clear'
      puts hud_table
    end

    def display_health
      current_health = @player.health[0]
      max_health = @player.health[1]
      hud_health = "HP: #{@player.health[0]}/#{@player.health[1]}"

      return @pastel.red(hud_health) if current_health < max_health / 2
      @pastel.green(hud_health)
    end
  end
end
