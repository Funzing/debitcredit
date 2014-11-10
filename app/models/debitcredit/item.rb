module Debitcredit
  class Item < ActiveRecord::Base
    belongs_to :transaction, class_name: "Debitcredit::Transaction", foreign_key: "transaction_id"
    belongs_to :account, class_name: "Debitcredit::Account", foreign_key: "account_id"

    validate :transaction, :account, presence: true
    validate :amount, numericality: true, greater_than_or_equal_to: 0
    
    attr_accessor :account_type, :user_account_id, :expires_at_date, :expires_at_time

    scope :debit, ->{where(debit: true)}
    scope :credit, ->{where(debit: false)}

    def credit?
      !debit?
    end

    def value_for_balance
      credit?? amount : -amount
    end

    def kind
      debit?? :debit : :credit
    end

    def inverse
      self.class.new account: account, transaction: transaction, amount: amount, debit: credit?
    end
  end
end
