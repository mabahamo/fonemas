# encoding: utf-8
require 'spec_helper'
describe Fonemas do
  it 'test acentos' do
    Fonemas.fonemas('hasta')[0].should eql("aa s t a")
    Fonemas.fonemas('torta')[0].should eql("t oo r t a")
    Fonemas.fonemas('ungüento')[0].should eql("u n g u ee n t o")
    Fonemas.fonemas('abuela').should include('a g u ee l a')
    Fonemas.fonemas('aro').should include('aa r o')
    Fonemas.fonemas('bondad').should include('b o n D aa d')
    Fonemas.fonemas('gestión').should include('j e s t i oo n')
    Fonemas.fonemas('abstraer').should include('a B s t r a ee r')
    Fonemas.fonemas('presidida').should include('p r e s i ii d a')

    for i in Fonemas.fonemas('adskribir')
      i.should end_with('ii r')
    end
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