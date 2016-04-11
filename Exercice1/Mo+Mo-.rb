#VERSION SIMPLON : respect des consignes à la lettre

=begin

ia_number = rand(100)+1
puts "Un nombre entre 1 et 100 a été sélectionné au hasard, essayez de le trouver !"
puts "Entrez un nombre entre 1 et 100 : "
user_number = gets.to_i

tentatives = 0

while user_number != ia_number

  if user_number < ia_number
    puts "C'est plus !"
    puts "Entrez un nombre entre 1 et 100 : "
    user_number = gets.to_i
  elsif user_number > ia_number
    puts "C'est moins !"
    puts "Entrez un nombre entre 1 et 100 : "
    user_number = gets.to_i
  end
  tentatives +=1

end

  puts "Bien joué, le nombre était bien #{ia_number} !"
  puts "Vous avez trouvé en #{tentatives} fois"

=end


# VERSION MOREJ : Il faut limiter l'utilisateur !

puts "Bienvenue au Mo+ Mo-"

ia_number = rand(100)+1
puts ia_number
tentatives = 0

def get_number
  puts "Entrez un nombre entier entre 1 et 100 : "
  nb = gets.to_i
  return test_number(nb)

end

def test_number (number)
  if number != 0 && number < 101
    return number
  else
    puts "Ceci n'est pas un nombre entre 1 et 100 !!! STOP DOING SHIT"
    get_number
  end
end

def pom (user_number, ia_number, tentatives)

  while user_number != ia_number

    if user_number < ia_number
      puts "C'est plus !"
      user_number = get_number

    elsif user_number > ia_number
      puts "C'est moins !"
      user_number = get_number
    end
    tentatives += 1
  end
  tentatives += 1
  return tentatives

end


user_number = get_number
tentatives = pom user_number, ia_number, tentatives

puts "Bien joué, le nombre était bien #{ia_number} !"
puts "Vous avez trouvé en #{tentatives} fois"
