require 'test_helper'

class PommeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pomme::VERSION
  end
end
