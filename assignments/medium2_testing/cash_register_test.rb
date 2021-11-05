# Create tests for methods in both cash_register.rb and transaction.rb

require 'minitest/autorun'

require_relative 'cash_register'
require_relative 'transaction'

class CashRegisterTest < MiniTest::Test
  def test_accept_money
    register1 = CashRegister.new(100)
    transaction1 = Transaction.new(10)
    transaction1.amount_paid = 10

    assert_equal(110, register1.accept_money(transaction1))
  end

  def test_change
    transaction2 = Transaction.new(30)
    transaction2.amount_paid = 30
    assert_equal(0, CashRegister.new(100).change(transaction2))
  end

  def test_give_receipt
    register2 = CashRegister.new(100)
    transaction2 = Transaction.new(15)

    assert_nil(register2.give_receipt(transaction2))

    assert_output("You've paid $15.\n") do
      register2.give_receipt(transaction2)
    end
  end
end