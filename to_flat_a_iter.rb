#!/usr/bin/env ruby
require "test/unit"

# This file creates a WithToFlatAIter mixin
# and includes it within the builtin Array class,
# then it defines a few tests to verify functionality
# works as expected.

# For a recursive version, check out
# https://github.com/kurtiss/blob/master/to_flat_a_recursive.rb

module WithToFlatAIter

  # Returns a flattened version of this array
  def to_flat_a
    result = []

    # Keep a stack of arrays and indices
    # the array at the end of array_stack
    # and the index at the end of index_stack
    # point to the next element to evaluate
    array_stack = [self]
    index_stack = [0]

    while !array_stack.empty? do
      # does the current array have elements left to process?
      if index_stack.last < array_stack.last.length
        next_element = array_stack.last[index_stack.last]

        if next_element.kind_of?(Array)
          # process the array in the next iteration
          array_stack.push(next_element)
          index_stack.push(-1)
        else
          # must be a value element, so yield it
          result << next_element
        end
      else
        # done processing elements in the array at stack's end
        array_stack.pop
        index_stack.pop
      end

      # increment the last index
      index_stack.any? and index_stack[-1] += 1
    end

    result
  end
end

class Array
  include WithToFlatAIter
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
