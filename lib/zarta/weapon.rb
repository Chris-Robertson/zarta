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
      @player  = @dungeon.player
      @pastel  = Pastel.new

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
      rand((@dungeon.level - 2)...(@dungeon.level + 2))
    end

    def inspect_weapon
      title_table
      table
      gets
    end

    def title_table
      table_title = Terminal::Table.new
      table_title.title = @pastel.cyan.bold(@name)
      table_title.style = { width: 40, padding_left: 1 }
      table_title.align_column(0, :center)
      table_title.add_row [@description]
      puts table_title
    end

    def table
      table = Terminal::Table.new
      table.style = { width: 40, padding_left: 1 }
      table.add_row ['Damage:', @damage]
      table.add_row ['Rarity:', @rarity]
      puts table
    end
  end
end
