require 'test_helper'

class CaixaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "deve abrir o caixa com o valor inicial" do
    usuario = Usuario.new nome: "Carlos", login: "carlos@gmailcom", senha: "11111111"
    usuario.save
    caixa = Caixa.new valor_inicial: '200.0'
    assert caixa.save
  end

  test "nao deve abrir o caixa sem valor inicial" do
    usuario = Usuario.new nome: "Carlos", login: "carlos@gmailcom", senha: "11111111"
    usuario.save
    caixa = Caixa.new valor_inicial: ''
    assert_not caixa.save
  end

  test "deve fechar o caixa" do
    usuario = Usuario.new nome: "Carlos", login: "carlos@gmailcom", senha: "11111111"
    usuario.save
    caixa = Caixa.new valor_inicial: '200'
    assert caixa.save
    caixa.aberto = false
    assert caixa.update(valor_inicial: caixa.valor_inicial, valor_total: caixa.valor_total, valor_arrecadado: caixa.valor_arrecadado)
  end
end
