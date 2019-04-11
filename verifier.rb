# Verify the pipesets
class Verify
  def verify_second_pipeset(second_pipeset, previous_hash)
    # Note this assumes the pervious_hash has been checked, and it comes
    # from program memory to save on double checking time
    # Error return values: 1 is incorrect syntax (Empty sets, invalid characters, or too long)
    return 1 if !second_pipeset.match(/\A[a-z0-9]*\z/) || second_pipeset.empty? || second_pipeset.length > 4
    # Error return values: 2 is hash value mismatch
    return 2 if second_pipeset != previous_hash

<<<<<<< HEAD
  def verify_starting_integer(param)
    return true if param.match(/^\d+$/)

    false
=======
    # Success
    0
>>>>>>> origin/master
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
end
