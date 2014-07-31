# coding: utf-8
require "fonemas/version"

module Fonemas
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
      #puts i
      #puts word[from-i]
      if word[from-i] =~ /[aeiou]/
        return word[from-i]
      end
    end
    return false
  end

  def self.silabar(palabra)
    #puts "silabar: #{palabra}"
    #algoritmo adaptado desde python
    #codigo original extraido desde:
    #https://github.com/xergio/silabas/blob/master/home/silabea.py
    silabas = []
    letra = 0
    salto = 0
    while silabas.join('').length  < palabra.length
      #puts "silabas antes: #{silabas}"
      #puts "letra: #{letra}"
      #puts "palabra length: #{palabra.length}"
      silaba = ''
      salto = 0
      if isConsonante(palabra[letra])
        if isInseparables(palabra[letra..letra+1])
          salto += 2
        else
          salto += 1
        end
      else
        salto += 0
      end

      #puts "salto: #{salto}"
      if isDiptongoConH(palabra,letra+salto,letra+salto+2)
        #puts "diptongo con h"
        salto += 3
      elsif isDiptongo(palabra,letra+salto,letra+salto+1)
        salto += 2
      elsif isTriptongo(palabra,letra+salto,letra+salto+2)
        salto += 3
      elsif isDieresis(palabra,letra+salto,letra+salto+1)
        salto += 2
      else
        salto += 1
      end
      #puts "acoda silaba: #{palabra[letra,letra+salto]} letra: #{letra} salto: #{salto}"

      salto += coda(palabra[letra+salto,palabra.length])

      #puts "dcoda silaba: #{palabra[letra,letra+salto]} letra: #{letra} salto: #{salto}"


      silaba = palabra[letra,salto]
      letra += salto
      silabas << silaba

      #puts "Dletra: #{letra}"
      #puts "Dsalto: #{salto}"

    end
    return silabas.join("-")
  end

  def self.isInseparables(trozo)
    #puts "isInspearable? #{trozo}"
    inseparables = %w(br bl cr cl dr fr fl gr gl kr ll pr pl tr rr ch)
    return inseparables.include? trozo
  end

  def self.coda(trozo)
    return 0 if trozo.nil?
    #puts "coda: #{trozo}"
    l = trozo.length
    if l == 0
      return 0
    elsif l == 1 and isConsonante(trozo)
      return 1
    elsif l > 1 and isInseparables(trozo[0,2])
      return 0
    elsif l > 1 and isConsonante(trozo,0) and isVocal(trozo,1)
      return 0
    elsif l > 2 and isConsonante(trozo,0) and isConsonante(trozo,1) and isVocal(trozo,2)
      return 1
    elsif l > 3 and isConsonante(trozo,0) and isInseparables(trozo[1,2]) and isVocal(trozo[3])
      return 1
    elsif l > 3 and isConsonante(trozo,0) and isConsonante(trozo,1) and isConsonante(trozo,2) and isVocal(trozo,3)
      return 2
    elsif l > 3 and isConsonante(trozo,0) and isConsonante(trozo,1) and isConsonante(trozo,2) and isConsonante(trozo,3)
      return 2
    else
      return 0
    end
  end


  def self.calcularPosicionSilabas(silabada)
    #puts "calcular posicion #{silabada}."
    output = []
    text = silabada
    while(!text.index("-").nil?)
      i = text.index("-")
      text = text.slice(0,i) + text.slice(i+1,text.length)
      output << i
    end
    return output
  end


  def self.isTonica(word,i)
    test = _isTonica(word,i)
    if test
      if _isTonica(word,i+1)
        return false
      else
        return test
      end
    else
      return false
    end
  end


  def self._isTonica(word,i)
    return false if isConsonante(word,i)
    #falta considerar las palabras que poseen acento pero no tilde
    tildes = %w(á é í ó ú ã ä ë)
    w = word.join
    #puts "isTonica? #{w}: #{i}"
    return true if w.size == 1


    if tildes.include? word[i]
      return true
    else
      g = silabar(w)
      hh = g.split("-")

      p = calcularPosicionSilabas(g)

      if hh.size == 1 and w.size > 4 and w.include? 'h' and w[0] != 'h'
        #caso johan
        p = w.index('h')
        if i < p
          return true
        else
          return false
        end
      end

      #puts hh.size
      if w =~ /[áéíóúãäë]/
        #acento ya existe en otra silaba
        return false
      else
        #puts es.visualize(w)
        if hh.size == 1
          #puts "hh size 1"
          #puts "lastVocal: #{lastVocal(w,w.size)} == #{word[i]}"
          if lastVocal(w,w.size) == word[i]
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
          #puts "hhsize3 i: #{i}, p:#{p}"
          if i >= p[p.size-1]
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

  def self.isVocal(word,i=0)
    vocales = %w(a e i o u á é í ó ú)
    return vocales.include? word[i]
  end

  def self.isConsonante(word,i=0)
    return !isVocal(word,i)
  end

  def self.isTriptongo(palabra,first,third)
    t = palabra[first,third]
    return false if t.length < 3
    triptongos = %w(iai iei uai uei uau iau uay uey)
    return triptongos.include? t
  end

  def self.isDieresis(palabra,first,second)
    t = palabra[first,second]
    return false if t.length < 2
    dieresis = %w(ue ui)
    return dieresis.include? t

  end

  def self.isDiptongo(word,first,second)
    trozo = word[first..second]
    return false if trozo.length != 2
    #puts "diptongo word #{word}, first: #{first}, second: #{second}"
    #puts "test diptongo #{word[first] + word[second]}"
    f = word[first]
    s = word[second]
    abiertas = %w(a e o á é ó)
    cerradas = %w(i u í ú)
    return ((abiertas.include? f and cerradas.include? s) or (abiertas.include? s and cerradas.include? f) or (cerradas.include? f and cerradas.include? s))

  end

  def self.isDiptongoConH(word,first,third)
    test = word[first..third]
    #puts "test diptongo con h: #{test}"
    if test[1] == 'h'
      if test[2,2] == 'ue'
        return false
      else
        test = test.gsub(/h/,'')
      end
    else
      return false
    end
    return isDiptongo(test,0,1)
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
    #cuando la palabra solo tiene una letra se usa esta pronunciación
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
      when 'y' then ['ii']
      when 'z' then ['s ee t a']
      else
        raise "error, no conozco pronunciación de #{letra}"
    end
  end

  def self.nombres(word)
    return ['j e r t s'] if word == 'hertz'
    return nil
  end

  def self.abreviacion(word)
    return "hertz" if word == 'hz'
    return "kilo hertz" if word == 'khz'
    return nil
  end


  def self.fonemas(word)
    if word.include? ' '
      output = []
      for i in word.split(" ")
        output << Fonemas.fonemas(i)[0]
      end
      return [ output.join(" ") ]
    end
    return self.fonemas(abreviacion(word)) unless abreviacion(word).nil?
    return self.nombres(word) unless self.nombres(word).nil?
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
        when 'a','á','ä','ã' then
          if isTonica(word,i) and word[i+1] == 'y' and word[i+2] == 'l'
            fonema << 'ee'
          elsif isTonica(word,i)
            fonema << 'aa'
          else
            fonema << 'a'
          end
        when 'b','v' then
          if isVocal(word,i-1) and (word[i+1] == 'b' or word[i+1] == 'v')
            fonema << ['b','']
          elsif i == 0 and isVocal(word,i+1)
            if word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
              fonema << ['b','g']
            else
              fonema << ['b']
            end
          elsif word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
            if entreVocales(word,i)
              fonema << ['b','g','']
            else
              fonema << ['b','g']
            end
          elsif isFricativa(word,i-1)
            fonema << 'b'
          elsif isFinal(word,i)
            fonema << 'b'
          elsif entreVocales(word,i)
            fonema << ['b','']
          else
            fonema << 'b'
          end
        when 'c' then
          if word[i+1] == 'e' or word[i+1] == 'i' or word[i+1] == 'í' or word[i+1] == 'é'
            fonema << 's'
          else
            fonema << 'k'
          end
        when 'ch' then
          if entreVocales(word,i)
            #fonema << ['ch','sh','tch','j']
            fonema << 'ch'
          else
            fonema << 'ch'
            #fonema << ['ch','sh','tch']
          end
        when 'd' then
          if i == 0 and isVocal(word,i+1)
            fonema << ['d']
          elsif entreVocales(word,i) or i == word.size-1
            fonema << ['d','']
          elsif entreVocalyConsonante(word,i)
            fonema << ['d']
          else
            fonema << 'd'
          end
        when 'e','é','ë' then
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
              fonema << 'g'
            else
              fonema << 'g'
            end
          end
        when '-' then
          if i == 0 or i == word.size - 1
            #nada
          else
            raise "no se como pronunciar - en #{word}"
          end
        when 'h' then
          if word[i+1] == 'u' and isDiptongo(word,i+1,i+2)
            fonema << ['','g']
          elsif i > 0 and word[i-1] == 'o' and word[i+1] == 'a'
            fonema << 'j'
          end
          #nada
        when 'i','í' then
          if isTonica(word,i)
            fonema << 'ii'
          else
            fonema << 'i'
          end
        when 'j' then
          if i == 0 and word[i+1] == 'o' and (word[i+2] == 'ã' or word[i+2] == 'h')
            fonema << 'll'
          else
            fonema << 'j'
          end
        when 'k' then
          fonema << 'k'
        when 'l' then
          fonema << 'l'
        when 'll' then
          #fonema << ['ll','lli','i']
          fonema << ['ll','i']
        when 'm' then
          fonema << 'm'
        when 'n' then
          fonema << 'n'
        when 'ñ'  then
          fonema << 'nh'
        when 'o','ó' then
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
          if word[i-1] == 'd' or i == word.size-1
          #if word[i-1] == 'r' or word[i-1] == 'd' or i == word.size-1
            #fonema << ['s','','h']
            fonema << ['s','']
          elsif entreVocalyConsonante(word,i)
            #fonema << ['s','h']
            fonema << 's'
          elsif word[i-1] == 'b' and word[i+1] == 't'
            #fonema << ['s','h']
            fonema << 's'
          elsif word[i-1] == 'b'
            fonema << ['s','']
          else
            fonema << 's'
          end
        when 't' then
          fonema << 't'
        when 'ü' then
          fonema << 'u'
        when 'u','ú' then
          if word[i-1] == 'q'
            #nada
          elsif word[i-1] == 'g' and i == 1 and isTonica(word,i+1)
            if word[i+1] == 'e'
              fonema << 'g'
            else
              fonema << [['g','u']]
            end
          elsif isTonica(word,i)
              fonema << 'uu'
          else
              fonema << 'u'
          end
        when 'w' then
          if word[i-1] == 'l'
            fonema << [['g','u']]
          elsif i == 0 and word[i+1] == 'e'
            fonema << ['u']
          elsif i == 0
            fonema << ['b']
          elsif word[i-1] == 'o'
            fonema << 'u'
          elsif word[i+1] == 'i'
            fonema << 'u'
          else #if entreVocales(word,i)
            fonema << [['g','u']]
#          else
#            fonema << 'Gu'
          end
        when 'x' then
          if i == 0 and word[i+1] == 'a'
            fonema << 'j'
          elsif i== 0 and word[i+1] == 'i'
            fonema << 's'
          else
            fonema << [['k','s']]
          end
          #fonema << ['ks','k','h']
          #fonema << ['ks','k']
        when 'y' then
          if i == word.size - 1
            fonema << 'i'
          elsif word[i+1] == 'l'
            fonema << 'i'
          else
            #fonema << ['ll','lli','i']
            fonema << 'll'
          end
        when 'z' then
          if i == word.size - 1
            #fonema << ['s','h','']
            fonema << ['s','']
          else
            fonema << 's'
          end

        else
          raise "error, no conozco pronunciación de #{letra} en #{word}"
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
    phonelist += %w{b d e f g i j k l m n o p rr r s t u k ch ll nh}
    phonelist << '++RUIDO++'
    phonelist.uniq
  end


end
