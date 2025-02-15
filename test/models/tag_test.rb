require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test 'should create sample tag' do
    tag = Tag.first

    assert_not_nil tag.name
    assert_not_nil tag.maps

    tag = Tag.find_by_name 'nice'

    assert_not_nil tag.name
    assert_not_nil tag.maps
    assert_not_nil tag.maps.last.has_tag('nice')
    assert_not_nil tag.maps.last.name
    assert_not_nil tag.maps.last.created_at
  end

  test 'should find all maps with the provided tag' do
    @tag = Tag.find_by_name('featured')
    @maps = @tag.maps
    assert_equal 1, @maps.length
  end

end
