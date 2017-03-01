# The catch-all module for Zarta
module Zarta
  # The player character
  class Player
    # The player's name
    attr_accessor :name

    # The player's health in an array
    # [current health / max health]
    attr_accessor :health

    # The player's current experience level
    attr_accessor :level

    # The player's accumulated experience points
    attr_accessor :xp

    # The player's current weapon
    attr_accessor :weapon

    def initialize(dungeon)
      @name    = 'Testy McTestface'
      @health  = [100, 100]
      @level   = 1
      @xp      = 0
      @weapon  = []
      @dungeon = dungeon
      @prompt  = TTY::Prompt.new
      @pastel  = Pastel.new
    end

    def starting_weapon
      @weapon = Zarta::Weapon.new(@dungeon)
    end

    def handle_weapon
      # I'm not making weapon  an instance variable as it may be
      # different every time this method is called
      weapon = @dungeon.room.weapon.name
      weapon = @pastel.cyan.bold(weapon)
      puts "You see a #{weapon} just laying around."

      # Repeat until they pick it up or leave it
      loop do
        weapon = @dungeon.room.weapon
        weapon_choice = weapon_prompt

        if weapon_choice == 'Pick it up'
          break if pickup_weapon(weapon)
        end

        weapon.inspect_weapon if weapon_choice == 'Look at it'

        return if weapon_choice == 'Leave it'
      end
    end

    def weapon_prompt
      @prompt.select('What do you want to do?') do |menu|
        menu.choice 'Pick it up'
        menu.choice 'Look at it'
        menu.choice 'Leave it'
      end
    end

    def pickup_weapon(weapon)
      puts 'Your current weapon will be replaced.'
      if @prompt.yes?('Are you sure?')
        @weapon = weapon
        Zarta::HUD.new(@dungeon)
      end
    end
  end
end
