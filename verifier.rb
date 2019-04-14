# Verify the pipesets
class Verify

  def initialize
    @balances = {}
  end

  def verify_second_pipeset(second_pipeset, previous_hash)
    # Note this assumes the pervious_hash has been checked, and it comes
    # from program memory to save on double checking time
    # Error return values: 1 is incorrect syntax (Empty sets, invalid characters, or too long)
    return 1 if !second_pipeset.match(/\A[a-z0-9]*\z/) || second_pipeset.empty? || second_pipeset.length > 4
    # Error return values: 2 is hash value mismatch
    return 2 if second_pipeset != previous_hash
  end

  def verify_first_pipeset(param)
    return true if param.match(/^\d+$/)

    false
    # Success
  end

  # Verify the Third Pipeset
  # FROM_ADDR>TO_ADDR(NUM_BILLCOINS_SENT) seperated
  def verify_third_pipeset(param)
    # if there are multiple transactions, split em

    if param.include? ':'
      transactions = param.split(':')

      transactions.each do |a|
        return false unless a.match(/^\d{6}\>\d{6}\(\d+\)$/) || a.match(/\bSYSTEM\b>\d{6}\(\d+\)$/)

        # now we have to check for legitimate transfer
        party_one = param[0...6]
        party_two = param[7...12]
        num_bill_coins = param[/\(.*?\)/]
        num_bill_coins = num_bill_coins.gsub(/[()]/, "")

        # parse pipeset into first person, second person, and number of coins
        return false unless make_transfer(party_one, party_two, num_bill_coins)
      
      end

    else

      return false unless param.match(/^\d{6}\>\d{6}\(\d+\)$/) || param.match(/\bSYSTEM\b>\d{6}\(\d+\)$/)
      
      # now we have to check for legitimate transfer
      party_one = param[0...6]
      party_two = param[7...12]
      num_bill_coins = param[/\(.*?\)/]
      num_bill_coins = num_bill_coins.gsub(/[()]/, "")

      # parse pipeset into first person, second person, and number of coins
      return false unless make_transfer(party_one, party_two, num_bill_coins)

    end

    puts 'got to end, all true'
    true
  end

  def verify_fourth_pipeset(fourth_pipeset, previous_time)
    # Note this assumes the pervious_times have been checked, and it comes
    # from program memory to save on double checking time
    curr_times = fourth_pipeset.split('.')
    previous_times = previous_time.split('.')

    # Error return values: 1 is mutlitple or no periods
    return 1 unless curr_times.length == 2

    # Error return values: 2 is a non-numeric value
    return 2 unless curr_times[0].match(/\A[0-9]*\z/) && curr_times[1].match(/\A[0-9]*\z/)

    curr_time_big = curr_times[0].to_i
    previous_times_big = previous_times[0].to_i

    # Success
    return 0 if curr_time_big > previous_times_big
    # Success
    return 0 if curr_time_big == previous_times_big && curr_times[1].to_i > previous_times[1].to_i

    # Error return values: 3 is time out of order
    3
  end

  # Verify the Fifth Pipeset
  def verify_fifth_pipeset(param, block)
    return false unless param.match(/^[a-f0-9]{4}$/)

    #remove last pipeset
    block = block[0...-5]

    # counter for sum
    counter = 0
    # Unpack each character via U* (string_to_hash.unpack('U*')), thus converting them to its UTF-8 value
    block = block.unpack('U*')
    # For each value in the string, x, perform the following calculation ((x**3000) + (x**x) - (3**x)) * (7**x) and store that value
    # Sum up all of those values
    block.each do |val|
      temp = ((val**3000) + (val**val) - (3**val)) * (7**val)
      counter = counter + temp
    end
    
    # Determine that value modulo 65536
    mod = counter % 65536
  
    # Return the resulting value as a string version of the number in base-16 (hexadecimal)
    result = mod.to_s(16)  #=> "a"

    #check this hash against the hash given in the block
    return true if result == param
  
    false

  end


  def make_transfer(party_one, party_two, num_bill_coins)

    puts ' '
    @balances.each do |a|
      puts a
    end

    # convert num_bill_coins to int
    num_bill_coins = Integer(num_bill_coins)

    # check to make sure party one has the balance to give
    has_enough = false
    @balances[party_one] = 0 unless @balances.key?(party_one)
    @balances[party_two] = 0 unless @balances.key?(party_two)

    #always make sure the system has enough bill coins
    @balances['SYSTEM'] = 9999999

    has_enough = true if num_bill_coins <= @balances[party_one] 

    # if party one has enough coins, make the transfer and return true, else return false
    if has_enough
      @balances[party_one] = @balances[party_one] - num_bill_coins
      @balances[party_two] = @balances[party_two] + num_bill_coins
      return true
    end

    puts ' '
    @balances.each do |a|
      puts a
    end

    false
  end
end
