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
  end
end
