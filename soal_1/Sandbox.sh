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
