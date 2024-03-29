# Sisop-1-2024-MH-IT11
# Langkah-langkah penyelesaian setiap soal
# SOAL 1
Dikerjakan oleh Rafi' Afnaan Fathurrahman (5027231040)
Pengerjaan soal ini menggunakan 1 file script bash dan 1 file .csv, yaitu:
- `Sandbox.sh`: Terdiri atas 4 command utama yaitu
    1. Menampilkan `customer_name` dengan `sales` tertinggi
    2. Menampilkan `segment` dengan profit paling kecil
    3. Menampilkan 3 `category` dengan total `profit` tertinggi
    4. Menampilkan `purchase date` (`order_date`) dan `quantity` dari `customer_name` Adriaens... (Lastname belum diketahui)
- `Sandbox.csv`: Berisi data data yang akan digunakan oleh `Sandbox.sh`
## Sandbox.sh
```bash
#!/bin/bash
# order_id  order_date  ship_date  ship_mode  customer_id  customer_name  segment  country  city  state  postal_code  region  product_id  category  sub_category  product_name  sales  quantity  discount  profit
# $1        $2          $3         $4         $5           $6             $7       $8       $9    $10    $11          $12     $13         $14       $15           $16           $17    $18       $19       $20

# subsoal a
echo "a. pembeli dengan total sales paling tinggi: "
tail -n +2 Sandbox.csv | awk 'BEGIN { max=0 } $17 > max { max=$17; name=$6 } END { print name " " max }' FS=","

# subsoal b
echo "b. customer segment yang memiliki profit paling kecil: "
max=$(tail -n +2 Sandbox.csv | awk 'BEGIN { max=0 } $20 > max { max=$20 } END { print max }' FS=",")
tail -n +2 Sandbox.csv | awk -v min=$max 'BEGIN { } $20 < min { min=$20; segment=$7 } END { print segment " " min }' FS=","

# subsoal c
echo "c. 3 total profit tertinggi berdasarkan kategori: "
tail -n +2 Sandbox.csv | awk -F ',' '{sum[$14]+=$20} END {for (category in sum) print category " " sum[category]}' | sort -k2 -nr | head -n 3

# subsoal d
echo "d. pesanan atas nama adriaens: "
grep -i "Adriaens .*" Sandbox.csv | awk -F ',' '{print "purchase date: " $2}'
grep -i "Adriaens .*" Sandbox.csv | awk -F ',' '{print "quantity: " $18}'

# beberapa sumber yang digunakan
# https://stackoverflow.com/questions/28790371/bash-finding-maximum-value-in-a-particular-csv-column
# https://stackoverflow.com/questions/19075671/how-do-i-use-shell-variables-in-an-awk-script
# https://unix.stackexchange.com/questions/242946/using-awk-to-sum-the-values-of-a-column-based-on-the-values-of-another-column
# https://linuxhandbook.com/sort-command/
```
## Subsoal a
Soal meminta untuk mencari pembeli dengan total sales paling tinggi.
```bash
tail -n +2 Sandbox.csv | awk 'BEGIN { max=0 } $17 > max { max=$17; name=$6 } END { print name " " max }' FS=","
```
`tail -n +2 Sandbox.csv` mengoutput file Sandbox.csv mulai dari line ke 2, melewati header line, lalu di piping `|` kedalam fungsi `awk` dimana kondisi awal `max=0`. Lalu, jika ditemukan `$17 > max`, value `max` diperbaharui dan `name` dibuah sesuai `max` yang baru. Jika sudah selesai, program mengeluarkan `name` serta value `max`
## Subsoal b
Soal meminta untuk mencari `segment` dengan `profit` paling rendah
```bash
max=$(tail -n +2 Sandbox.csv | awk 'BEGIN { max=0 } $20 > max { max=$20 } END { print max }' FS=",")
tail -n +2 Sandbox.csv | awk -v min=$max 'BEGIN { } $20 < min { min=$20; segment=$7 } END { print segment " " min }' FS=","
```
Menggunakan logic subsoal a, dibuat batas atas untuk mencari `profit` paling rendah. Batas atas tersebut kemudian dimasukkan kedalam fungsi awk yang mengambil angka terkecil pertama, dan menjadikannya nilai `min` baru. Jika sudah selesai, program mengeluarkan `segment` serta value `min`
## Subsoal c
Soal meminta untuk menuliskan 3 `category` dengan total (`sum`) `profit` paling tinggi
```bash
tail -n +2 Sandbox.csv | awk -F ',' '{sum[$14]+=$20} END {for (category in sum) print category " " sum[category]}' | sort -k2 -nr | head -n 3
```
code `{sum[$14]+=$20}` menambahkan semua value di kolom ke 20 (kolom `profit`) untuk setiap item unik di kolom 14 (kolom `category`)(contoh menjumlahkan semua profit dari barang di `category` furniture). `for (category in sum) print category " " sum[category]` mengoutput semua `category` dan `sum` yang tadi dihitung, lalu di pipe ke fungsi `sort -k2 -nr` yang mengurutkannya berdasarkan value pada kolom ke 2 (`k2`) secara numerikal (`-n`) dan terbalik agar mengurut dari besar ke kecil (`-r`). Selanjutnya output di pipe ke fungsi `head -n 3` yang menampilkan hanya 3 output teratas
## Subsoal d
Soal meminta untuk mencari `purchase date` (`order_date`) dan `quantity` dari pesanan atas nama Adriaens
```bash
grep -i "Adriaens .*" Sandbox.csv | awk -F ',' '{print "purchase date: " $2}'
grep -i "Adriaens .*" Sandbox.csv | awk -F ',' '{print "quantity: " $18}'
```
Fungsi ini pertama tama mencari kolom yang mengandung `"Adriaens .*"` (Adriaens dan wildcard karena terdapat nama akhir yang tidak diketahui) lalu di pipe ke dalam fungsi `awk` yang mengoutput `purchase date` serta `quantity`

