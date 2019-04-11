require_relative 'verifier'
t = Verify.new

result = "FIRST TEST: " + t.verify_second_pipeset("0", "0").to_s
puts result

result = "SECOND TEST: " + t.verify_fourth_pipeset('121.99', '121.12').to_s
puts result