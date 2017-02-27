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
    attr_accessor :current_level

    # An array of all possible room adjectives
    attr_accessor :room_list

    # The current room that the player is in
    attr_accessor :current_room

    # The next avaliable rooms from the current one
    attr_accessor :next_rooms

    def initialize
      @name           = 'The Legendary Dungeon of ZARTA'
      @description    = 'The testiest test dungeon that ever tested!'
      @max_level      = 10
      @current_level  = 1
      @room_list      = YAML.load_file(__dir__ + '/rooms.yml')
      @current_room   = Zarta::Room.new(self)
      @next_rooms     = []
    end

    def new_rooms(dungeon)
      max_rooms = 3
      @next_rooms = []
      rand(1..max_rooms).times do
        @next_rooms << Zarta::Room.new(dungeon)
      end
    end
  end

  # Returns a random room adjective
  class Room
    # The description of the room
    attr_accessor :description

    # Base chance of an enemy spawning
    attr_accessor :enemy_chance
    def initialize(dungeon)
      @dungeon = dungeon
      @description = new_description
      @enemy_chance = 20 + (@dungeon.current_level + 5)
    end

    # Check if an enemy spawned
    def enemy
      @enemy_chance < rand(100)
    end

    def new_description
      @dungeon.room_list[rand(0...@dungeon.room_list.length)]
    end
  end

  class Stairs; end
end
