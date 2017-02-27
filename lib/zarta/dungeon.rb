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

    def initialize
      @name           = 'The Legendary Dungeon of ZARTA'
      @description    = 'The testiest test dungeon that ever tested!'
      @max_level      = 10
      @current_level  = 1
      @room_list      = YAML.load_file(__dir__ + '/rooms.yml')
    end
  end

  # Returns a random room adjective
  class Room
    def initialize(dungeon)
      @dungeon = dungeon
    end

    def description
      @dungeon.room_list[rand(0...@dungeon.room_list.length)]
    end
  end

  class Stairs; end
end
