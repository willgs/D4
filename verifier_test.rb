require 'minitest/autorun'
require_relative 'verifier'

# CLASS MinitestTests for verifier.rb
class VerifierTest < Minitest::Test
  # UNIT TESTS FOR METHOD verify_second_pipeset(second_pipeset, previous_hash)
  # Equivalence classes:
  # Empty sets -> Error code 1
  # More than 4 chars -> Error code 1
  # Capital letters in hash -> Error code 1
  # Special character in hash -> Error code 1
  # Hash Mismatch -> Error code 2
  # Hash Match -> Return 0, success

  # If empty sets are passed, an error code of 1 is returned for incorrect syntax
  def test_empty_sets
    v = Verify.new
    return_code = v.verify_second_pipeset('', '')
    assert_equal 1, return_code
  end

  # If the hash values excede four characters, an error code of 1 is returned for incorrect syntax
  def test_too_many_chars
    v = Verify.new
    return_code = v.verify_second_pipeset('12sd2', '12sd2')
    assert_equal 1, return_code
  end

  # If capital letters are given as an argument, error code 1 is returned for incorrect syntax
  def test_capital_letters
    v = Verify.new
    return_code = v.verify_second_pipeset('2As3', '2As3')
    assert_equal 1, return_code
  end

  # If any non-alpha-numeric characters are given as arguments, error code 1 is returned for incorrect syntax
  def test_special_characters
    v = Verify.new
    return_code = v.verify_second_pipeset('2.s3', '2.s3')
    assert_equal 1, return_code
  end

  # If the hash value arguments are not the same, error code 2 is returned for hash value mismatch
  def test_hash_mismatch
    v = Verify.new
    return_code = v.verify_second_pipeset('1as3', '2as3')
    assert_equal 2, return_code
  end

  # If the hashes are non-empty and alpha-numeric and match, code 0 is returned for a valid pipeset
  def test_hash_match
    v = Verify.new
    return_code = v.verify_second_pipeset('as3', 'as3')
    assert_equal 0, return_code
  end

  # UNIT TESTS FOR METHOD verify_fourth_pipeset(fourth_pipeset, previous_time)
  # Equivalence classes:
  # Empty sets -> Error code 1
  # Letters in the pipeset -> Error code 2
  # Time out of order, milliseconds out of order -> Error code 3
  # Time out of order, nanoseconds out of order -> Error code 3
  # Time out of order, times are equal -> Error code 3
  # Time are valid, milliseconds are smaller -> Return code 0
  # Time are valid, nanoseconds are smaller -> Return code 0

  # If empty sets are passed, an error code of 1 is returned for missing the dot seperator
  def test_empty_sets_2
    v = Verify.new
    return_code = v.verify_fourth_pipeset('', '')
    assert_equal 1, return_code
  end

  # If letters are passed, an error code of 2 is returned for incorrect syntax
  def test_non_numeric_times
    v = Verify.new
    return_code = v.verify_fourth_pipeset('123.2s1', '123.12')
    assert_equal 2, return_code
  end

  # If the times are out of order such that the milliseconds of the current lines fourth pipeset are
  # less than the milliseconds of the previous line's fourth pipeset, an error code of 3 is
  # returned for times out of order
  def test_out_of_order_times_milliseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('100.99', '121.99')
    assert_equal 3, return_code
  end

  # If the times are out of order such that the milliseconds are the same but the nanoseconds of current lines
  # fourth pipeset are less than the nanoseconds of the previous line's fourth pipeset, an error code of 3 is
  # returned for times out of order
  def test_out_of_order_times_nanoseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.12', '121.99')
    assert_equal 3, return_code
  end

  # If the times are out of order such that the milliseconds are the same but the nanoseconds of current lines
  # fourth pipeset are the same as the nanoseconds of the previous line's fourth pipeset, an error code of 3 is
  # returned for times out of order
  def test_equal_nanoseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.99', '121.99')
    assert_equal 3, return_code
  end

  # If the milliseconds of the current lines fourth pipeset is greater than the milliseconds of the previous lines
  # fourth pipeset return code 0 for success, times are validated
  def test_validated_times_milliseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.99', '100.99')
    assert_equal 0, return_code
  end

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
  # If the milliseconds of the current lines fourth pipeset are equal to the milliseconds of the previous lines fourth
  # pipeset and the nanoseconds or the current lines fourth pipeset are greater than the previous line's fourth pipeset
  # return code 0 for success, times are validated
  def test_validated_times_nanoseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.99', '121.12')
    assert_equal 0, return_code
  end
end
