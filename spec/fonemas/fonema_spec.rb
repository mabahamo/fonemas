# encoding: utf-8
require 'spec_helper'
describe Fonemas do
  it 'test acentos' do
    Fonemas.fonemas('hasta').should include("aa s t a")
    Fonemas.fonemas('torta').should include("t oo r t a")
    Fonemas.fonemas('ungüento').should include("u n g u ee n t o")
    Fonemas.fonemas('abuela').should include('a g u ee l a')
    Fonemas.fonemas('aro').should include('aa r o')
    Fonemas.fonemas('bondad').should include('b o n D aa d')
    Fonemas.fonemas('gestión').should include('j e s t i oo n')
    Fonemas.fonemas('abstraer').should include('a B s t r a ee r')
    Fonemas.fonemas('presidida').should include('p r e s i ii d a')
    Fonemas.fonemas('guerra').should include('gu ee R a')
    Fonemas.fonemas('buitre').should include('g u ii t r e')
    Fonemas.fonemas('huaso').should include('g u aa s o')
    Fonemas.fonemas('huevo').should include('g u ee b o')
    Fonemas.fonemas('huevo').should include('g u ee o')
    Fonemas.fonemas('huifa').should include('g u ii f a')
    Fonemas.fonemas('diente').should include('d i ee n t e')
    Fonemas.fonemas('diente').should include('D i ee n t e')
    Fonemas.fonemas('bueno').should include('b u ee n o')
    Fonemas.fonemas('bueno').should include('B u ee n o')
    Fonemas.fonemas('obvio').should include('oo B b i o')
    Fonemas.fonemas('obvio').should include('oo b i o')
    Fonemas.fonemas('guerra').should_not include('ee R a')
    Fonemas.fonemas('d').should_not include('')
    Fonemas.fonemas('d').should include('d e')






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