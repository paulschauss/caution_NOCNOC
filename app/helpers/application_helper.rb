module ApplicationHelper
  ## recuperer le montant de la caution
  # def get_amount(caution)
  #   caution.split(' ').filter { |word| word.chars.include?("€") }.first.chars.delete_if { |c| c == "€" }.join.gsub(",", ".").to_f if caution.include?("€")
  # end

  def get_amount(caution)
    result = caution.split(' ').filter { |word| word[0..-2] == word[0..-2].to_i.to_s }.filter { |number| number.length >= 3}.first.to_i
    result == 0 ? 1000 : result
  end

  def get_phone(phone)
    phone_without_space = phone.chars.delete_if { |c| c == " " }.join
    phone_without_space.chars[0..2].join == "+33" ? "0#{phone_without_space[3..-1]}" : phone_without_space
  end

  def get_image_url(image_url)
    image_url.chars[2..-1].join
  end

  # get_image_url("//l.icdbcdn.com/oh/0f987734-d443-40da-877c-f8c426e79de2.jpg?f=32")

end
