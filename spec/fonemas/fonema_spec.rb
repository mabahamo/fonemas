# encoding: utf-8
require 'spec_helper'
describe Fonemas do
  it 'test acentos'  do
    Fonemas.fonemas('hasta').should include("aa s t a")
    Fonemas.fonemas('torta').should include("t oo r t a")
    Fonemas.fonemas('ungüento').should include("u n g u ee n t o")
    Fonemas.fonemas('abuela').should include('a g u ee l a')
    Fonemas.fonemas('aro').should include('aa r o')
    Fonemas.fonemas('bondad').should include('b o n d aa d')
    Fonemas.fonemas('gestión').should include('j e s t i oo n')
    Fonemas.fonemas('abstraer').should include('a b s t r a ee r')
    Fonemas.fonemas('presidida').should include('p r e s i ii d a')
    Fonemas.fonemas('guerra').should include('g ee rr a')
    Fonemas.fonemas('buitre').should include('g u ii t r e')
    Fonemas.fonemas('huaso').should include('g u aa s o')
    Fonemas.fonemas('huevo').should include('g u ee b o')
    Fonemas.fonemas('huevo').should include('g u ee o')
    Fonemas.fonemas('huifa').should include('g u ii f a')
    Fonemas.fonemas('diente').should include('d i ee n t e')
   # Fonemas.fonemas('diente').should include('dd i ee n t e')
    Fonemas.fonemas('bueno').should include('b u ee n o')
    #Fonemas.fonemas('bueno').should include('bb u ee n o')
    #Fonemas.fonemas('obvio').should include('oo bb b i o')
    Fonemas.fonemas('obvio').should include('oo b i o')
    Fonemas.fonemas('guerra').should_not include('ee rr a')
    Fonemas.fonemas('d').should_not include('')
    Fonemas.fonemas('dé').should include('d ee')
    Fonemas.fonemas('guatón').should include('g u a t oo n')
    Fonemas.fonemas('gu').should include('g uu')
    Fonemas.fonemas('guagua').should include('g u aa g u a')
    Fonemas.fonemas('johan').should include('ll oo j a n')
    Fonemas.fonemas('adquirir').should include('a d k i r ii r')
    for i in Fonemas.fonemas('adskribir')
      i.should end_with('ii r')
    end
    Fonemas.fonemas('alcancía').should include('a l k a n s ii a')
    Fonemas.fonemas('aproximadamente').should include('a p r o k s i m a d a m ee n t e')
    Fonemas.fonemas('aproximadamente').should_not include('a p r o k i m a d a m ee n t e')
    Fonemas.fonemas('software').should include('s o f t g u aa r e')
    Fonemas.fonemas('llamémosla').should include('ll a m ee m o s l a')

  end



  it 'lista fonemas utilizados' do
    words = %w{hasta ungüento huifa obvio guerra chile sexo mañana}
    for w in words
      fs = Fonemas.fonemas(w)
      for pronunciacion in fs
        p = pronunciacion.split(' ')
        for fonema in p
          Fonemas.lista_de_fonemas.should include(fonema)
        end
      end
    end


  end
  
  it 'soporta mayúsculas acentuadas' do
    Fonemas.fonemas('África').should include('aa f r i k a')
  end

  it 'palabras deletreadas' do
    Fonemas.fonemas('_a_b_c').should be_a_kind_of(Array)
    Fonemas.fonemas('_a_b_c').should include('aa b ee s ee')
    Fonemas.fonemas('_a').should include('aa')
  end

  it 'letras' do
    Fonemas.fonemas('h').should include('aa ch e')
    Fonemas.fonemas('a').should include('aa')
    Fonemas.fonemas('b').should include('b ee')
    Fonemas.fonemas('c').should include('s ee')
    Fonemas.fonemas('d').should include('d ee')
    Fonemas.fonemas('e').should include('ee')
    Fonemas.fonemas('f').should include('ee f ee')
    Fonemas.fonemas('g').should include('g ee')
    Fonemas.fonemas('h').should include('aa ch e')
    Fonemas.fonemas('i').should include('ii')
    Fonemas.fonemas('j').should include('j oo t a')
    Fonemas.fonemas('k').should include('k aa')
    Fonemas.fonemas('l').should include('ee l e')
    Fonemas.fonemas('m').should include('ee m e')
    Fonemas.fonemas('n').should include('ee n e')
    Fonemas.fonemas('ñ').should include('ee nh e')
    Fonemas.fonemas('o').should include('oo')
    Fonemas.fonemas('p').should include('p ee')
    Fonemas.fonemas('q').should include('k uu')
    Fonemas.fonemas('r').should include('ee rr ee')
    Fonemas.fonemas('r').should include('ee r ee')
    Fonemas.fonemas('s').should include('ee s e')
    Fonemas.fonemas('t').should include('t ee')
    Fonemas.fonemas('u').should include('uu')
    Fonemas.fonemas('v').should include('b ee')
    Fonemas.fonemas('v').should include('uu b e')
    Fonemas.fonemas('w').should include('d o b l e b ee')
    Fonemas.fonemas('w').should include('d o b l e uu b e')
    Fonemas.fonemas('x').should include('ee k i s')
    Fonemas.fonemas('y').should include('ii')
    Fonemas.fonemas('z').should include('s ee t a')
    Fonemas.fonemas('é').should include('ee')
  end

  it 'test diptongos' do
    Fonemas.isDiptongo("buitre",1,2).should be(true)
  end

  it 'combinar fonemas' do
    test = ['a',['b','c'],['d','e']]
    output = Fonemas.normalize(Fonemas.generateFonemas(test))
    output.should include('a b d')
    output.should include('a b e')
    output.should include('a c d')
    output.should include('a c e')
  end

  it 'debe saber separar silabas' do
    Fonemas.silabar('áfrica').should eql('á-fri-ca')
    Fonemas.silabar('abstraer').should eql('abs-tra-er')
    Fonemas.silabar('ahuyentar').should eql('ahu-yen-tar')
    Fonemas.silabar('acaban').should eql('a-ca-ban')
    Fonemas.silabar('pino').should eql('pi-no')
    Fonemas.silabar('camión').should eql('ca-mión')
    Fonemas.silabar('holanda').should eql('ho-lan-da')
    Fonemas.silabar('abuela').should eql('a-bue-la')

  end

  it 'marcar inicios de cada silaba' do
    Fonemas.calcularPosicionSilabas('ho-lan-da').should eql([2,5])
  end

  it 'identificar sílaba tónica' do
    word = Fonemas.separar('acaban')
    Fonemas.isTonica(word,0).should eql(false)
    Fonemas.isTonica(word,2).should eql(true)
    Fonemas.isTonica(word,4).should eql(false)

  end

  it 'sólo debe existir una sílaba acentuada' do
    fonemas = Fonemas.fonemas('acaban')
    fonemas.should_not include('aa k aa b a n')
    fonemas.should include('a k aa b a n')
  end

  it 'no caemos con nada' do
    Fonemas.fonemas('confech')
  end

  it 'nombres propios proseen su propias reglas' do
    Fonemas.fonemas('hertz')[0].should eql('j e r t s')
    Fonemas.fonemas('aylwin').should_not include("aa ll l u i n")
    Fonemas.fonemas('aylwin').should include("ee i l g u i n")
    Fonemas.fonemas('xavier').should_not include('ks a b i ee r')
    Fonemas.fonemas('xavier').should include('j a b i ee r')


  end

  it 'soporta abreviaciones' do
    Fonemas.fonemas('hz')[0].should eql(Fonemas.fonemas('hertz')[0])
    Fonemas.fonemas('khz').should include('k ii l o j e r t s')
  end

  it 's debe pronunciarse' do
    Fonemas.fonemas('concurso').should include('k o n k uu r s o')
    Fonemas.fonemas('concurso').should_not include('k o n k uu r o')

  end

  it 'letra w' do
    Fonemas.fonemas('web').should include('g u ee b')
    Fonemas.fonemas('will').should include('g u i l')
    Fonemas.fonemas('william').should include('g u i l i aa m')


  end



  it 'palabras esdrújulas' do
    silabas = Fonemas.silabar('llamémosla')
    silabas.split("-").size.should eql(4)
    word = Fonemas.separar('llamémosla')
    word[0].should eql('ll')
    word[3].should eql('é')
    Fonemas.isConsonante(word,3).should eql(false)
    Fonemas._isTonica(word,3).should eql(true)
    Fonemas.isTonica(word,3).should eql(true)
  end

  it 'debe soportar palabras parciales' do

    Fonemas.fonemas('concur-').should include('k o n k u r')
    Fonemas.fonemas('-curso').should include('k uu r s o')

  end

  it 'debe caerse con guiones entre medio' do

    expect { Fonemas.fonemas('a-b') }.to raise_error


  end


end