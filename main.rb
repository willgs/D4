require_relative 'verifier'

# take each block into a list
filename = '4/sample.txt'
blocks = IO.readlines(filename)

# initialize counter to keep track of transaction number / help with ordering
counter = 0
previous_hash = 0
previous_time = 0.0

#instantiate Verify class
ver = Verify.new

# verify that each block is syntactically valid, and is a valid block in the chain
blocks.each do |block|

    #take newline off of each line
    block = block.gsub("\n","")

    raise ArgumentError, 'malformed blockchain' unless block.include? '|'

    pipesets = block.split('|')
    raise ArgumentError, 'malformed blockchain' unless pipesets.length == 5

    # make sure first pipeset is valid, and going in correct numerical order
    raise ArgumentError, 'malformed blockchain' unless (ver.verify_first_pipeset(pipesets[0]) && (Integer(pipesets[0]) == counter))

    # increment the counter
    counter += 1

    # make sure the second pipeset is valid, passing previous hash
    raise ArgumentError, 'malformed blockchain' unless ver.verify_second_pipeset(pipesets[1], previous_hash.to_s)

    # make sure third pipeset is valid
    raise ArgumentError, 'malformed blockchain' unless ver.verify_third_pipeset(pipesets[2])

    # make sure fourth pipset is valid, passing previous time
    raise ArgumentError, 'malformed blockchain' unless ver.verify_fourth_pipeset(pipesets[3], previous_time.to_s)

    #set this block to the new previous time
    previous_time = pipesets[3]

    # make sure fifth pipeset is valid
    raise ArgumentError, 'malformed blockchain' unless ver.verify_fifth_pipeset(pipesets[4], block)

    #set the blocks hash to the new previous hash
    previous_hash = pipesets[4]

end
