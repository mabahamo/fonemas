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

    for i in Fonemas.fonemas('adskribir')
      i.should end_with('ii r')
    end
  end

end