require 'tty'

class Dungeon

  # Has...
  # A name
  # A desription
  # Current level
  # Max level
  #
  def initialize(name, description, max_level, current_level)
    @name = name
    @description = description
    @max_level = max_level
    @current_level = current_level
  end

  attr_accessor :name, :description, :max_level, :current_level

  # Can...
  #

end

class RoomList

  # Has...
  # A list of rooms
  #
  def initialize()
    # __dir__ gives the absolute path of the file where the method is run
    # otherwise tests run from another directory won't work
    room_file = open(__dir__ + "/rooms.txt")
    @room_list = []

    room_file.each do |room|
      @room_list.push(room)
    end
  end

  # Can...
  # Give a specified amount of random rooms
  # 
  def get_room_list()
    return @room_list
  end

  def get_this_room()
    return @room_list[rand(@room_list.length)]
  end

  def get_next_rooms()
    # How many rooms lead from this one?
    next_rooms_count = rand(0...MAX_ROOM_COUNT)
    next_rooms = []

    (0..next_rooms_count).each do |room|
      next_rooms.push(@room_list[rand(@room_list.length)])
    end

    return next_rooms
  end
end

class Room

  # Has...
  # A decription
  # A list of rooms that join onto it
  # A random chance of a weapon
  # A random chance of stairs down

  # Can...
  #

end

# Currently handles most of the implementation of the game. Need to refactor,
class RoomGenerator

  def initialize()
    @rooms = RoomList.new()
  end

  def clear_screen
    system "clear" or system "cls"
  end

  def play_room(this_room=nil)
    # If this is the first room, generate a room decription
    if this_room == nil
      this_room = @rooms.get_this_room()
    end

    next_rooms = @rooms.get_next_rooms()

    clear_screen()
    puts "You are in #{this_room.chomp}."
    puts "You see these rooms from here:"
    next_rooms.each_with_index do |next_room_option, index|
      puts "#{index + 1} - #{next_room_option.capitalize}"
    end
    puts "Which room do you want to move to?"
    print "> "
    player_room_choice = $stdin.gets.chomp.to_i
    next_room_choice = next_rooms[(player_room_choice - 1)]

    play_room(next_room_choice)

  end
end

class EnemyList

  # Has ...
  # A list of all enemies
  #
  def initialize()
    room_file = open(__dir__ + "/enemy.txt")
    @@enemy_list = []

    room_file.each do |room|
      @@enemy_list.push(room)
    end
  end

  # Can...
  # Give a random enemy
  #
  
end

class Enemy

  # Has...
  # Name
  # HP
  # Damage
  # XP value
  #

  # Can...
  # Attack
  # Take damage
  # Die
  # Give XP

end

class Player

  # Has...
  # Name
  # HP
  # Weapon
  # XP
  # Level
  #
  
  # Can
  # Attack
  # Select next room
  # Move to next room
  #

end

class Weapon

  # Has...
  # Name
  # Description
  # Damage
  #

  # Can...
  #

end

class Engine

  # Has...
  #
  def initialize()

  end

  # Can...
  # Start the main game loop
  def play()
    
    new_room = RoomGenerator.new(@room_list)
    new_room.play_room()

  end
end


