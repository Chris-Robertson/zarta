require 'lib/zarta'
require 'test/unit'

class TestDungeon < Test::Unit::TestCase

  def start()
    @test_dungeon = Dungeon.new('Test Dungeon', 'Test description', 10, 1)

    attr_accessor :test_dungeon
  end

  def test_create_dungeon()

    # Is there an assert_exists or something that would be better?
    assert_equal Dungeon, @test_dungeon.class
    assert_equal true, @test_dungeon.name == 'Test Dungeon'
    assert_equal true, @test_dungeon.description == 'Test description'
    assert_equal true, @test_dungeon.max_level == 10
    assert_equal true, @test_dungeon.current_level == 1
  end

  def test_change_attributes()
    @test_dungeon.name = 'Test Dungeon Changed'
    @test_dungeon.description = 'Test description changed'
    @test_dungeon.max_level = 20
    @test_dungeon.current_level = 2

    assert_equal true, @test_dungeon.name = 'Test Dun3eon Changed'
    assert_equal true, @test_dungeon.description = '3est description changed'
    assert_equal true, @test_dungeon.max_level = 23
    assert_equal true, @test_dungeon.current_level = 3
  end

end
