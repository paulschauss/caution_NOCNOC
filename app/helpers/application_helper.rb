module ApplicationHelper
  ## recuperer le montant de la caution
  def get_amount(caution)
    caution.split(' ').filter { |word| word.chars.include?("€") }.to_s.chars.filter { |c| c == c.to_i.to_s }.join.to_i
  end
end
