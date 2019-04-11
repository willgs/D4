# This is a MiniTest test file. 
# Minitest documentation here: http://docs.seattlerb.org/minitest/
# require can be used to access gems (i.e. libraries)
# Libraries tend to be used very often in Ruby programs and especially Rails projects
# Note that you can add a .rb or not

require 'minitest/autorun'
require_relative 'verifier'


class VerifierTest < Minitest::Test

    def test_verify_starting_integer_given_negative
        ver = Verifier.new
        a = '-1'
        b = '-20'
        c = '-10000000000000'
        assert_equal ver.verify_starting_integer(a), false
        assert_equal ver.verify_starting_integer(b), false
        assert_equal ver.verify_starting_integer(c), false
    end

end