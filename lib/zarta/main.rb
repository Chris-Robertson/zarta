require 'tty'
require 'terminal-table'
require 'pastel'

# The catch-all module for ZARTA
module Zarta
  # Runs the game
  class Engine
    def initialize
      @dungeon = Zarta::Dungeon.new
    end

    # Main game loop
    def play
      loop do
        Zarta::Screen.new(@dungeon)
      end
    end
  end

  # Writes the current game screen
  class Screen
    def initialize(dungeon)
      @dungeon  = dungeon
      @player   = @dungeon.player
      @prompt   = TTY::Prompt.new

      refresh
    end

    # Refreshes the game screen
    def refresh
      Zarta::HUD.new(@dungeon)

      @player.handle_enemy if @dungeon.room.enemy.is_a?(Zarta::Enemy)

      @player.handle_weapon if @dungeon.room.weapon.is_a?(Zarta::Weapon)

      if @dungeon.room.stairs
        puts 'You see stairs leading down here.'
        @dungeon.level += 1 if @prompt.yes?('Go down?')
        @dungeon.room = Zarta::Room.new(@dungeon)
        refresh
      end

      @dungeon.room = next_rooms_prompt
      refresh
    end

    # Makes the room spawn a list of possible rooms connecting here, then
    # prompts the user to chose one.
    def next_rooms_prompt
      next_rooms_options = []
      @dungeon.room.new_rooms(@dungeon)
      @dungeon.room.next_rooms.each do |room|
        next_rooms_options << room.description
      end

      next_room_choice = @prompt.select(
        'You see these rooms ahead of you. Choose one:', next_rooms_options
      )

      @dungeon.room.next_rooms.each do |room|
        return room if next_room_choice == room.description
      end
    end
  end

  # Displays relevant information at the top of the game screen
  class HUD
    def initialize(dungeon)
      @dungeon  = dungeon
      @player   = @dungeon.player
      @pastel   = Pastel.new

      hud_table
    end

    def hud_table
      table = Terminal::Table.new
      table.title = @pastel.bright_red(@dungeon.name)
      table.style = { width: 80, padding_left: 3, border_x: '=' }
      table.rows = build_table_rows
      system 'clear'
      puts table
      puts room_description
    end

    def room_description
      word_start = beginning(@dungeon.room.description)
      puts "You are in #{word_start} #{@dungeon.room.description} room."
    end

    # Checks if a word is an 'an' word or an 'a' word.
    # http://stackoverflow.com/a/18463759/1576860
    def beginning(word)
      %w(a e i o u).include?(word[0]) ? 'an' : 'a'
    end

    def build_table_rows
      t = []
      t << [@player.name, 'LVL: 1']
      t << [display_health, "EXP: #{@player.xp}"]
      t << [
        "Weapon: #{@player.weapon.name} (#{@player.weapon.damage})",
        "Dungeon Level:  #{@dungeon.level}/#{@dungeon.max_level}"
      ]
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
