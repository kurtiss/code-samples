#!/usr/bin/env ruby
require "test/unit"

# This file creates a WithPrimeDecomposition mixin
# and includes it within the builtin Integer class,
# then it defines a few tests to verify functionality
# works as expected.

module WithPrimeDecomposition
  # Decomposes the current number into an array of prime factors.
  def decompose
    if self < 2
      raise "can't decompose a value less than 2"
    end

    # check each possible divisor
    (2..self/2).each do |i|
      # if it divides cleanly
      if self % i == 0
        # it will be one of our prime factors
        # and the rest will come from recursing on the right
        return [i] + (self/i).decompose
      end
    end

    # no clean division could be made, so self
    # is prime and should be returned on its own
    return [self]
  end

  # Returns the prime decomposition of this number as a string.
  def decompose_to_s
    return sprintf("%d = %s", self, self.decompose.join(" * "))
  end
end

class Integer
  include WithPrimeDecomposition
end

class TestPrimeDecomposition < Test::Unit::TestCase

  def test_bounds
    (-1..1).each do |n|
      assert_raise(RuntimeError) do
        n.decompose_to_s
      end
    end
  end

  def test_known_values
    assert_equal(2.decompose_to_s, "2 = 2")
    assert_equal(99999.decompose_to_s, "99999 = 3 * 3 * 41 * 271")
  end

end
