# coding: utf-8
require "fonemas/version"

module Fonemas
  require 'text/hyphen'
  require 'unicode_utils'

  def self.version
    VERSION
  end

  def self.clean(text)
    s = text.gsub(/,/,' ')
    s = s.gsub(/\s+/,' ')
    s = s.chomp.strip
    s = downcase(s)
    return s
  end
  
  def self.downcase(text)
    UnicodeUtils.downcase(text)
  end

  def self.lastVocal(word,from)
    #puts "last vocal for #{word} from #{from}"
    for i in 1..from
     # puts i
      #puts word[from-i]
      if word[from-i] =~ /[aeiou]/
        return word[from-i]
      end
    end
    return false
  end

  def self.isTonica(word,i)
    #falta considerar las palabras que poseen acento pero no tilde
    return true if word.size == 1
    tildes = %w(á é í ó ú)
    w = word.join
    if tildes.include? word[i]
      return true
    else
      es = Text::Hyphen.new(:language => "es", :left => 0, :right => 1)
      p = es.hyphenate(w)
      #puts es.visualize(w)
      hh = es.visualize(w).split("-")
      #puts hh.size
      if w =~ /[áéíóú]/
        #acento ya existe en otra silaba
        return false
      else
        #puts es.visualize(w)
        if hh.size == 1
          if lastVocal(w,w.size-1) == word[i]
            return true
          else
            return false
          end
          #monosilabos
        elsif hh.size == 2
            #agudas, se acentuan en n,s o vocal
            #puts "#{word[i]} #{i}<#{p[0]} - #{lastVocal(w,p[0])}"
            if w =~ /[nsaeiou]$/
              #termina en n s y vocal y no tiene tilde
              #por lo tanto es grave
            #  puts "#{lastVocal(w,p[0])} == #{word[i]} #{word[i].class.name}"
              if i < p[0] and lastVocal(w,p[0]) == word[i]
                return true
              else
                return false
              end
            else
              if i < p[0]
                return false
              else
                return lastVocal(w,w.size) == word[i]
              end
            end
        elsif hh.size >= 3
          #puts hh.join("-")
          if i > p[p.size-1]
            if w =~ /[nsaeiou]$/
              return false
            else
              return true
            end
          elsif i > p[p.size-2] and i <= p[p.size-1] and w =~ /[nsaeiou]$/
            return true
          else
            return false
          end
        end
      end



      return false
    end
  end

  def self.isFinal(word,i)
    return word.size == i-1
  end

  def self.isFricativa(word,i)
    fricativas = %w(f s c z j ll y g b w b v w s m b x d)
    return fricativas.include? word[i]
  end

  def self.entreVocales(word,i)
    if i == 0 or word.size - 1 == i
      return false
    else
      return (isVocal(word,i-1) and isVocal(word,i+1))
    end
  end

  def self.entreVocalyConsonante(word,i)
    return ((isVocal(word,i-1) and !isVocal(word,i+1)) or (isVocal(word,i+1) and !isVocal(word,i-1)))

  end

  def self.isVocal(word,i)
    vocales = %w(a e i o u á é í ó ú)
    return vocales.include? word[i]
  end

  def self.isDiptongo(word,first,second)
    f = word[first]
    s = word[second]
    abiertas = %w(a e o)
    cerradas = %w(i u)
    return ((abiertas.include? f and cerradas.include? s) or (abiertas.include? s and cerradas.include? f) or (cerradas.include? f and cerradas.include? s))

  end

  def self.separar(word)
    word = downcase(word)
    output = []
    i = 0
    while(i < word.length)
      if word[i] == 'c' and word[i+1] == 'h'
        output << "ch"
        i+=1
      elsif word[i] == 'l' and word[i+1] == 'l'
        output << 'll'
        i+=1
      elsif word[i] == 'r' and word[i+1] == 'r'
        output << 'rr'
        i+=1
      else
        output << word[i]
      end
      i +=1
    end
    return output
  end

  def self.fonemaLetra(letra)
    case letra
      when 'a','á' then ['aa']
      when 'b' then ['b ee']
      when 'c' then ['s ee']
      when 'd' then ['d ee']
      when 'e','é' then ['ee']
      when 'f' then ['ee f ee']
      when 'g' then ['g ee']
      when 'h' then ['aa ch e']
      when 'i','í' then ['ii']
      when 'j' then ['j oo t a']
      when 'k' then ['k aa']
      when 'l' then ['ee l e']
      when 'm' then ['ee m e']
      when 'n' then ['ee n e']
      when 'ñ' then ['ee nh e']
      when 'o','ó' then ['oo']
      when 'p' then ['p ee']
      when 'q' then ['k uu']
      when 'r' then ['ee rr ee','ee r ee']
      when 's' then ['ee s e']
      when 't' then ['t ee']
      when 'u','ú' then ['uu']
      when 'v' then ['b ee','uu b e']
      when 'w' then ['d o b l e b ee','d o b l e uu b e']
      when 'x' then ['ee k i s']
      when 'y' then ['ll ee']
      when 'z' then ['s ee t a']
      else
        raise "error, no conozco pronunciación de #{letra}"
    end
  end


  def self.fonemas(word)
    word = word.gsub(/'/,'')
    if word.size == 1
      return fonemaLetra(word)
    end
    if word.include?('_')
      output = []
      for a in word.split('_')
        if a.size > 0
          output << Fonemas.fonemas(a)
        end
      end
      return [output.join(" ")]
    end
    word = separar(word)
    fonema = []
    for i in 0..(word.length-1)
      letra = word[i]
      case letra
        when 'á' then
          fonema << 'aa'
        when 'é' then
          fonema << 'ee'
        when 'í' then
          fonema << 'ii'
        when 'ó' then
          fonema << 'oo'
        when 'ú' then
          fonema << 'uu'
        when 'a' then
          if isTonica(word,i)
            fonema << 'aa'
          else
            fonema << 'a'
          end
        when 'b','v' then
          if isVocal(word,i-1) and (word[i+1] == 'b' or word[i+1] == 'v')
            fonema << ['bb','']
          elsif i == 0 and isVocal(word,i+1)
            if word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
              fonema << ['bb','b','g']
            else
              fonema << ['bb','b']
            end
          elsif word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
            if entreVocales(word,i)
              fonema << ['b','g','']
            else
              fonema << ['bb','g']
            end
          elsif isFricativa(word,i-1)
            fonema << 'b'
          elsif isFinal(word,i)
            fonema << 'b'
          elsif entreVocales(word,i)
            fonema << ['b','']
          else
            fonema << 'bb'
          end
        when 'c' then
          if word[i+1] == 'e' or word[i+1] == 'i'
            fonema << 's'
          else
            fonema << 'k'
          end
        when 'ch' then
          if entreVocales(word,i)
            fonema << ['ch','sh','tch','j']
          else
            fonema << ['ch','sh','tch']
          end
        when 'd' then
          if i == 0 and isVocal(word,i+1)
            fonema << ['dd','d']
          elsif entreVocales(word,i) or i == word.size-1
            fonema << ['d','']
          elsif entreVocalyConsonante(word,i)
            fonema << ['dd','d']
          else
            fonema << 'd'
          end
        when 'e' then
          if isTonica(word,i)
            fonema << 'ee'
          else
            fonema << 'e'
          end
        when 'f' then
          fonema << 'f'
        when 'g' then
          if word[i+1] == 'u' and i == 0 and isTonica(word,i+2)
            #nada

          elsif word[i+1] == 'e' or word[i+1] == 'i'
            fonema << 'j'
          else
            if !entreVocales(word,i) and word[i-1] != 'n'
              fonema << 'gg'
            else
              fonema << 'g'
            end
          end
        when 'h' then
          if word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
            fonema << ['','g']
          end
          #nada
        when 'i' then
          if isTonica(word,i)
            fonema << 'ii'
          else
            fonema << 'i'
          end
        when 'j' then
          fonema << 'j'
        when 'k' then
          fonema << 'k'
        when 'l' then
          fonema << 'l'
        when 'll' then
          fonema << ['ll','lli','i']
        when 'm' then
          fonema << 'm'
        when 'n' then
          fonema << 'n'
        when 'ñ'  then
          fonema << 'nh'
        when 'o' then
          if isTonica(word,i)
            fonema << 'oo'
          else
            fonema << 'o'
          end
        when 'p' then
          fonema << 'p'
        when 'q' then
          fonema << 'k'
        when 'r' then
          if i == 0
            fonema << 'rr'
          else
            fonema << 'r'
          end
        when 'rr' then
          fonema << 'rr'
        when 's' then
          if word[i-1] == 'r' or word[i-1] == 'd' or i == word.size-1
            fonema << ['s','','h']
          elsif entreVocalyConsonante(word,i)
            fonema << ['s','h']
          elsif word[i-1] == 'b' and word[i+1] == 't'
            fonema << ['s','h']
          elsif word[i-1] == 'b'
            fonema << ['s','']
          else
            fonema << 's'
          end
        when 't' then
          fonema << 't'
        when 'ü' then
          fonema << 'u'
        when 'u' then
          if word[i-1] == 'g' and i == 1 and isTonica(word,i+1)
              fonema << ['gu']
          elsif isTonica(word,i)
              fonema << 'uu'
          else
              fonema << 'u'
          end
        when 'w' then
          if i == 0
            fonema << ['b','bb']
          elsif word[i-1] == 'o'
            fonema << 'u'
          elsif word[i+1] == 'i'
            fonema << 'u'
          else #if entreVocales(word,i)
            fonema << 'gu'
#          else
#            fonema << 'Gu'
          end
        when 'x' then
          fonema << ['ks','k','h']
        when 'y' then
          if i == word.size - 1
            fonema << 'i'
          else
            fonema << ['ll','lli','i']
          end
        when 'z' then
          if i == word.size - 1
            fonema << ['s','h','']
          else
            fonema << 's'
          end

        else
          raise "error, no conozco pronunciación de #{letra}"
      end



    end
    #puts "pre: #{fonema}"
    t =  normalize(generateFonemas(fonema))
    #puts "out: #{t}"

    #self.checkFonemas(t)

    return t
  end

  #def self.checkFonemas(p)
  #  #un ultimo chequeo de seguridad
  #  for pronunciacion in p
  #    for fonema in pronunciacion.split(" ")
  #      raise "fonema invalido" unless lista_de_fonemas.include? fonema
  #    end
  #  end
  #
  #end

  def self.generateFonemas(fonema,i=0,current=[])
      if i == fonema.length
        return current.join(' ')
      end

      c = fonema[i]
      if c.class.name == 'Array'
        output = []
        for j in c
          if j == ''
            output << generateFonemas(fonema,i+1,current)
          else
            output << generateFonemas(fonema,i+1,current + [j])
          end
        end
        return output
      else
        if c == ''
          return generateFonemas(fonema,i+1,current)
        else
          return generateFonemas(fonema,i+1,current + [c])
        end
      end

  end


  def self.normalize(t)
    @output = []
    anormalize(t)
    return @output
  end

  def self.anormalize(t)
    #puts "pre normalize: #{t}"
    if t.class.name == 'Array'
      for i in t
        anormalize(i)
      end
    else
      #puts "found #{t}"
      @output << t
    end

  end

  def self.lista_de_fonemas
    phonelist = ['SIL']
    phonelist += %w{a e i o u aa ee ii oo uu}
    phonelist += %w{bb b d e f g h i j k l m n o p q rr r s t u w ks k h gu ch tch sh dd gg ll lli nh}
    phonelist.uniq
  end


end
