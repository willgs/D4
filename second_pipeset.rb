# Verify second pipe
class Verify
  def verify_second_pipeset(second_pipeset, previous_hash)
    # Error return values: 1 is incorrect syntax
    return 1 if !previous_hash.match(/\A[a-z0-9]*\z/) || previous_hash.empty? || previous_hash.length > 4
    # Error return values: 2 is hash value mismatch
    return 2 if second_pipeset != previous_hash

    # Success
    0
  end
end