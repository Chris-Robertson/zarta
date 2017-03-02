# The catch-all module for Zarta
module Zarta
  # The enemy class
  class Enemy
    # The enemi's name
    attr_accessor :name

    # The enemie's health in an array
    # [current health / max health]
    attr_accessor :health

    # The enemy's current experience level
    attr_accessor :level

    # The enemy's description
    attr_accessor :description

    # The enemy's current weapon
    attr_accessor :weapon

    def initialize(dungeon)
      @dungeon = dungeon

      pick_enemy
      set_level
      set_health
      pick_weapon
    end

    def pick_weapon
      @weapon = Zarta::Weapon.new(@dungeon)
      @weapon.random_drop
    end

    def pick_enemy
      return if boss_spawn
      spawn_list = []
      @dungeon.enemy_list.each do |enemy|
        spawn_list << enemy if enemy[:rarity] <= chance
      end

      spawn = spawn_list[rand(0...spawn_list.length)]

      @name = spawn[:name]
      @description = spawn[:description]
      @rarity = spawn[:rarity]
    end

    def chance
      (@dungeon.player.level + @dungeon.level) / 2
    end

    def set_level
      plevel = @dungeon.player.level
      @level = rand((plevel - 2)..(plevel + @rarity))
    end

    def set_health
      base = @rarity + @level + @dungeon.level + @dungeon.player.level
      current_health = rand(base..base * 3)
      max_health = current_health
      @health = [current_health, max_health]
    end

    def take_damage(damage)
      @health[0] -= damage
      return true if @health[0] <= 0
      false
    end

    def boss_spawn
      return false if @dungeon.level < @dungeon.max_level
      return false if rand(100) > @dungeon.stairs_time

      @name = 'BOSS!'
      @description = 'The BOSS!'
      @rarity = 12

      @level = rand(@dungeon.player.level..(@dungeon.player.level * 1.5))
      set_health
      pick_weapon
      true
    end

    def inspect
      Zarta::HUD.new(dungeon)
      @pastel = Pastel.new
      table_title = Terminal::Table.new
      table_title.title = @pastel.magenta.bold(@name)
      table_title.style = { width: 40, padding_left: 1 }
      table_title.align_column(0, :center)
      table_title.add_row [@description]
      puts table_title

      table = Terminal::Table.new
      table.style = { width: 40, padding_left: 1 }
      table.add_row ['Weapon:', @weapon.name]
      table.add_row ['Health:', "#{@health[0]}/#{@health[1]}"]
      puts table
      gets
    end
  end
end
