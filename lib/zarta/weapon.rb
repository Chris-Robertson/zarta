# The catch-all module for Zarta
module Zarta
  # A weapon that can be wielded by the player or an enemey
  class Weapon
    # The name of the weapon
    attr_accessor :name

    # The base damage that the weapon deals
    attr_accessor :damage

    def initialize
      @name = 'Testcaliber'
      @damage = 1
    end
  end
end
