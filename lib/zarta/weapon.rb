# The catch-all module for Zarta
module Zarta
  # A weapon that can be wielded by the player or an enemey
  class Weapon
    # The dungeon whis weapon dropped in
    attr_accessor :dungeon

    # The player or monster wielding this weapon
    attr_accessor :player

    # The name of the weapon
    attr_accessor :name

    # The base damage that the weapon deals
    attr_accessor :damage

    def initialize(dungeon)
      @dungeon = dungeon
      @player = @dungeon.player

      random_drop
    end

    def random_drop
      drop_list = []
      @dungeon.weapon_list.each do |weapon|
        drop_list << weapon if weapon[:rarity] <= chance
      end

      drop = drop_list[rand(0...drop_list.length)]

      @name = drop[:name]
      @description = drop[:description]
      @damage = drop[:damage]
      @rarity = drop[:rarity]
    end

    def chance
      (@player.level + @dungeon.level) / 2
    end

    def inspect_weapon
      puts @name
      puts @description
      puts "Base damage: #{@damage}"
    end
  end
end
