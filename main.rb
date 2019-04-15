require_relative 'verifier'
require 'flamegraph'

# take each block into a list
if ARGV.length != 1
  puts 'invalid number of argumets'
  exit
end

filename = ARGV[0]

# Ruby function to check directory or file existence
unless File.exist?(filename)
  puts 'file not found'
  exit
end

blocks = IO.readlines(filename)

# initialize counter to keep track of transaction number / help with ordering
counter = 0
previous_hash = 0
previous_time = 0.0

# instantiate Verify class
ver = Verify.new

Flamegraph.generate('flamegrapher.html') do
  # verify that each block is syntactically valid, and is a valid block in the chain
  blocks.each do |block|
    str = 'Line: ' + counter.to_s + ' Block chain invalidated - '

    # take newline off of each line
    block = block.delete('\n')

    unless block.include? '|'
      str += 'Bad line syntax, missing pipes '
      puts str + 'Exiting'
    end

    pipesets = block.split('|')

    if pipesets.length != 5
      str += 'Bad line syntax, too many pipes '
      puts str + 'Exiting'
    end

    # make sure first pipeset is valid, and going in correct numerical order
    # returns 1 if the first pipeset of the block is correctly formatted
    # returns 2 if the first pipeset of the block is incorrectly formatted
    ret = ver.verify_first_pipeset(pipesets[0])
    if ret == 1 && Integer(pipesets[0]) == counter
    else
      str += 'Block number has invalid syntax ' if ret == 2
      str += 'Block number is out of order ' if Integer(pipesets[0]) == counter
      puts str + ' Exiting...'
      exit
    end

    # increment the counter
    counter += 1

    # make sure the second pipeset is valid, passing previous hash
    ret = ver.verify_second_pipeset(pipesets[1], previous_hash.to_s)
    if ret.zero?
    else
      str += 'Previous block hash has invalid syntax ' if ret == 1
      str += 'Previous block hash value does not match actual hash result ' if ret == 2
      puts str + 'Exiting...'
      exit
    end

    # make sure third pipeset is valid
    # returns 1 if the third pipeset is malformed
    # returns 2 if the transactions was invalid (coin flow doesn't make sense)
    ret = ver.verify_third_pipeset(pipesets[2])
    if ret == 5
    else
      # this syntax for these if statements may look strange and unreadable, thats because is. But rubocop requires it
      str += 'Transaction sequences have invalid syntax ' if [1, 3].include?(ret)
      str += 'Negative coin balance detected, at least one illegitimate transaction occured ' if [2, 4].include?(ret)
      puts str + 'Exiting...'
      exit
    end

    # make sure fourth pipset is valid, passing previous time
    ret = ver.verify_fourth_pipeset(pipesets[3], previous_time.to_s)
    if ret.zero?
    else
      str += 'Time syntax is invalid ' if ret == 1
      str += 'Time on blocks are out of order ' if ret == 2
      puts str + 'Exiting...'
      exit
    end

    # set this block to the new previous time
    previous_time = pipesets[3]

    # make sure fifth pipeset is valid
    # returns 1 if the fifth pipeset is not a 4 digit hex
    # returns 2 if the fifth pipeset matches the passed hex
    # returns 3 if the fifth pipeset does not match the passed hex
    pipesets[4] = pipesets[4][0..3]
    ret = ver.verify_fifth_pipeset(pipesets[4], block)
    if ret == 2
    else
      str += 'Current lines hash value has invalid syntax ' if ret == 1
      str += 'Current lines hash value does not match read hash value ' if ret == 3
      puts str + 'Exiting...'
      exit
    end
    # set the blocks hash to the new previous hash
    previous_hash = pipesets[4]
  end

  ver.balances.each do |bal|
    puts bal[0] + ': ' + bal[1].to_s + ' billcoins' unless bal[0] == 'SYSTEM'
  end
end
