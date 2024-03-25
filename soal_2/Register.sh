
#!/bin/bash

email="..."
username="..."
question="..."
answer="..."
status="..."
password="********"

timedate=$(date +"%d/%m/%Y %H:%M:%S")

data()
{
    echo -e "\n++===============================++"
    echo "|| Welcome to Registration System"
    echo "|| email    : $email"
    echo "|| username : $username"
    echo "|| question : $question"
    echo "|| answer   : $answer"
    echo "|| status   : $status"
    echo "|| password : $password"
    echo -e "++===============================++\n"
}

data

read -p "Enter your email: " email
data
l_email=$(echo "$email" | tr '[:upper:]' '[:lower:]')
if grep -q "^$email:" users.txt; then
    data
    echo "Email already exists in the database"
    exit 1
fi

read -p "Enter your username: " username
data
l_name=$(echo "$username" | tr '[:upper:]' '[:lower:]')
if grep -q ":$username:" users.txt; then
    data
    echo "Username already exists in the database"
    exit 1
fi

read -p "Enter your security question: " question
data

read -p "Enter your security answer: " answer
data

read -s -p "Enter your password (minimum of 8 characters, at least 1 upperase, 1 lowercase letter, 1 digit, 1 symbol): " password
echo ""
if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" =~ [^a-zA-Z0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
    if [[ $l_email =~ .*admin.* || $l_name =~ .*admin.* ]]; then
        status="admin"
    else
        status="user"
    fi

    data
    echo "Registration successful"
    e_password=$(echo "$password" | base64)
    echo "$email:$username:$question:$answer:$status:$e_password" >> users.txt
    echo "[$timedate][REGISTER SUCCESS] user [$username] registered successfully" >> auth.log

else 
    data
    echo "Registration failed"
    echo "[$timedate][REGISTER FAILED] ERROR Failed register attempt on user with email [$email]" >> auth.log
    exit 1
fi

# beberapa sumber yang digunakan
# https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-base64-encode-and-decode-from-command-line/
# https://stackoverflow.com/questions/2264428/how-to-convert-a-string-to-lower-case-in-bash
# https://www.baeldung.com/linux/bash-hide-user-input
