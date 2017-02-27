require 'tty'
require 'terminal-table'
require 'pastel'

# The catch-all module for ZARTA
module Zarta
  # Runs the game
  class Engine
    def initialize
      @dungeon  = Zarta::Dungeon.new
      @player   = Zarta::Player.new
    end

    # Main game loop
    def play
      loop do
        system 'clear'
        Zarta::Screen.new(@dungeon, @player)
      end
    end
  end

  # Writes the current game screen
  class Screen
    def initialize(dungeon, player)
      @dungeon = dungeon
      @player = player

      refresh
    end

    def refresh
      Zarta::HUD.new(@dungeon, @player)

      word_start = word_article_type(@dungeon.current_room.description)
      puts "You are in #{word_start} #{@dungeon.current_room.description} room."

      if @dungeon.current_room.enemy
        puts Zarta::Enemy.new.name
      end

      @dungeon.current_room = next_rooms_prompt
    end

    def next_rooms_prompt
      prompt = TTY::Prompt.new
      @dungeon.new_rooms(@dungeon)
      next_rooms = @dungeon.next_rooms
      next_rooms_options = []
      next_rooms.each do |room|
        next_rooms_options << room.description
      end

      next_room_choice = prompt.select(
        'You see these rooms ahead of you. Choose one:', next_rooms_options
      )

      next_rooms.each do |room|
        return room if next_room_choice == room.description
      end
    end

    # Checks if a word is an 'an' word or an 'a' word.
    # http://stackoverflow.com/a/18463759/1576860
    def word_article_type(word)
      %w(a e i o u).include?(word[0]) ? 'an' : 'a'
    end
  end

  # Displays relevant information at the top of the game screen
  class HUD
    def initialize(dungeon, player)
      @dungeon  = dungeon
      @player   = player

      @pastel = Pastel.new

      create_hud_table
    end

    attr_accessor :dungeon, :player

    def create_hud_table
      hud_table = Terminal::Table.new
      hud_table.title = @pastel.bright_red(@dungeon.name)
      hud_table.style = { width: 80, padding_left: 3, border_x: '=' }
      hud_table.add_row [@player.name, 'LVL: 1']
      hud_table.add_row [display_health, "EXP: #{@player.xp}"]

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
