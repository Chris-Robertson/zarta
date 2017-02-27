# The catch-all module for Zarta
module Zarta
  # The player character
  class Player
    # The player's name
    attr_accessor :name

    # The player's health in an array
    # [current health / max health]
    attr_accessor :health

    # The player's current experience level
    attr_accessor :level

    # The player's accumulated experience points
    attr_accessor :xp

    # The player's current weapon
    attr_accessor :weapon

    def initialize
      @name   = 'Testy McTestface'
      @health = [100, 100]
      @level  = 1
      @xp     = 0
      @weapon = Zarta::Weapon.new
    end
  end
end