# SOAL 2

## Overview

Dikerjakan oleh Rafi' Afnaan Fathurrahman (5027231040)
Pengerjaan soal ini menggunakan 2 file script bash, yaitu:
- `Register.sh`: Pengguna melakukan registrasi akun baru dan data tersebut diletakkan ke dalam file `users.txt`. Setiap kali pengguna berhasil atau gagal melakukan registrasi sebuah akun baru, akan dicatat kedalam `auth.log`
- `Login.sh`: Pengguna melakukan login menggunakan akun yang sudah ada di dalam file `users.txt`. Setiap kali pengguna berhasil atau gagal melakukan login sebuah akun baru, akan dicatat kedalam `auth.log`. Disini pengguna bisa masuk sebagai `user` atau `admin` tergantung akun yang digunakan untuk login. `Admin` dapat menambah, mengubah dan menghapus pengguna
## Register.sh

CODE TELAH DIREVISI:
- TIDAK MEWAJIBKAN PENGGUNAAN SIMBOL PADA PASSWORD

```bash
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
if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
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

```
Script ini mengambil data menggunakan `read` dan menempatkannya kedalam sebuah variable. Terdapat sebuah code yang memeriksa apakah email tersebut unik, belum ada didalam databasis yaitu:
```bash
if grep -q "^$email:" users.txt; then
    data
    echo "Email already exists in the database"
    exit 1
fi
```

Selanjutnya password akan diperiksa kekuatannya dengan melihat apakah password mengandung setidaknya 1 dari masing masing: `uppercase`, `lowercase`, `number` dan tidak sama dengan `username` dan `email` menggunakan code:
```bash
if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
    # code
fi
```

Jika sudah sesuai, email dan username akan diperiksa, jika mengandung kata admin maka akan diberikan status `admin`, jika tidak maka akan diberikan status `user`. Selanjutnya password akan dienkripsi menggunakan basis 64 dengan menggunakan kode:
```bash
echo "$password" | base64
```

lalu disimpan bersamaan dengan data-data lainnya di `users.txt`. Terakhir, program akan mencatat iterasi program ini, berhasil atau tidaknya registrasi pengguna baru, kedalam file `auth.log`. Waktu pembuatan entry jurnal log menggunakan code:
```bash
timedate=$(date +"%d/%m/%Y %H:%M:%S")
```
Yang akan menampilkan waktu dalam format dd/mm/yyyy hh:mm:ss

Terdapat beberapa fungsi tambahan didalam program ini yang memiliki fungsi visual.
## Login.sh

CODE TELAH DIREVISI:
- TIDAK MEWAJIBKAN PENGGUNAAN SIMBOL PADA PASSWORD

