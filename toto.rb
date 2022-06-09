# def get_amount(caution)
#   caution.split(' ').filter { |word| word.chars.include?("€") }.first.chars.delete_if { |c| c == "€" }.join.gsub(",", ".").to_f if caution.include?("€")
# end

def get_amount(caution)
  result = caution.gsub(",", ".").split.filter { |word| Float(word[0..-2]).to_s.length >= 4 rescue false }.reject { |num| num.chars.include?(":") }.first.to_i
  result == 0 ? "#{1000} not ok" : "#{result} ok"
end

def get_phone(phone)
  phone_without_space = phone.chars.delete_if { |c| c == " " }.join
  phone_without_space.chars[0..2].join == "+33" ? "0#{phone_without_space[3..-1]}" : phone_without_space
end

def get_image_url(image_url)
  image_url.chars[2..-1].join
end

# p get_image_url("//l.icdbcdn.com/oh/0f987734-d443-40da-877c-f8c426e79de2.jpg?f=32")

p get_amount("Caution 1000: 1078,82€ sous 5 jours")
p get_amount("Caution 2: 1078,82€ sous 5 jours")
p get_amount("Caution 1200")
p get_amount("1000 CAUTION")
p get_amount("Politique Lyon (remboursement 5 jours) caution 1500€")
p get_amount("Caution 1000: 1078.82€ sous 5 jours")

p get_amount("N/D")

# p get_phone("+33 6 82 48 19 37")
# p get_phone("+33707070707")
# p get_phone("0613653334")
# p get_phone("447952480853")
