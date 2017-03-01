require 'yaml'

# The catch-all module for Zarta
module Zarta
  # Keeps track of the dungeon
  class Dungeon
    # The name of the dungeon
    attr_accessor :name

    # The description of the dungeon
    attr_accessor :description

    # The deepest level of the dungeon
    attr_accessor :max_level

    # The level the player is currently on
    attr_accessor :level

    # An array of all possible room adjectives
    attr_accessor :room_list

    # A list of all possible weapon drops
    attr_accessor :weapon_list

    # The number of rooms passed through since the last set of stairs.
    attr_accessor :stairs_time

    # The player
    attr_accessor :player

    # The current room
    attr_accessor :room

    def initialize
      @name        = 'The Legendary Dungeon of ZARTA'
      @description = 'The testiest test dungeon that ever tested!'
      @max_level   = 10
      @level       = 1
      @room_list   = YAML.load_file(__dir__ + '/rooms.yml')
      @weapon_list = YAML.load_file(__dir__ + '/weapons.yml')
      @stairs_time = 0
      @player      = Zarta::Player.new(self)
      @room        = Zarta::Room.new(self)

      @player.starting_weapon
    end
  end

  # Returns a random room adjective
  class Room
    # The dungeon that the room is in
    attr_accessor :dungeon

    # The description of the room
    attr_accessor :description

    # Base chance of an enemy spawning
    attr_accessor :enemy_chance

    # Base chance of an weapon spawning
    attr_accessor :weapon_chance

    # A list of room objects
    attr_accessor :next_rooms

    # Any enemy that has spawned in this room
    attr_accessor :enemy

    # Any weapon that has spawned in this room
    attr_accessor :weapon

    # Any stairs that have spawned in this room
    attr_accessor :stairs

    def initialize(dungeon)
      @dungeon              = dungeon
      @description          = new_description
      @enemy_chance         = 20 + (@dungeon.level + 5)
      @weapon_chance        = 5 + (@dungeon.level + 5)
      @next_rooms           = [] # A list of room objects
      @stairs_chance        = 0
      @dungeon.stairs_time += 1
      @stairs               = false

      populate_room
    end

    def new_rooms(dungeon)
      min_rooms = 2
      max_rooms = 5
      rand(min_rooms..max_rooms).times do
        @next_rooms << Zarta::Room.new(dungeon)
      end
    end

    # Check if an enemy spawned
    def enemy_spawned
      @enemy_chance > rand(100)
    end

    # Check if a weapon spawned
    def weapon_spawned
      @weapon_chance > rand(100)
    end

    # Check if stairs spawned
    def stairs_spawned
      return if @dungeon.level == @dungeon.max_level
      @stairs_chance + @dungeon.stairs_time > rand(100)
    end

    def new_description
      @dungeon.room_list[rand(0...@dungeon.room_list.length)]
    end

    def populate_room
      @enemy = Zarta::Enemy.new if enemy_spawned
      @weapon = Zarta::Weapon.new(@dungeon) if weapon_spawned
      @stairs = true && @dungeon.stairs_time = 0 if stairs_spawned
    end
  end
end
