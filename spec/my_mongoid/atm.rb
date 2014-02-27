require "active_support"

class Account
  attr_reader :balance
  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end

  def valid_access?
    true
  end
end

class ATM
  attr_reader :account
  def initialize(account)
    @account = account
  end
end

module ATM::Commands

  def withdraw(amount)
    account.withdraw(amount)
    -amount
  end

  def deposit(amount)
    account.deposit(amount)
    #amount
  end
end

module ATM::Authentication
  extend ActiveSupport::Concern

  def valid_access?
    @account.valid_access?
  end
end

module ATM::Logging
  extend ActiveSupport::Concern

  def log(msg)
    puts msg
  end
end

module ATM::SMSNotification
  extend ActiveSupport::Concern

  def send_sms(msg)
    puts "#fake send {mag}"
  end
end

module ATM::Concerns
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Callbacks
    include ATM::Commands
    include ATM::Authentication
    include ATM::Logging
    include ATM::SMSNotification
  end

end

class ATM
  include ATM::Concerns
  define_callbacks :command


   def withdraw(amount)
    run_callbacks :command do
      ATM::Commands.withdraw(amount)
    end
  end

  def deposit(amount)
    run_callbacks :command do
      ATM::Commands.deposit(amount)
    end
  end

  set_callback :command, :around do |object|
    log("#{@account.balance}")
  end

  set_callback :command, :after do |object|
    send_sms("#{@account.balance}")
  end

  set_callback :command, :before do |object|
    valid_access?
  end

end

atm = ATM.new(Account.new(200))