```bash
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
    exit 0
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
            if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
                if [[ $l_email =~ .*admin.* || $l_name =~ .*admin.* ]]; then
                    status="admin"
                else
                    status="user"
                fi

                passwd=$password
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
            if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" != "$email" && "$password" != "$username" ]]; then
                if [[ $l_email =~ .*admin.* || $l_name =~ .*admin.* ]]; then
                    status="admin"
                else
                    status="user"
                fi

                passwd=$password
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
```
Script ini pertama tama menanyakan kepada pengguna apakah mereka akan melakukan `Login` atau memilih opsi `Forgot password`. Jika memilih `Forgot password`, script akan meminta pengguna untuk memasukkan `email` dan mengeluarkan `security_question` dari users.txt untuk verifikasi pengguna. Jika pengguna berhasil menjawab pertanyaan tersebut, maka pengguna akan dapat melihat passwordnya.
```bash
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
```
Jika memilih opsi `login`, maka pengguna akan memasukkan `email` dan memasukkan `password`nya. Jika berhasil login, akan ada dua outcome:
- Jika pengguna terdaftar sebagai `admin`, maka pengguna akan masuk ke menu pengguna admin
- Jika terdaftar sebagai `user` maka tidak akan terjadi apa apa

Karena password disimpan di dalam `users.txt` dalam enkripsi basis 64, maka sebelum digunakan di dalam program, password didekripsi terlebih dahulu menggunakan
```bash
decode_pass=$(grep -i "$email" users.txt | awk -F ':' '{print $6}' | base64 --decode)
```

Jika berhasil `login` sebagai `admin`, maka akan muncul 4 opsi:
1. `Add user`: Menambahkan pengguna baru sesuai dengan prinsip yang sama dengan `Register.sh`
2. `Edit user`: Mengubah data sebuah pengguna dengan cara menghapus data yang sebelumnya dan menggantinya dengan data yang baru dimasukkan sesuai dengan prinsip yang digunakan di `Register.sh`
3. `Delete user`: Menghapus data pengguna dengan cara mencari data yang memiliki email yang sesuai dengan yang dimasukkan pengguna, lalu menghapusnya menggunakan: `sed -i "/$email/d" users.txt` (`Edit user` juga menggunakan code yang sama untuk menghapus data yang lama)
4. `Logout`: Menghentikan program tersebut

Terdapat beberapa fungsi tambahan didalam program ini yang memiliki fungsi visual.

# SOAL 3
Dikerjakan oleh Ricko Mianto (5027231031)

Repositori ini berisi skrip untuk mengelola dan mencari informasi tersembunyi dari gambar karakter dari game Genshin Impact. Dua skrip yang disertakan yaitu:
- awal.sh: Skrip ini berfungsi untuk mengunduh dan mengekstrak file.zip yang di download melalui link yang tersedia dalam soal. Setelah mengekstrak file tersebut diuraikan berdasarkan nama, region, elemen, dan senjata dari file list_character.csv. Setelah file terurai lalu membuat sebuah direktori region kemudian memindahkan file tersebut ke dalam direktori region. Lalu yang terakhir skrip ini juga berfungsi untuk menghitung jumlah dari setiap jenis senjata.

```bash
#!/bin/bash

wget -O genshin.zip 'https://docs.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN'
unzip genshin.zip
unzip genshin_character.zip

declare -A weapon_count

for file in /home/rickomianto/sisop1/genshin_character/*.jpg; do
    decoded_name=$(basename "$file" | xxd -r -p)
    region=$(awk -F',' -v name="$decoded_name" '$1 == name {print $2}' /home/rickomianto/sisop1/list_character.csv)
    elemen=$(awk -F',' -v name="$decoded_name" '$1 == name {print $3}' /home/rickomianto/sisop1/list_character.csv)
    weapon=$(awk -F',' -v name="$decoded_name" '$1 == name {print $4}' /home/rickomianto/sisop1/list_character.csv)
    mkdir -p "/home/rickomianto/sisop1/genshin_character/$region"
    if [ -f "$file" ]; then
        mv "$file" "/home/rickomianto/sisop1/genshin_character/$region/$region-$decoded_name-$elemen-$weapon.jpg"
    else
        echo "File not found: $file"
    fi
    if [ -f "/home/rickomianto/sisop1/genshin_character/$region/$region-$decoded_name-$elemen-$weapon.jpg" ]; then
        cp "/home/rickomianto/sisop1/genshin_character/$region/$region-$decoded_name-$elemen-$weapon.jpg" "/home/rickomianto/sisop1/genshin_character/$region/"
    else
        echo "File not found: /home/rickomianto/sisop1/$region/$region-$decoded_name-$elemen-$weapon.jpg"
    fi
done

weapon_types=(Catalyst Bow Polearm Sword Claymore)

for weapon_type in "${weapon_types[@]}"; do
  count=$(awk -F',' '/'"$weapon_type"'/ { ++count } END { print count }' list_character.csv)
  echo "$weapon_type : $count"
done

rm genshin.zip genshin_character.zip list_character.csv

```
- search.sh: Skrip ini berfungsi untuk menyiapkan sebuah log untuk mencatat apabila url ditemukan dan tidak. Skrip ini juga berfungsi untuk memindai gambar karakter yang telah diurai berdasarkan region lalu mengekstrak informasi dari gambar tersebut. Tidak hanya itu, dalam skrip ini juga mendefinisikan sebuah fungsi process yang mana dalam fungsi tersebut berfungsi untuk memindahkan dan menguraikan file.txt untuk mencari sebuah url menggunakan fungsi regex. Setelah url ditemukan dan diekstrak dalam bentuk secret.txt skrip ini akan membaca secret.txt dan mengunduh gambar dari url.

