# The catch-all module for Zarta
module Zarta
  # The Bloated Beast. The Mother of Methods. The Function Fornicator.
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
      @dungeon = dungeon
      @weapon  = Zarta::Weapon.new(@dungeon)
      @prompt  = TTY::Prompt.new
      @pastel  = Pastel.new
    end

    def handle_weapon
      @room_weapon = @dungeon.room.weapon
      @room_weapon_c = @pastel.cyan.bold(@room_weapon.name)
      @weapon_handled = false
      Zarta::HUD.new(@dungeon)
      puts "You see a #{@room_weapon_c} in this room."

      # Repeat until they pick it up or leave it
      prompt_weapon until @weapon_handled
    end

    def prompt_weapon
      weapon_choice = @prompt.select('What do you want to do?') do |menu|
        menu.choice 'Pick it up'
        menu.choice 'Look at it'
        menu.choice 'Leave it'
      end
      pickup_weapon if weapon_choice == 'Pick it up'
      @room_weapon.inspect_weapon if weapon_choice == 'Look at it'
      leave_weapon if weapon_choice == 'Leave it'
    end

    def pickup_weapon
      puts 'Your current weapon will be replaced.'
      return unless @prompt.yes?('Are you sure?')
      @weapon = @room_weapon
      @weapon_handled = true
      Zarta::HUD.new(@dungeon)
    end

    def leave_weapon
      return unless @prompt.yes?('Are you sure?')
      @weapon_handled = true
    end

    def handle_enemy
      @enemy = @dungeon.room.enemy
      @enemy_c = @pastel.magenta.bold(@enemy.name)
      puts "There is a #{@enemy_c} in here!"

      # Loop until the enemy is dealt with.
      prompt_enemy until @enemy.dealt_with
    end

    def prompt_enemy
      enemy_choice = @prompt.select('What do you want to do?') do |menu|
        menu.choice 'Fight!'
        menu.choice 'Flee!'
        menu.choice 'Look!'
      end

      fight if enemy_choice == 'Fight!'
      flee if enemy_choice == 'Flee!'
      @enemy.inspect if enemy_choice == 'Look!'
    end

    def fight
      Zarta::HUD.new(@dungeon)
      player_turn
      enemy_killed && return if @enemy.dealt_with
      @enemy.enemy_turn
    end

    def player_turn
      Zarta::HUD.new(@dungeon)
      hit = player_damage
      @enemy.take_damage(hit)
      puts "You attack the #{@enemy_c}!"
      puts "You hit for #{@pastel.bright_yellow.bold(hit)} damage."
      gets
    end

    # Another Turing-level algorithm for determining how hard the player hits.
    # It would be cool to generate critical hits in here.
    def player_damage
      base_damage = @weapon.damage + rand(@weapon.damage)
      hit = base_damage + rand(@level) + @level
      hit.round
    end

    def flee
      return unless @prompt.yes?('Are you sure?')
      puts "You try to get away from the #{@enemy_c}"
      flee_hit
      @enemy.dealt_with = true
      gets
    end

    def flee_hit
      base = @dungeon.level + @level
      level_difference = @enemy.level - @level
      flee_chance = (rand(base) + level_difference) * FLEE_CHANCE
      flee_damage && return if rand(base) <= flee_chance
      puts 'You are successful!'
      @enemy.dealt_with = true
    end

    def flee_damage
      enemy_hit = @enemy.enemy_damage
      take_damage(enemy_hit)
      puts "The #{@enemy_c} hits you as you try to flee!"
      puts "You take #{@pastel.red.bold(enemy_hit)} hits you as you flee!"
    end

    def take_damage(damage)
      @health[0] -= damage
      death if @health[0] <= 0
    end

    def death
      puts 'You have been killed!'
      puts @pastel.bright_red.bold('GAME OVER')
      gets
      exit[0]
    end

    def enemy_killed
      xp_gained = gain_xp
      puts "You have slain the #{@enemy_c}!"
      puts "You gain #{@pastel.bright_blue.bold(xp_gained)} Experience."
      level_up if @xp >= @level * NEXT_LEVEL_XP
      @enemy.dealt_with = true
      player_wins if @enemy.name == 'BOSS!'
      gets
    end

    # I've never made this method call, so I'll just assume that it works...
    def player_wins
      puts 'Congrats, you won the game!'
      gets
      exit[0]
    end

    def gain_xp
      xp_gained = @enemy.level + @level + @dungeon.level
      @xp += xp_gained
      xp_gained
    end

    def level_up
      @xp -= @level * NEXT_LEVEL_XP
      @level += 1
      puts @pastel.bright_blue.bold('You gain a level!')
      puts "You are now level #{@pastel.bright_blue.bold(@level)}"
      health_increase
    end

    def health_increase
      base_increase = (@level - 1) + @dungeon.level
      increase = rand(base_increase..base_increase * HEALTH_INCREASE)
      @health[1] += increase
      @health[0] = @health[1]
      puts 'Your health is replenished!'
      puts "You gain #{@pastel.bright_green.bold(increase)} to max health."
    end
  end
end
