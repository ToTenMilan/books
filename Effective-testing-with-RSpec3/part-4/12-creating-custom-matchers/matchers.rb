#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
# We disable line length because the labels cause lines to be too long
# but they do not render in the book so it causes no problems.
# rubocop:disable Metrics/LineLength
#---
class HaveABalanceOf 
  include RSpec::Matchers::Composable 

  def initialize(amount) 
    @amount = amount
  end

  def as_of(date) 
    @as_of_date = date
    self
  end


  def matches?(account) 
    @account = account
    values_match?(@amount, account_balance)
  end

  def description 
    if @as_of_date
      "have a balance of #{description_of(@amount)} as of #{@as_of_date}"
    else
      "have a balance of #{description_of(@amount)}"
    end
  end

  def failure_message 
    "expected #{@account.inspect} to #{description}" + failure_reason
  end

  def failure_message_when_negated 
    "expected #{@account.inspect} not to #{description}" + failure_reason
  end

private

  def failure_reason
    ", but had a balance of #{account_balance}"
  end

  def account_balance
    if @as_of_date
      @account.balance_as_of(@as_of_date)
    else
      @account.current_balance
    end
  end
end

module AccountMatchers
  def have_a_balance_of(amount)
    HaveABalanceOf.new(amount)
  end
end

RSpec.configure do |config|
  config.include AccountMatchers
end
# rubocop:enable Metrics/LineLength

RSpec::Matchers.alias_matcher :an_account_with_a_balance_of,
                              :have_a_balance_of



RSpec::Matchers.define :have_a_balance_of do |amount|
  chain(:as_of) { |date| @as_of_date = date } 
  match { |account| account_balance(account) == amount } 
  failure_message { |account| super() + failure_reason(account) }
  failure_message_when_negated { |account| super() + failure_reason(account) }

private

  def failure_reason(account)
    ", but had a balance of #{account_balance(account)}" 
  end

  def account_balance(account) 
    if @as_of_date
      account.balance_as_of(@as_of_date)
    else
      account.current_balance
    end
  end
end
# rubocop:enable Metrics/LineLength

RSpec::Matchers.alias_matcher :an_account_with_a_balance_of,
                              :have_a_balance_of


RSpec.describe 'test' do
  it 'tests' do
    expect​(account).to have_a_balance_of(30)
  end
end