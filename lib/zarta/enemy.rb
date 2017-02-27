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
