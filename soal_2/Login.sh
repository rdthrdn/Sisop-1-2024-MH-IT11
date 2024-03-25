#!/bin/bash

# $email:$username:$question:$answer:$status:$e_password
# $1     $2        $3        $4      $5      $6

email="..."
username=""...
sec_que="..."
sec_ans="..."
status="..."
decode_pass=""
passwd="********"

timedate=$(date +"%d/%m/%Y %H:%M:%S")

data()
{
    echo -e "\n++===============================++"
    echo "|| User Data"
    echo "|| email    : $email"
    echo "|| username : $username"
    echo "|| question : $sec_que"
    echo "|| answer   : $sec_ans"
    echo "|| status   : $status"
    echo "|| password : $passwd"
    echo -e "++===============================++\n"
}

list()
{
    echo -e "\n++===============================++"
    echo "|| User List"
    echo "++===============================++"
    awk -F ':' '{print "|| "$1}' users.txt
    echo -e "++===============================++\n"
}

new_mail()
{
    if grep -q "^$email:" users.txt; then
    data
    echo "Email already exists in the database"
    exit 1
    fi
}

validator()
{
    local l_email=$(echo "$email" | tr '[:upper:]' '[:lower:]')
    username=$(grep -i "$email" users.txt | awk -F ':' '{print $2}')
    local l_name=$(echo "$username" | tr '[:upper:]' '[:lower:]')
    if [[ $l_email =~ .*enigma.*26.* || $l_email =~ .*unknown.*74.* || $l_name =~ .*enigma.*26.* || $l_name =~ .*unknown.*74.* ]]; then
        flag
    elif ! grep -q $email "users.txt"; then
        echo "$email not found in database"
        exit 1
    fi
    sec_que=$(grep -i "$email" users.txt | awk -F ':' '{print $3}')
    sec_ans=$(grep -i "$email" users.txt | awk -F ':' '{print $4}')
    status=$(grep -i "$email" users.txt | awk -F ':' '{print $5}')
    decode_pass=$(grep -i "$email" users.txt | awk -F ':' '{print $6}' | base64 --decode)
}

flag()
{
    echo "c2lzb3B7dzNsYzBtM190MF90aDNfYzAwbF9rMWQ1X2NsdWJ9Cg==" | base64 --decode
    xdg-open "https://cdn.discordapp.com/attachments/1215177202618998824/1218115119192608908/me_when.jpg?ex=660fb79b&is=65fd429b&hm=50d40698f564184adf148d1f4a5d3040bdf8c1e704b8cf34dd9070369fc58345&"
}

admin_login()
{
    echo -e "\n++============================="
    echo "|| Admin Menu"
    echo "|| 1. Add User"
    echo "|| 2. Edit User"
    echo "|| 3. Delete User"
    echo "|| 4. Logout"
    echo -e "++=============================\n"
    read response2
    case "$response2" in
        "1")
            local email=""
            local username=""
            local sec_que=""
            local sec_ans=""
            local status=""
            local password=""
            echo -e "\n################################"
            echo -e "################################\n"
            echo "Add User"
            data
            read -p "Enter email: " email
            l_email=$(echo "$email" | tr '[:upper:]' '[:lower:]')
            new_mail
            data
            read -p "Enter username: " username
            l_name=$(echo "$username" | tr '[:upper:]' '[:lower:]')
            data
            read -p "Enter security question: " sec_que
            data
            read -p "Enter security answer: " sec_ans
            data
            read -s -p "Enter password: " password
            echo ""
            if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" =~ [^a-zA-Z0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
                if [[ $l_email =~ .*admin.* || $l_name =~ .*admin.* ]]; then
                    status="admin"
                else
                    status="user"
                fi

                $passwd=$password
                data
                echo "Registration successful"
                e_password=$(echo "$password" | base64)
                echo "$email:$username:$sec_que:$sec_ans:$status:$e_password" >> users.txt
            else 
                data
                echo "Registration failed"
                exit 1
            fi
            ;;
        "2")
            echo -e "\n################################"
            echo -e "################################\n"
            echo "Edit User"
            list
            read -p "Enter email: " email
            validator
            temp_mail=$email
            passwd=$decode_pass
            data
            read -p "Enter new email: " email
            l_email=$(echo "$email" | tr '[:upper:]' '[:lower:]')
            new_mail
            data
            read -p "Enter new username: " username
            l_name=$(echo "$username" | tr '[:upper:]' '[:lower:]')
            data
            read -p "Enter new security question: " sec_que
            data
            read -p "Enter new security answer: " sec_ans
            data
            read -s -p "Enter new password: " password
            echo ""
            if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" =~ [^a-zA-Z0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
                if [[ $l_email =~ .*admin.* || $l_name =~ .*admin.* ]]; then
                    status="admin"
                else
                    status="user"
                fi

                $passwd=$password
                data
                echo "Edit successful"
                e_password=$(echo "$password" | base64)
                sed -i "/$temp_mail/d" users.txt
                echo "$email:$username:$sec_que:$sec_ans:$status:$e_password" >> users.txt
            else 
                data
                echo "Edit failed"
                exit 1
            fi
            ;;
        "3")
            echo "Delete User"
            list
            read -p "Enter email: " email
            validator
            data
            read -p "Are you sure you want to delete $email? (y/n) " response3
            case "$response3" in
                "y")
                    sed -i "/$email/d" users.txt
                    echo "User deleted"
                    list
                    ;;
                "n")
                    echo "User not deleted"
                    list
                    ;;
                *)
                    echo "Invalid input"
                    exit 1
                    ;;
            esac
            ;;
        "4")
            echo "Logout successful!"
            exit 0
            ;;
        *)
            echo "Invalid input"
            exit 1
            ;;
    esac
}

echo -e "\n++============================="
echo "|| Welcome to Login System"
echo "|| 1. Login"
echo "|| 2. Forgot Password"
echo -e "++=============================\n"
read response1

case "$response1" in
    "1")
        echo "Welcome to Login System"
        read -p "Enter your email: " email
        validator
        read -s -p "Enter your password: " password
        if [[ "$password" == "$decode_pass" ]]; then
            echo "Login successful!"
            echo "[$timedate][LOGIN SUCCESS] user [$username] logged in successfully" >> auth.log
            if [[ "$status" == "admin" ]]; then
                admin_login
            else
                echo "You don't have admin privileges, Welcome!"
                data
                exit 0
            fi
        else
            echo "[$timedate][LOGIN FAILED] ERROR Failed login attempt on user with email [$email]" >> auth.log
            exit 1
        fi
        ;;
    "2")
        echo "Forgot password?"
        read -p "Enter your email: " email
        validator
        read -p "Security question: $sec_que? " security_answer
        if [[ "$security_answer" == "$sec_ans" ]]; then
            passwd=$decode_pass
            data
            exit 0
        else
            echo "wrong answer"
            exit 1
        fi
        ;;
    *)
        echo "Invalid input"
        exit 1
        ;;
esac

# beberapa sumber yang digunakan
# https://www.thegeekstuff.com/2009/11/unix-sed-tutorial-append-insert-replace-and-count-file-lines/
# https://stackoverflow.com/questions/11287861/how-to-check-if-a-file-contains-a-specific-string-using-bash
# https://stackoverflow.com/questions/1401482/yyyy-mm-dd-format-date-in-shell-script
