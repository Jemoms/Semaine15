class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    if @en_vie
      return "#{@nom} (#{@points_de_vie}/100)"   # - Renvoie le nom et les points de vie si la personne est en vie
    else
      return "#{@nom} (vaincu)"    # - Renvoie le nom et "vaincu" si la personne a été vaincue
    end
  end

  def attaque(personne)
    puts "#{@nom} attaque #{personne.nom}"   # - Affiche ce qu'il s'est passé
    personne.subit_attaque(degats)    # - Fait subir des dégats à la personne passée en paramètre
  end

  def subit_attaque(degats_recus)

    @points_de_vie -= degats_recus # - Réduit les points de vie en fonction des dégats reçus
    puts "#{@nom} subit #{degats_recus} HP de dégats !"# - Affiche ce qu'il s'est passé

    if @points_de_vie <= 0 && @en_vie # - Détermine si la personne est toujours en_vie ou non
      @en_vie = false
      puts "#{@nom} a été vaincu."
    elsif @points_de_vie <=0 && !@en_vie # - Détermine si la personne est morte et si elle se fait taper malgré cela.
      puts "#{@nom} est déjà mort, est-il vraiment nécessaire de s'acharner sur son cadavre ?"
    end
    @points_de_vie
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    if @degats_bonus != 0
      puts "#{@nom} profite de #{@degats_bonus} points de dégats bonus" # - Affiche ce qu'il s'est passé
    else
      puts "#{@nom} ne profite pas de points de dégats bonus"
    end
    rand(50) + 10 + @degats_bonus# - Calculer les dégats
  end

  def soin
    points_de_vie_test = @points_de_vie += rand(30) + 10
      if points_de_vie_test  > 100   # Ajout d'une condition pour ne pas dépasser les 100HP (max)
        @points_de_vie = 100
      else
        @points_de_vie = points_de_vie_test # - Gagner de la vie
      end
    puts "#{@nom} regagne de la vie" # - Affiche ce qu'il s'est passé
  end

  def ameliorer_degats
    @degats_bonus += rand(15) + 10  # - Augmenter les dégats bonus
    puts "#{@nom} gagne en puissance !" # - Affiche ce qu'il s'est passé
  end
end

class Ennemi < Personne
  def degats
    rand(10) + 1 # - Calculer les dégats
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    if !joueur.en_vie || monde.ennemis_en_vie.size == 0 # - Déterminer la condition de fin du jeu
      return true
    else
      return false
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    @ennemis.select do |ennemi| # - Ne retourner que les ennemis en vie
      ennemi.en_vie
    end
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

# - Afficher le résultat de la partie
if joueur.en_vie && monde.ennemis_en_vie.size == 0
  puts "Vous avez gagné !\n #{joueur.info}"
elsif joueur.en_vie && monde.ennemis_en_vie.size != 0
  puts "Vous avez abandonné la partie avant la fin !"
  puts "#{joueur.info}"
  puts "#{monde.ennemis[0].info}"
  puts "#{monde.ennemis[1].info}"
  puts "#{monde.ennemis[2].info}"
else
  puts "Vous avez perdu !\n #{joueur.info}"
end
