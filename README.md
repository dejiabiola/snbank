# snbank
Startng Ruby Task

# Project Description

This is a basic banking system that utilizes file system to save data built with Ruby.


## Project Features

The app has the ability to

- Session file create upon log in:
  When the user logs in, a txt file for user sessions is created using ruby file system.

- Create new account: 
  When users log in, they can create a new bank account. They will be prompted to enter a new account name, opening balance, account type and email. A 10 digit account number will then be generated and displayed to the user. All the information is then complied together and saved in a customer txt file.

- Check account balance:
  Another option when the user logs in is to check account balance. User will be promted for account number, then the file system will be used to open the txt file and check if the account number exists. If it exists, the account balance will then be displayed .

- Session file delete upon log out:
  When the user logs out, the txt file for user sessions is deleted using ruby file system.


## How To Run

- Fork and then clone the repo to your local machine
- Open the folder in your terminal
- Run `ruby app.rb`
- Follow the prompt

## Logging In

You would need a staff credential to be able to log in. There are two hardcoded log in data already saved in the file. You can use that to log in. The data are:

1. Username = tony21     |    Password = 1234
2. Username = stella34   |    Password = 5678
