require 'test/unit'
require 'zarta'

class TestDungeon < Test::Unit::TestCase

  def setup
    @test_dungeon = Zarta::Dungeon.new('Test Dungeon', 'Test description', 10, 1)
  end

  def test_create_dungeon
    assert_equal Zarta::Dungeon, @test_dungeon.class
    assert_equal true, @test_dungeon.name == 'Test Dungeon'
    assert_equal true, @test_dungeon.description == 'Test description'
    assert_equal true, @test_dungeon.max_level == 10
    assert_equal true, @test_dungeon.current_level == 1
  end

  def test_change_attributes
    @test_dungeon.name = 'Test Dungeon Changed'
    @test_dungeon.description = 'Test description changed'
    @test_dungeon.max_level = 20
    @test_dungeon.current_level = 2

    assert_equal true, @test_dungeon.name == 'Test Dungeon Changed'
    assert_equal true, @test_dungeon.description == 'Test description changed'
    assert_equal true, @test_dungeon.max_level == 20
    assert_equal true, @test_dungeon.current_level == 2
  end

end

class TestHUD < Test::Unit::TestCase

  def setup
    @test_hud = Zarta::HUD.new("dungeon", "player", "enemy")
  end

  def test_hud_creation
    assert_equal Zarta::HUD, @test_hud.class
    #assert_equal ['Dungeon Name', 'Dungeon Level'], @test_hud[0]
    #assert_equal ['Player Name', 'Player Level'], @test_hud[1]
  end
    
end

class TestPlayer < Test::Unit::TestCase

  def setup
    @test_dungeon = Zarta::Dungeon.new('Test Dungeon', 'Test description', 10, 1)
    @test_player = Zarta::Player.new("Test Name", 100, 1, 0, {}, @test_dungeon)
  end

  def test_create_player
    assert_equal Zarta::Player, @test_player.class
    assert_equal true, @test_player.name == 'Test Name'
    assert_equal true, @test_player.health == 100
    assert_equal true, @test_player.level == 1
    assert_equal true, @test_player.xp == 0
    assert_equal true, @test_player.weapon == {}
    assert_equal Zarta::Dungeon, @test_player.dungeon.class

  end

  def test_change_player_attributes
    @test_player.name = 'Test Name Changed'
    @test_player.health = 40  
    @test_player.level = 14
    @test_player.xp = 4
    @test_player.weapon = 4

    assert_equal true, @test_player.name == 'Test Name Changed'
    assert_equal true, @test_player.health == 40 
    assert_equal true, @test_player.level == 14
    assert_equal true, @test_player.xp == 4
    assert_equal true, @test_player.weapon == 4
  end                  
end

class TestRoomList < Test::Unit::TestCase

  def setup
    @room_list = Zarta::RoomList.new
  end

  def test_create_room_list
    assert_equal true, @room_list.class == Zarta::RoomList
  end

  def test_print_room_list
    @room_list.print_room_list
  end

end
