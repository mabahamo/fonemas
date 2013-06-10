# coding: utf-8
require "fonemas/version"

module Fonemas
  def self.clean(text)
    s = text.gsub(/,/,' ')
    s = s.gsub(/\s+/,' ')
    s = s.chomp.strip
    s = s.downcase
    return s
  end

  def self.isTonica(word,i)
    #falta considerar las palabras que poseen acento pero no tilde
    tildes = %w(á é í ó ú)
    if tildes.include? word[i]
      return true
    else
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
    if i == 0 || word.size - 1 == i
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
    return ((abiertas.include? f and cerradas.include? s) or (abiertas.include? s and cerradas.include? f))

  end

  def self.separar(word)
    word = word.downcase
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

  def self.fonemas(word)
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
        when 'b' then
          if word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
            if entreVocales(word,i)
              fonema << ['b','g','']
            else
              fonema << ['B','g']
            end
          elsif isFricativa(word,i-1)
            fonema << 'b'
          elsif isFinal(word,i)
            fonema << 'b'
          elsif entreVocales(word,i)
            fonema << ['b','']
          else
            fonema << 'B'
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
          if entreVocales(word,i) || i == word.size-1
            fonema << ['d','']
          elsif entreVocalyConsonante(word,i)
            fonema << ['D','d']
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
          if word[i+1] == 'e' or word[i+1] == 'i'
            fonema << 'j'
          else
            if !entreVocales(word,i)
              fonema << 'G'
            else
              fonema << 'g'
            end
          end
        when 'h' then
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
            fonema << 'R'
          else
            fonema << 'r'
          end
        when 'rr' then
          fonema << 'R'
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
          if word[i-1] == 'q' or word[i-1] == 'g'
            #nada
          else
            if word[i-1] == 'g' || i == 0
              fonema << 'gu'
            elsif isTonica(word,i)
              fonema << 'uu'
            else
              fonema << 'u'
            end
          end
        when 'v' then
          fonema << 'b'
        when 'w' then
          if i == 0
            fonema << ['b','B']
          elsif word[i-1] == 'o'
            fonema << 'u'
          elsif word[i+1] == 'i'
            fonema << 'u'
          elsif entreVocales(word,i)
            fonema << 'gu'
          else
            fonema << 'Gu'
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
          fonema << letra
      end



    end

    return generateFonemas(fonema)
  end

  def self.generateFonemas(fonema)
    salidas = 1
    for i in fonema
      if i.class.name == 'Array'
        salidas *= i.size
      end
    end
    #puts "salidas: #{salidas}"

    outputs = []
    for j in 1..salidas
      outputs[j-1] = []
    end
    for i in 0..(fonema.size-1)
      c = fonema[i]
      if c.class.name == 'Array'
        for j in 1..salidas
          t = c[(j-1)%c.size]
          outputs[j-1] += [t] unless t.size == 0
        end
      else
        for j in 1..salidas
          outputs[j-1] += [c]
        end
      end

    end

    salida = []
    for i in outputs
      salida << i.join(" ")
    end

    return salida
  end
end