```bash
#!/bin/bash

touch /home/rickomianto/sisop1/image.log

process() { 
    mkdir -p /home/rickomianto/sisop1/textfile
    mv /home/rickomianto/sisop1/*.txt /home/rickomianto/sisop1/textfile/

    for file in /home/rickomianto/sisop1/textfile/*.txt; do
        base64 -d "$file" > secret.txt
        regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
        string=$(cat secret.txt)
        if [[ $string =~ $regex ]]; then
           mv secret.txt $FILE_DIR
        echo "[$(date '+%Y/%M/%d %H:%M:%S')] [FOUND] [/home/rickomianto/sisop1/genshin_character/$file]" >> image.log
        break
    else
        echo "[$(date '+%Y/%M/%d %H:%M:%S')] [NOT FOUND] [/home/rickomianto/sisop1/genshin_character/$file]" >> image.log
    fi
    rm "$file"
done
    sleep 1
}

for region in Mondstat Liyue Fontaine Inazuma Sumeru; do
    pass=""
    for image in "/home/rickomianto/sisop1/genshin_character/$region"/*.jpg; do
        steghide extract -q -sf "$image" -p "$pass"
        process "$image"
    done
done

secret_link=$(cat "secret.txt")
wget -O gambar.jpg "$secret_link"
```

hasil akhir :

