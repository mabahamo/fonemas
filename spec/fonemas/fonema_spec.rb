# encoding: utf-8
require 'spec_helper'
describe Fonemas do
  it 'test acentos' do
    Fonemas.fonemas('hasta').should include("aa s t a")
    Fonemas.fonemas('torta').should include("t oo r t a")
    Fonemas.fonemas('ungüento').should include("u n g u ee n t o")
    Fonemas.fonemas('abuela').should include('a g u ee l a')
    Fonemas.fonemas('aro').should include('aa r o')
    Fonemas.fonemas('bondad').should include('b o n dd aa d')
    Fonemas.fonemas('gestión').should include('j e s t i oo n')
    Fonemas.fonemas('abstraer').should include('a bb s t r a ee r')
    Fonemas.fonemas('presidida').should include('p r e s i ii d a')
    Fonemas.fonemas('guerra').should include('gu ee rr a')
    Fonemas.fonemas('buitre').should include('g u ii t r e')
    Fonemas.fonemas('huaso').should include('g u aa s o')
    Fonemas.fonemas('huevo').should include('g u ee b o')
    Fonemas.fonemas('huevo').should include('g u ee o')
    Fonemas.fonemas('huifa').should include('g u ii f a')
    Fonemas.fonemas('diente').should include('d i ee n t e')
    Fonemas.fonemas('diente').should include('dd i ee n t e')
    Fonemas.fonemas('bueno').should include('b u ee n o')
    Fonemas.fonemas('bueno').should include('bb u ee n o')
    Fonemas.fonemas('obvio').should include('oo bb b i o')
    Fonemas.fonemas('obvio').should include('oo b i o')
    Fonemas.fonemas('guerra').should_not include('ee rr a')
    Fonemas.fonemas('d').should_not include('')






    for i in Fonemas.fonemas('adskribir')
      i.should end_with('ii r')
    end
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
    Fonemas.fonemas('q').should include('c uu')
    Fonemas.fonemas('r').should include('ee rr ee')
    Fonemas.fonemas('r').should include('ee r ee')
    Fonemas.fonemas('s').should include('ee s e')
    Fonemas.fonemas('t').should include('t ee')
    Fonemas.fonemas('u').should include('uu')
    Fonemas.fonemas('v').should include('b ee')
    Fonemas.fonemas('v').should include('uu b e')
    Fonemas.fonemas('w').should include('d o b l e b ee')
    Fonemas.fonemas('w').should include('d o b l e uu v e')
    Fonemas.fonemas('x').should include('ee k i s')
    Fonemas.fonemas('y').should include('ll ee')
    Fonemas.fonemas('z').should include('z ee t a')
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

end