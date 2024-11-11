# Calculate the nth prime number, where n is supplied as a command line argument
# Usage: ./nth_prime.rb 10001

require 'prime'

# Work out the smallest number which digits sum to the given value
def smallest_number_with_digit_sum(target_sum)
  # Edge case: if the target sum is 0, the smallest number is 0.
  return 0 if target_sum == 0

  digits = []
  while target_sum > 0
    # Pick the smallest possible digit (up to 9) to get closer to target_sum
    digit = [target_sum, 9].min
    digits.unshift(digit) # Add the digit at the beginning to form the smallest number
    target_sum -= digit
  end

  digits.join.to_i
end

# Return the first prime whose digits sum to at least the given value
def prime_digit_sum(sum)
  # Work out the smallest number`` that could have the given digit sum
  start = smallest_number_with_digit_sum(sum)
  puts "Searching for prime number with digit sum >= #{sum} from #{start}"
  (start..).each do |n|
    print '.' if n % 100000 == 0
    digit_sum = n.digits.reduce(:+)
    next unless digit_sum >= sum

    puts "#{n} (#{digit_sum})"
    return n if Prime.prime?(n)
  end
end

# def prime_digit_sum(sum)
#   # Work out the smallest number that could have the given digit sum
#   Prime.each do |n|
#     # print '.' if n % 100000 == 0
#     digit_sum = n.digits.reduce(:+)
#     print "#{n} (#{digit_sum})\r"
#     return n if digit_sum >= sum
#   end
# end

answer = prime_digit_sum(ARGV[0].to_i)
puts "\nAnswer: #{answer}"

# Calculate the sum of all even Fibonacci numbers not exceeding four million."
# def sum_even_fibonacci(max)
#   a, b = 1, 1
#   sum = 0
#   while a <= max
#     sum += a if a.even?
#     a, b = b, a+b
#   end
#   sum
# end

# puts sum_even_fibonacci(4_000_000)
