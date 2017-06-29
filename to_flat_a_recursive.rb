#!/usr/bin/env ruby
require "test/unit"

# This file creates a WithToFlatARecursive mixin
# and includes it within the builtin Array class,
# then it defines a few tests to verify functionality
# works as expected.

# For an iterative version, check out
# https://github.com/kurtiss/blob/master/to_flat_a_recursive.rb

module WithToFlatARecursive

  # Returns a flattened version of this array
  def to_flat_a
    result = []

    # loop through each of this object's element
    self.each do |element|
      # if the element is something which can itself be further flattened
      if element.respond_to? :to_flat_a
        # append each of the sub elements that flattened element contains
        element.to_flat_a.each do |sub_element|
          result << sub_element
        end
      else
        # otherwise, append the element itself
        result << element
      end
    end

    result
  end
end

class Array
  include WithToFlatARecursive
end

class TestToFlatAIter < Test::Unit::TestCase
  def test_known_values
    assert_equal([], [].to_flat_a)
    assert_equal([0], [0].to_flat_a)
    assert_equal([0, 1], [0, [1]].to_flat_a)
    assert_equal([0, 1], [0, [], 1].to_flat_a)
    assert_equal([0, 1, 2, 3], [0, [1, [2]], 3].to_flat_a)
  end
end
