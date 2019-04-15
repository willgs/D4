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
  # Letters in the pipeset -> Error code 1
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
    assert_equal 1, return_code
  end

  # If the times are out of order such that the milliseconds of the current lines fourth pipeset are
  # less than the milliseconds of the previous line's fourth pipeset, an error code of 3 is
  # returned for times out of order
  def test_out_of_order_times_milliseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('100.99', '121.99')
    assert_equal 2, return_code
  end

  # If the times are out of order such that the milliseconds are the same but the nanoseconds of current lines
  # fourth pipeset are less than the nanoseconds of the previous line's fourth pipeset, an error code of 3 is
  # returned for times out of order
  def test_out_of_order_times_nanoseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.12', '121.99')
    assert_equal 2, return_code
  end

  # If the times are out of order such that the milliseconds are the same but the nanoseconds of current lines
  # fourth pipeset are the same as the nanoseconds of the previous line's fourth pipeset, an error code of 3 is
  # returned for times out of order
  def test_equal_nanoseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.99', '121.99')
    assert_equal 2, return_code
  end

  # If the milliseconds of the current lines fourth pipeset is greater than the milliseconds of the previous lines
  # fourth pipeset return code 0 for success, times are validated
  def test_validated_times_milliseconds
    v = Verify.new
    return_code = v.verify_fourth_pipeset('121.99', '100.99')
    assert_equal 0, return_code
  end

  # Verify the first pipeset

  def test_verify_first_pipeset_given_negative
    ver = Verify.new
    a = '-1'
    b = '-20'
    c = '-10000000000000'
    assert_equal ver.verify_first_pipeset(a), 2
    assert_equal ver.verify_first_pipeset(b), 2
    assert_equal ver.verify_first_pipeset(c), 2
  end

  def test_verify_first_pipeset_given_float
    ver = Verify.new
    a = '.5'
    b = '11.55'
    c = '0.0'
    assert_equal ver.verify_first_pipeset(a), 2
    assert_equal ver.verify_first_pipeset(b), 2
    assert_equal ver.verify_first_pipeset(c), 2
  end

  def test_verify_first_pipeset_given_non_numeric
    ver = Verify.new
    a = 'akf kdfj'
    b = 'one'
    c = '1eighty'
    assert_equal ver.verify_first_pipeset(a), 2
    assert_equal ver.verify_first_pipeset(b), 2
    assert_equal ver.verify_first_pipeset(c), 2
  end

  def test_verify_first_pipeset_given_correct_number
    ver = Verify.new
    a = '0'
    b = '100'
    c = '12'
    assert_equal ver.verify_first_pipeset(a), 1
    assert_equal ver.verify_first_pipeset(b), 1
    assert_equal ver.verify_first_pipeset(c), 1
  end

  # Verify the third pipeset

  def test_verify_third_pipeset_given_single_malformed_transaction
    ver = Verify.new
    a = '569274 735567(12)'
    b = '569274>7(12)'
    c = '569>735567(12)'
    d = '-569274>735567(12)'
    e = '569274>-735567(12)'
    f = '569274>735567(-12)'
    g = '569274>735567(0.0)'
    assert_equal ver.verify_third_pipeset(a), 3
    assert_equal ver.verify_third_pipeset(b), 3
    assert_equal ver.verify_third_pipeset(c), 3
    assert_equal ver.verify_third_pipeset(d), 3
    assert_equal ver.verify_third_pipeset(e), 3
    assert_equal ver.verify_third_pipeset(f), 3
    assert_equal ver.verify_third_pipeset(g), 3
  end

  def test_verify_third_pipeset_given_multiple_malformed_transactions
    ver = Verify.new
    a = '569274>735567(12):-569274>735567(12)'
    b = '569274>735567(12): 569274 > 735567(.1)'
    c = '569274>73556712):569274>735567(12):569274>735567(12)'
    assert_equal ver.verify_third_pipeset(a), 1
    assert_equal ver.verify_third_pipeset(b), 1
    assert_equal ver.verify_third_pipeset(c), 1
  end

  def test_verify_third_pipeset_given_single_correctly_formed_transaction
    ver = Verify.new
    a = 'SYSTEM>735567(12)'
    b = '735567>000005(8)'
    c = '000005>795599(4)'
    assert_equal ver.verify_third_pipeset(a), 5
    assert_equal ver.verify_third_pipeset(b), 5
    assert_equal ver.verify_third_pipeset(c), 5
  end

  def test_verify_third_pipeset_given_multiple_correctly_formed_transaction
    ver = Verify.new
    a = 'SYSTEM>735567(12):735567>888888(12):888888>735567(5)'
    assert_equal ver.verify_third_pipeset(a), 5
  end

  def test_verify_third_pipeset_given_not_sufficient_balance
    ver = Verify.new
    a = '888888>735567(12)'
    assert_equal ver.verify_third_pipeset(a), 4
  end

  #verify fifth pipeset

  def test_verify_fifth_pipeset_given_malformed_input
    ver = Verify.new
    a = 'aaa'
    b = 'f'
    c = '11111'
    d = '1a2g'
    e = '-1fa2'
    assert_equal ver.verify_fifth_pipeset(a, ''), 1
    assert_equal ver.verify_fifth_pipeset(b, ''), 1
    assert_equal ver.verify_fifth_pipeset(c, ''), 1
    assert_equal ver.verify_fifth_pipeset(d, ''), 1
    assert_equal ver.verify_fifth_pipeset(e, ''), 1
  end

  def test_verify_fifth_pipeset_given_correct_input
    ver = Verify.new
    a = '288d'
    b = '92a2'
    c = '4d25'
    d = '38c5'
    e = '24a2'
    assert_equal ver.verify_fifth_pipeset(a, '0|0|SYSTEM>569274(100)|1553184699.650330000|288d'), 2
    assert_equal ver.verify_fifth_pipeset(b, '1|288d|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2'), 2
    assert_equal ver.verify_fifth_pipeset(c, '2|92a2|569274>577469(9):735567>717802(1):577469>402207(2):SYSTEM>794343(100)|1553184699.658215000|4d25'), 2
    assert_equal ver.verify_fifth_pipeset(d, '3|4d25|561180>444100(1):SYSTEM>569274(100)|1553184699.663411000|38c5'), 2
    assert_equal ver.verify_fifth_pipeset(e, '4|38c5|569274>689881(33):532260>794343(15):532260>236340(4):402207>070668(1):236340>600381(1):070668>039873(1):SYSTEM>937639(100)|1553184699.666989000|24a2'), 2

  end



  def test_make_transfer_sufficient_funds
    ver = Verify.new
    a = '888888'
    b = '000000'
    c = 'SYSTEM'
    d = 12
    assert_equal ver.make_transfer(c, a, d), true
    assert_equal ver.make_transfer(a, b, d), true
  end

  def test_make_transfer_insufficient_funds
    ver = Verify.new
    a = '888888'
    b = '000001'
    c = 'SYSTEM'
    d = 12
    assert_equal ver.make_transfer(a, b, d), false
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
