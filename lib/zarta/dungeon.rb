require 'yaml'

# The catch-all module for Zarta
module Zarta
  # Keeps track of the dungeon. Mostly, this guy is used for passing all the
  # other objects to each other and keeping track of a few things because I'm
  # not allowed to use class variables for some reason...
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

    # A list of all possible enemy spawns
    attr_accessor :enemy_list

    # The number of rooms passed through since the last set of stairs.
    attr_accessor :stairs_time

    # The player
    attr_accessor :player

    # The current room
    attr_accessor :room

    def initialize
      load_yaml_files

      @name        = 'The Legendary Dungeon of ZARTA'
      @description = 'The testiest test dungeon that ever tested!'
      @max_level   = 10
      @level       = 1
      @stairs_time = 0
      @player      = Zarta::Player.new(self)
      @room        = Zarta::Room.new(self)
    end

    # Moved him out for clarity and ease of editing. I know enemy isn't plural.
    # It bugs me as well. It's on my list.
    def load_yaml_files
      @room_list   = YAML.load_file(__dir__ + '/rooms.yml')
      @weapon_list = YAML.load_file(__dir__ + '/weapons.yml')
      @enemy_list  = YAML.load_file(__dir__ + '/enemy.yml')
    end
  end

  # Where all the magic happens. Not really. Magic hasn't been implemented.
  class Room
    # The dungeon. The main guy. The big cheese.
    attr_accessor :dungeon

    # The description of the room
    attr_accessor :description

    # A list of rooms that are 'connected' to this one
    attr_accessor :next_rooms

    # If an enemy spawned in this room, he'll be in here
    attr_accessor :enemy

    # See above. Except this one is for weapons. If that wasn't clear.
    attr_accessor :weapon

    # Stairs, yes or no?
    attr_accessor :stairs

    def initialize(dungeon)
      @dungeon              = dungeon
      @description          = new_description
      @next_rooms           = [] # A list of room objects. Well, it will be.
      @dungeon.stairs_time += 1
      @stairs               = false

      @enemy = []
      populate_room
    end

    # Buys itself something pretty. As long as its a random word from a yaml
    # file.
    def new_description
      @dungeon.room_list[rand(0...@dungeon.room_list.length)]
    end

    # If anything exciting is going to happen in this room, it starts in here.
    def populate_room
      @enemy  = Zarta::Enemy.new(@dungeon) if enemy_spawned
      @weapon = Zarta::Weapon.new(@dungeon) if weapon_spawned
      @stairs = stairs_spawned
    end

    # I can't call this in the initiazation or else it will endlessly spawn
    # rooms and break everything.
    def new_rooms
      min_rooms = 2
      max_rooms = 4
      rand(min_rooms..max_rooms).times do
        @next_rooms << Zarta::Room.new(@dungeon)
      end
    end

    # These next three functions handle the amazingly complex algorithm that
    # determines if objects spawn in this room. I will, at some stage, move
    # these hard-coded numbers out into constants. One day.
    def enemy_spawned
      enemy_chance = 40 + (@dungeon.level + 5)
      enemy_chance < rand(100) ? true : false
    end

    def weapon_spawned
      weapon_chance = 10 + (@dungeon.level + 5)
      weapon_chance < rand(100) ? true : false
    end

    def stairs_spawned
      return false if @dungeon.level == @dungeon.max_level
      stairs_chance = 10
      @dungeon.stairs_time += 1
      stairs_chance + @dungeon.stairs_time > rand(100) ? true : false
    end
  end
end
