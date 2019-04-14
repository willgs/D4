require_relative 'verifier'

# take each block into a list
filename = 'sample.txt'
blocks = IO.readlines(filename)



#initialize counter to keep track of transaction number / help with ordering
counter = 0
previous_hash = 0
previous_time = 0.0
balances = {}

# verify that each block is syntactically valid, and is a valid block in the chain
blocks.each do |block|
    
    raise ArgumentError, 'malformed blockchain' unless block.include? '|'
    pipesets = block.split('|')
    raise ArgumentError, 'malformed blockchain' unless pipesets.length == 5

    # make sure first pipeset is valid, and going in correct numerical order
    raise ArgumentError, 'malformed blockchain' unless (verify_frist_pipeset(pipesets[0]) && (pipesets[0] == counter))

    # make sure the second pipeset is valid, passing previous hash
    raise ArgumentError, 'malformed blockchain' unless verify_second_pipeset(pipesets[1], previous_hash)
    raise ArgumentError, 'malformed blockchain' unless verify_validity_of_transactions(balances, block)

    #make sure third pipeset is valid
    raise ArgumentError, 'malformed blockchain' unless verify_third_pipeset(pipesets[2])

    #make sure fourth pipset is valid, passing previous time
    raise ArgumentError, 'malformed blockchain' unless verify_fourth_pipeset(pipesets[3], previous_time)

    #make sure fifth pipeset is valid
    raise ArgumentError, 'malformed blockchain' unless verify_fifth_pipeset(pipesets[4], block)




