def get_amount(caution)
  caution.split(' ').filter { |word| word.chars.include?("€") }.first.chars.delete_if { |c| c == "€" }.join.gsub(",", ".").to_f
end

def undegueuify(image_url)
  image_url.chars[2..-1].join
end

p undegueuify("//l.icdbcdn.com/oh/0f987734-d443-40da-877c-f8c426e79de2.jpg?f=32")

p get_amount("Caution 2: 1000,82€ sous 5 jours")
