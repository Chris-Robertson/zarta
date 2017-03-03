# The catch-all module for Zarta
module Zarta
  # The enemy class
  class Enemy
    # The enemy's name
    attr_accessor :name

    # The enemy's current experience level
    attr_accessor :level

    # The enemy's current weapon
    attr_accessor :weapon

    # Did you kill him? Or did you run away? You probably ran away...
    attr_accessor :dealt_with

    def initialize(dungeon)
      @dungeon = dungeon
      @dealt_with = false
      @player = @dungeon.player

      pick_enemy
      set_level
      @health = set_health
      @weapon = Zarta::Weapon.new(@dungeon)
      @pastel = Pastel.new
    end

    def pick_enemy
      return if boss_spawn
      spawn_list = []
      chance = spawn_chance
      @dungeon.enemy_list.each do |enemy|
        spawn_list << enemy if enemy[:rarity] < chance
      end

      spawn = spawn_list[rand(0...spawn_list.length)]

      @name = spawn[:name]
      @description = spawn[:description]
      @rarity = spawn[:rarity]
    end

    # I know, I know.
    def spawn_chance
      rand(1..10)
    end

    def set_level
      plevel = @dungeon.player.level
      @level = rand((plevel - 2)..(plevel + @rarity / 2))
    end

    def set_health
      base = @rarity + @level + @dungeon.level + @dungeon.player.level
      current_health = rand(base..base * 2)
      max_health = current_health
      [current_health, max_health]
    end

    def take_damage(damage)
      @health[0] -= damage
      return unless @health[0] <= 0
      @dealt_with = true
    end

    def boss_spawn
      return false if @dungeon.level < @dungeon.max_level
      return false if rand(100) > @dungeon.stairs_time

      @name = 'BOSS!'
      @description = 'The BOSS!'
      @rarity = 12

      set_level
      set_health
      pick_weapon
      true
    end

    def enemy_turn
      enemy_hit = enemy_damage
      @player.take_damage(enemy_hit)
      puts "The #{@pastel.magenta.bold(@name)} hits you!"
      puts "You take #{@pastel.red.bold(enemy_hit)} damage."
      gets
    end

    # This function and the player one should be moved into a single function.
    # Just pass in the player or enemy.
    def enemy_damage
      base_damage = @weapon.damage + rand(@weapon.damage)
      hit = base_damage + rand(@level) + @level
      hit.round
    end

    def inspect
      table_title
      table
      gets
    end

    def table_title
      table_title = Terminal::Table.new
      table_title.title = @pastel.magenta.bold(@name)
      table_title.style = { width: 40, padding_left: 1 }
      table_title.align_column(0, :center)
      table_title.add_row [@description]
      puts table_title
    end

    def table
      table = Terminal::Table.new
      table.style = { width: 40, padding_left: 1 }
      table.add_row ['Weapon:', @weapon.name]
      table.add_row ['Health:', "#{@health[0]}/#{@health[1]}"]
      puts table
    end
  end
end
