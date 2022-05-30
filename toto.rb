# def get_amount(caution)
#   caution.split(' ').filter { |word| word.chars.include?("€") }.first.chars.delete_if { |c| c == "€" }.join.gsub(",", ".").to_f if caution.include?("€")
# end

def get_amount(caution)
  result = caution.split(' ').filter { |word| word[0..-2] == word[0..-2].to_i.to_s }.filter { |number| number.length >= 3}.first.to_i
  result == 0 ? 1000 : result
end

p get_amount("N/D")
