module Debitcredit
  class Item < ActiveRecord::Base
    belongs_to :entry
    belongs_to :account

    attr_accessor :account_type, :user_account_id, :expires_at_date, :expires_at_time

    validates :entry, :account, presence: true
    validates :amount, numericality: {greater_than_or_equal_to: 0}

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
      self.class.new account: account, entry: entry, amount: amount, debit: credit?
    end
  end
end
