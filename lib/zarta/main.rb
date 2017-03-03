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

  # Writes the current game screen. No idea why I didn't just do all this stuff
  # in the Engine class. Look how empty that thing is. You probably didn't even
  # see it up there.
  class Screen
    def initialize(dungeon)
      @dungeon  = dungeon
      @player   = @dungeon.player
      @room     = @dungeon.room
      @prompt   = TTY::Prompt.new

      refresh
    end

    # When the player moves into a new room, this function checks if anything
    # has spawned in it and calls the appropriate functions. Looking at it now,
    # it seems that all of this fucnctionality could be off-handed to the room
    # class. I'm just creating HUD objects in any function where I need to
    # refresh it anyway. Feels redundant.
    def refresh
      Zarta::HUD.new(@dungeon)

      players_wins if @player.boss_is_dead
      @player.handle_enemy if @room.enemy.is_a?(Zarta::Enemy)
      @player.handle_weapon if @room.weapon.is_a?(Zarta::Weapon)
      handle_stairs if @room.stairs

      Zarta::HUD.new(@dungeon)
      @room = next_rooms_prompt
      refresh
    end

    # Another function that could be handed off to the Room class. Like that
    # whale of a beast needs more methods. Maybe it would make more sense to
    # move some functionality into the Engine class.
    def handle_stairs
      puts 'You see stairs leading down here.'
      return unless @prompt.yes?('Go down?')
      @dungeon.level += 1
      @dungeon.room = Zarta::Room.new(@dungeon)
      refresh
    end

    # Not one to be left out, this guy could also piss off somewhere else. Seems
    # like this class is doomed. When I can get round to it, that is. So maybe
    # it will be ok...
    def next_rooms_prompt
      next_rooms_options = []
      @dungeon.room.new_rooms(@dungeon)
      @dungeon.room.next_rooms.each do |room|
        next_rooms_options << room.description
      end

      puts 'You see these rooms ahead of you,'
      next_room_choice = @prompt.select('Choose one:', next_rooms_options)

      @dungeon.room.next_rooms.each do |room|
        return room if next_room_choice == room.description
      end
    end

    # I've never made this method call, so I'll just assume that it works...
    def player_wins
      puts 'Congrats, you won the game!'
      gets
      exit[0]
    end
  end

  # Resfreshes the top of the screen when I need it to. I spawn instances of
  # this guy a lot.
  class HUD
    def initialize(dungeon)
      @dungeon  = dungeon
      @player   = @dungeon.player
      @pastel   = Pastel.new

      hud_table
    end

    # Lays out the top of the screen in a nice way for me. It would be great if
    # I could get the whole game to display in a bordered table, but alas, the
    # gem I'm using can't do it, and I appear to lack the technichal knowhow.
    def hud_table
      table = Terminal::Table.new
      table.title = @pastel.bright_red(@dungeon.name)
      table.style = { width: 80, padding_left: 3, border_x: '=' }
      table.rows = build_table_rows
      system 'clear'
      puts table
      puts room_description
    end

    # Pulled this and the functions it calls below out here to make it a little
    # clearer and to be able to make changes without breaking my brain.
    def build_table_rows
      t = []
      t << [@player.name, "LVL: #{@player.level}"]
      t << [display_health, display_xp]
      t << [display_weapon, display_dungeon_level]
    end

    def display_health
      current_health = @player.health[0]
      max_health = @player.health[1]
      hud_health = "HP: #{current_health}/#{max_health}"

      return @pastel.red(hud_health) if current_health < max_health / 2
      @pastel.green(hud_health)
    end

    def display_xp
      "EXP: #{@player.xp}/#{@player.level * 10}"
    end

    def display_weapon
      "Weapon: #{@player.weapon.name} (#{@player.weapon.damage})"
    end

    def display_dungeon_level
      "Dungeon Level:  #{@dungeon.level}/#{@dungeon.max_level}"
    end

    # Pretty straightforward but I have plans for the room description
    # generation to be far more interesting. So check back here sometime in the
    # next millenium.
    def room_description
      word_start = beginning(@dungeon.room.description)
      puts "You are in #{word_start} #{@dungeon.room.description} room."
    end

    # Checks if a word is an 'an' word or an 'a' word.
    # http://stackoverflow.com/a/18463759/1576860
    def beginning(word)
      # That weird looking thing below is interpolated as an array, so it would
      # come out looking like: [a, e, i, o ,u]
      %w(a e i o u).include?(word[0]) ? 'an' : 'a'
    end
  end
end
