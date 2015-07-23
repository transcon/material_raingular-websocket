require "test_helper"
class EmittableTest < TestCase
  def test_ar_responds_to_emittable
    assert_respond_to ActiveRecord::Base, :emittable
    assert_respond_to ActiveRecord::Base, :emittable?
  end

  def test_emittable_works
    FlyingTable.with(emittable_things: {name: :string}, non_emittable_things: {name: :string}) do
      EmittableThing.send(:emittable)
      @thing     = EmittableThing.create(name: 'muffins')
      @non_thing = NonEmittableThing.create(name: 'aardvark')
      assert_equal false, @non_thing.emittable?
      assert_equal true,  @thing.emittable?
      assert_silent {@thing.send(:emit_changes) }
    end
  end
end
