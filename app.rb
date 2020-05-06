require 'fileutils'

def authenticateCustomer
  puts "Please enter your account number"
  account_number = gets.chomp()
  puts "Please enter your pin"
  pin = gets.chomp()

  # check the pre-defined staff in a file called staff.txt and verify that the username and pin are correct.
  File.open('./customer.txt', 'r') do |file|

    # Return array of lines in file
    for line in file.readlines()
      list = line.split(",")
      if list[4] == account_number and list[5].include?(pin)
        # Login Successful, send user to bank
        bank(account_number)
        return
      end
    end
    puts "Your account number or pin is incorrect."
  end  
end


def authenticateStaff
  puts "Please enter your username"
  username = gets.chomp()
  puts "Please enter your password"
  password = gets.chomp()

  # check the pre-defined staff in a file called staff.txt and verify that the username and password are correct.
  File.open('./staff.txt', 'r') do |file|

    # Return array of lines in file
    for line in file.readlines()
      list = line.split(",")
      if list[4] == username and list[5] == password
        # Login Successful, send user to bank
        bank()
        return
      end
    end
    puts "Your username or password is incorrect."
  end  
end

def bank(account_number)
  #  Create a new file to store user sessions
  File.write('./user_session.txt', 'w') do |file|
  end  
  puts "You are on the main menu"
  puts "Enter 1 to check account balance"
  puts "Enter 2 to make a deposit"
  puts "Enter 3 to make a withdrawal"
  puts "Enter 4 to log out"
  option = gets.chomp()

  if option == "1"
    checkAccount(account_number)
  elsif option == '2'
    makeDeposit(account_number)
  elsif option == '3'
    makeWithdrawal(account_number)
  elsif option == "4"
    # Delete the user sessions file
    File.open('./user_session.txt', 'r') do |file|
      File.delete(file)
    end
    puts "You are logged out"
    return
  end
end

def createAccount
  puts "Please enter an account name"
  account_name = gets.chomp()
  puts "Please enter an opening balance"
  opening_balance = gets.chomp()
  while opening_balance.scan(/\D/).empty? === false
    puts "You entered an invalid character. Only digits are allowed. Please try again"
    puts opening_balance = gets.chomp()
    end
  puts "Please enter an account type"
  puts "The options are either savings or current"
  account_type = gets.chomp()
  while account_type != "savings" and account_type != "current"
    puts "You entered an invalid account type. Please ty again"
    account_type = gets.chomp()
  end
  puts "please enter your email address"
  email = gets.chomp()
  customer_pin = createCustomerPin()
  

  #  Generate a random 10 digit account number for user
  account_number = ""
  while account_number.length < 11
      num = rand(0..9).to_s
      account_number += num   
  end

  #  save above information to the customer.txt file
  File.open('./customer.txt', 'a+') do |file|

    file.write("\n" + account_name + "," + opening_balance + "," + account_type + "," + email + "," + account_number + "," + customer_pin)
  end 

  #  show user the new account number
  puts "You have successfully created a new bank account"
  puts "Your new account number is " + account_number
  puts "You will now be redirected to the main menu for the new account created"
  bank(account_number)
end

def createCustomerPin
  puts "Please enter your preferred pin"
  puts "Please note the following"
  puts "Only digits are allowed. You can't use letters or special characters"
  puts "The minimum length allowed for the new pin is 4 digits"
  puts "The maximum length allowed for the new pin is 6 digits"

  customerPin = gets.chomp()
  while customerPin.length > 6 or customerPin.length < 4 or customerPin.scan(/\D/).empty? === false
    if customerPin.length > 6 or customerPin.length < 4
      puts "Please ensure the length of your pin is greater than 4 but not more that 6 digits. Please try again."
      customerPin = gets.chomp()
    end
    if customerPin.scan(/\D/).empty? === false
      puts "Your pin must contain only digits. Please try again."
      customerPin = gets.chomp()
    end
  end
  return customerPin
end

def checkAccount(account_number)
  # Fetch account details of account from customer.txt and display to user
  File.open('./customer.txt', 'r') do |file|
    # Return array of lines in file
    for line in file.readlines()
      #  Query that line for the opening balance
      if line.include? account_number
        list = line.split(",")
        account_balance = list[1]
        puts "Dear " + list[0] + ",your account balance is NGN" + account_balance
        bank(account_number)
        break
        return
      end
    end
  end
end


def makeDeposit(account_number)
  # Fetch account details of account from customer.txt and display to user
  puts "Please enter the amount of money in Naira that you want to deposit"
  puts "Note that only digit are allowed"
  puts deposit = gets.chomp()
  while deposit.scan(/\D/).empty? === false
  puts "You entered an invalid character. Only digits are allowed. Please try again"
  puts deposit = gets.chomp()
  end
  File.open('./customer.txt', 'r') do |file|
    File.open('./customer.txt.tmp', 'w') do |f2|
      # Return array of lines in file
      for line in file.readlines()
        #  Query that line for the opening balance
        f2.write(line) unless line.include? account_number
        if line.include? account_number
          list = line.split(",")
          begin
            list[1] = list[1].to_i + deposit.to_i
          rescue => exception
            puts "Division by zero error"
          end
          puts "Account deposit was successful"
          puts "Your account balance has been increased by NGN" + deposit.to_s + " to NGN" + list[1].to_s
          puts "You will now be redirected to the main menu"
          new_line = list.join(',')
          f2.write("\n", new_line)
        end
      end
    end
  end
  FileUtils.mv './customer.txt.tmp', './customer.txt'
  bank(account_number)
end

def makeWithdrawal(account_number)
  # Fetch account details of account from customer.txt and display to user
  puts "Please enter the amount of money in Naira that you want to withdraw"
  puts "Note that only digit are allowed"
  puts withdraw = gets.chomp()
  while withdraw.scan(/\D/).empty? === false
  puts "You entered an invalid character. Only digits are allowed. Please try again"
  puts withdraw = gets.chomp()
  end
  File.open('./customer.txt', 'r') do |file|
    File.open('./customer.txt.tmp', 'w') do |f2|
      # Return array of lines in file
      for line in file.readlines()
        #  Query that line for the opening balance
        f2.write(line) unless line.include? account_number
        if line.include? account_number
          list = line.split(",")
          while list[1].to_i - withdraw.to_i < 0
            puts 'You do not have sufficient funds to make this withdrawal. Please try again'
            puts withdraw = gets.chomp()
          end
          begin
            list[1] = list[1].to_i - withdraw.to_i
          rescue => exception
            puts "Division by zero error"
          end
          puts "Account withdrawal was successful"
          puts "Your account balance has been decreased by NGN" + withdraw.to_s + " to NGN" + list[1].to_s
          puts "You will now be redirected to the main menu"
          new_line = list.join(',')
          f2.write("\n", new_line)
        end
      end
    end
  end
  FileUtils.mv './customer.txt.tmp', './customer.txt'
  bank(account_number)
end





puts "Welcome to SN Bank"
puts "Enter 1 to Create Account"
puts "Enter 2 to Login";
puts "Enter 3 to Close App"

input = gets.chomp()
if input == "1"
  createAccount()
elsif input == "2" 
  authenticateCustomer()
elsif input == "3"
  puts "Closing app"
  return
end  

 

