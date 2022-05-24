
def get_amount(caution)
  caution.split(' ').filter { |word| word.chars.include?("€") }.first.chars.delete_if { |c| c == "€" }.join.gsub(",", ".").to_f

end

a = get_amount("Caution 2: 1000,82€ sous 5 jours")
p a