![alt text](https://media.discordapp.net/attachments/1176233896292122634/1221838658244575323/image.png?ex=661408ec&is=660193ec&hm=64606f9d04c0050af23e53ddaed88b92a86e05558e3405f31347c1ab1b99acd8&=&format=webp&quality=lossless&width=830&height=146)

# SOAL 4
Dikerjakan oleh Raditya Hardian Santoso (5027231033)

Repositori ini berisi skrip untuk memantau penggunaan RAM dan ukuran direktori secara berkala dan mencatat metriknya ke dalam file. Dua skrip utama yang disertakan adalah:

- `minute_log.sh`: Skrip ini mencatat metrik RAM dan ukuran direktori setiap menit.
- `aggregate_minutes_to_hourly_log.sh`: Skrip ini menggabungkan metrik yang dicatat oleh `minute_log.sh` menjadi ringkasan per jam, termasuk nilai minimum, maksimum, dan rata-ratanya.

Dalam soal ini, kita diminta untuk membuat program yang memonitor ram dan size directory /home/{user} dengan cara memasukkan metrics kedalam file log secara periodik.

## minute_log.sh

Isi skrip saya :

```bash
#!/bin/bash

# Navigasi ke direktori log
cd /home/kali/log || exit

# Membuat nama file log berdasarkan timestamp
logfile="metrics_$(date +'%Y%m%d%H%M').log"

# Mendapatkan metrik RAM menggunakan 'free -m'
ram_metrics=$(free -m | awk 'NR==2 {print $2","$3","$4","$5","$6","$7}')

# Mendapatkan ukuran direktori menggunakan 'du -sh'
directory="/home/kali/coba/"
dir_size=$(du -sh $directory | awk '{print $1}')

# Menyimpan metrik RAM, ukuran swap, dan ukuran direktori ke dalam file log
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,dir_path,dir_size" > "$logfile"
echo "$ram_metrics,$(swapon -s | awk 'NR==2 {print $2","$3","$4}'),$directory,$dir_size" >> "$logfile"

# Mengatur izin agar file log hanya dapat dibaca oleh pemiliknya
chmod 600 "$logfile"

```
Script bash yang pertama (minute_log.sh) akan memasukkan metrics ke dalam file dengan format metrics_{YmdHms}.log setiap menitnya. Script ini juga akan membuat folder dalam directory log dengan format metrics_agg_$(YmdH) dengan nilai H merupakan 1 jam sebelum script dijalankan. Tujuannya agar file log yang digenerate tiap menit tidak berceceran. hasil run:

![alt text](https://cdn.discordapp.com/attachments/1176233896292122634/1221504545960755250/image.png?ex=6612d1c2&is=66005cc2&hm=a610467e45968273627aa85c3b476968f1c8b04ce8b2cd0e9b107fd7cf9996f6&)

Karena minute_log.sh harus dijalankan tiap menit, kita dapat menambahkan line berikut pada crontab (crontab -e):
```bash
* * * * * /{path minute_log.sh}
```

## aggregate_minutes_to_hourly_log.sh

Skrip ini menggabungkan file log per menit menjadi ringkasan per jam, menghitung nilai minimum, maksimum, dan rata-rata untuk setiap metrik.

Script bash yang kedua (aggregate_minutes_to_hourly_log.sh) akan menggabungkan file log yang dibuat minute_log.sh dan akan menyimpan nilai minimum, maximum, dan rata-rata tiap metrics setiap jam. Caranya adalah dengan membaca seluruh file log yang berada dalam folder metrics_agg_$(YmdH).

Isi skrip saya :

```bash
#!/bin/bash

# Navigasi ke direktori log
cd /home/kali/log || exit

# Membuat nama file log agregasi berdasarkan timestamp
agglogfile="metrics_agg_$(date +'%Y%m%d%H').log"

# Mendapatkan kolom yang akan diambil rata-rata, minimum, dan maksimum
columns="2,3,4,5,6,7,8,9,10,11,12"

# Mencatat nilai minimum, maksimum, dan rata-rata
minimum=$(awk -F',' 'NR>1 {print $'$columns'}' metrics_*.log | sort -t, -n | head -n 1)
maximum=$(awk -F',' 'NR>1 {print $'$columns'}' metrics_*.log | sort -t, -n | tail -n 1)
average=$(awk -F',' -v col="$columns" 'BEGIN {sum=0; count=0} NR>1 {split(col, arr, ","); for (i in arr) sum+=$arr[i]; count++} END {print sum/count}' metrics_*.log)

# Mengubah satuan hasil
minimum=$(echo $minimum | sed 's/M/ MB/g')
maximum=$(echo $maximum | sed 's/M/ MB/g')
average=$(printf "%.2f" $average) # Mengatur dua angka di belakang koma untuk rata-rata

# Menyimpan hasil agregasi ke dalam file log
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$agglogfile"
echo "minimum,$minimum" >> "$agglogfile"
echo "maximum,$maximum" >> "$agglogfile"
echo "average,$average" >> "$agglogfile"

# Mengatur izin agar file log hanya dapat dibaca oleh pemiliknya
chmod 600 "$agglogfile"

```

Untuk mendapatkan nilai average, kita dapat mencatat index, yaitu jumlah file log yang terdapat dalam folder. Selanjutnya kita juga akan mencatat nilai sum/total dari masing-masing metrics yang kemudian akan dibagi dengan index untuk mendapatkan nilai average.

Selanjutnya, untuk mendapat nilai minimum dan maximum kita dapat menyimpan masing-masing value metrics ke dalam array lalu melakukan sort sehingga nilai minimum masing-masing metrics akan berada pada index paling awal dan nilai maximum masing-masing metrics akan berada pada index paling akhir. Kita juga akan menggunakan chown agar log hanya dapat dibaca user.

hasil run:

![alt text](https://cdn.discordapp.com/attachments/1176233896292122634/1221504764857028608/image.png?ex=6612d1f6&is=66005cf6&hm=ca3e8774192fa09367ce9ed864cf1756ccffc99fc2c3adb462e53d329592f91b&)


Agar aggregate_minutes_to_hourly_log.sh dapat dijalankan tiap jam, kita dapat menambahkan line berikut pada crontab:

```bash
0 * * * * /{path aggregate_minutes_to_hourly_log.sh}
```


