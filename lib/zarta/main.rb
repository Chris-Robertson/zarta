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
      @prompt = TTY::Prompt.new

      refresh
    end

    # Refreshes the game screen
    def refresh
      Zarta::HUD.new(@dungeon, @player)

      word_start = word_article_type(@dungeon.room.description)
      puts "You are in #{word_start} #{@dungeon.room.description} room."

      if @dungeon.room.enemy.is_a?(Zarta::Enemy)
        puts "There is a #{@dungeon.room.enemy.name} in here!"
      end

      if @dungeon.room.weapon.is_a?(Zarta::Weapon)
        puts "You see a #{@dungeon.room.weapon.name} just laying around."
      end

      @dungeon.room = next_rooms_prompt
    end

    # Makes the dungeon spawn a list of possible rooms connecting here, then
    # prompts the user to chose one.
    def next_rooms_prompt
      @dungeon.new_rooms(@dungeon)
      next_rooms = @dungeon.next_rooms
      next_rooms_options = []
      next_rooms.each { |room| next_rooms_options << room.description }

      next_room_choice = @prompt.select(
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

      hud_table
    end

    attr_accessor :dungeon, :player

    def hud_table
      table = Terminal::Table.new
      table.title = @pastel.bright_red(@dungeon.name)
      table.style = { width: 80, padding_left: 3, border_x: '=' }
      table.rows = build_table_rows
      puts table
    end

    def build_table_rows
      t = []
      t << [@player.name, 'LVL: 1']
      t << [display_health, "EXP: #{@player.xp}"]
      t << [
        "Weapon: #{@player.weapon.name} (#{@player.weapon.damage})",
        "Dungeon Level:  #{@dungeon.current_level}/#{@dungeon.level}"
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
