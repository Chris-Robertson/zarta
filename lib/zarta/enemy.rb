# The catch-all module for Zarta
module Zarta
  # The enemy class
  class Enemy
    # Enemy's name
    attr_accessor :name

    # Enemy's base damage
    attr_accessor :damage

    def initialize
      @enemy_list = YAML.load_file(__dir__ + '/enemy.yml')
      @name       = @enemy_list[rand(0...@enemy_list.length)]
      @damage     = 2
    end
  end
end
