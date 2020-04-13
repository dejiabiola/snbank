def authenticate
  puts "Please enter your username"
  username = gets.chomp()
  puts "Please enter your password"
  password = gets.chomp()

  # check the pre-defined staff in a file called staff.txt and verify that the username and password are correct.
  File.open('./staff.txt', 'r') do |file|

    # Return array of lines in file
    for line in file.readlines()
      list = line.split(",")
      if list[0] == username and list[1] == password
        # Login Successful, send user to bank
        bank()
        return
      end
    end
    puts "Your username or password is incorrect."
  end  
end

def bank
  #  Create a new file to store user sessions
  File.write('./user_session.txt', 'w') do |file|
  end  
  puts "You are on the main menu"
  puts "Enter 1 to create a new bank account"
  puts "Enter 2 to check account balance"
  puts "Enter 3 to log out"
  staff_option = gets.chomp()

  if staff_option == "1"
    createAccount()
  elsif staff_option == "2"
    checkAccount()
  elsif staff_option == "3"
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
  opening_balance = gets.chomp
  puts "Please enter an account type"
  puts "The options are either savings or current"
  account_type = gets.chomp()
  while account_type != "savings" and account_type != "current"
    puts "You entered an invalid account type. Please ty again"
    account_type = gets.chomp()
  end
  puts "please enter your email address"
  email = gets.chomp()

  #  Generate a random 10 digit account number for user
  account_number = ""
  while account_number.length < 11
      num = rand(0..9).to_s
      account_number += num   
  end

  #  save above information to the customer.txt file
  File.open('./customer.txt', 'a+') do |file|

    file.write("\n", account_name + "," + opening_balance + "," + account_type + "," + email + "," + account_number)
  end 

  #  show user the new account number
  puts "You have successfully created a new bank account"
  puts "Your new account number is " + account_number
  bank()
end


def checkAccount
  puts "Please enter your account number"
  ischecking = true
  while ischecking
    account_number = gets.chomp()
    if account_number == "*"
      ischecking = false
      bank()
      return
    elsif account_number == "#"
      ischecking = false
      puts "You are logged out"
      return
    else
      # Fetch account details of account from customer.txt and display to user
      File.open('./customer.txt', 'r') do |file|

        # Return array of lines in file
        for line in file.readlines()
          #  Query that line for the opening balance
          if line.include? account_number
            ischecking = false
            list = line.split(",")
            account_balance = list[1]
            puts "Welcome " + list[0] + ",your account balance is " + account_balance
            bank()
            break
            return
          end
        end
        if ischecking 
          puts "This account balance is not registered on our system. Please try again or press * to go to the main menu or press # to close app!!"
        end 
      end
    end
  end
end





puts "Welcome to snbank"
puts "Enter 1 for Staff Login";
puts "Enter 2 to Close App"

staff_input = gets.chomp()
if staff_input == "1" 
  authenticate()
elsif staff_input == "2"
  return
end  

 

