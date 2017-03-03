# The catch-all method for the game
module Zarta
  # Holds all the combat functionality. At this stage only the player uses it,
  # but in the future I plan to have a more fleshed-out enemy AI that can use
  # these functions itself to, for example, attempt to flee from the player.
  module Combat

    def handle_enemy
      @current_enemy = @dungeon.room.enemy.name
      @current_enemy = @pastel.magenta.bold(@current_enemy)
      puts "There is a #{@current_enemy} in here!"

      until @dungeon.room.enemy.nil?
        enemy_choice = @prompt.select('What do you want to do?') do |menu|
          menu.choice 'Fight!'
          menu.choice 'Flee!'
          menu.choice 'Look!'
        end

        fight if enemy_choice == 'Fight!'
        flee if enemy_choice == 'Flee!'
        @dungeon.room.enemy.inspect if enemy_choice == 'Look!'
      end
    end
  end
end
