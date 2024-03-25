#!/bin/bash
# order_id  order_date  ship_date  ship_mode  customer_id  customer_name  segment  country  city  state  postal_code  region  product_id  category  sub_category  product_name  sales  quantity  discount  profit
# $1        $2          $3         $4         $5           $6             $7       $8       $9    $10    $11          $12     $13         $14       $15           $16           $17    $18       $19       $20

# subsoal a
echo "a. pembeli dengan total sales paling tinggi: "
tail -n +2 Sandbox.csv | awk 'BEGIN { max=0 } $17 > max { max=$17; name=$6 } END { print name }' FS=","
max=$(tail -n +2 Sandbox.csv | awk 'BEGIN { max=0 } $17 > max { max=$17 } END { print max }' FS=",")

# subsoal b
echo "b. customer segment yang memiliki profit paling kecil: "
tail -n +2 Sandbox.csv | awk -v min="$max" 'BEGIN { FS="," } $20 < min { min=$20; segment=$7 } END { print segment }'

# subsoal c
echo "c. 1. kategori dengan profit tertinggi: "
cat=$(tail -n +2 Sandbox.csv | awk 'BEGIN { maxxwyn=0 } $20 > maxwynn { maxwynn=$20; cat=$14 } END { print cat }' FS=",")
maxwynn=$(tail -n +2 Sandbox.csv | awk 'BEGIN { maxxwyn=0 } $20 > maxwynn { maxwynn=$20 } END { print maxwynn }' FS=",")
echo $cat

echo "c. 2. kategori dengan profit tertinggi kedua: "
catwo=$(tail -n +2 Sandbox.csv | awk -v maxwynn="$maxwynn" -v cat="$cat" 'BEGIN { maxtwo=0; FS="," } $20 > maxtwo && $20 < maxwynn && $14 != cat { maxtwo=$20; catwo=$14 } END { print catwo }')
maxtwo=$(tail -n +2 Sandbox.csv | awk -v maxwynn="$maxwynn" 'BEGIN { maxtwo=0; FS="," } $20 > maxtwo && $20 < maxwynn { maxtwo=$20 } END { print maxtwo }')
echo $catwo

echo "c. 3. kategori dengan profit tertinggi ketiga: "
tail -n +2 Sandbox.csv | awk -v maxtwo="$maxtwo" -v cat="$cat" -v catwo="$catwo" 'BEGIN { maxthree=0; FS="," } $20 > maxthree && $20 < maxtwo && $14 != cat && $14 != catwo { maxthree=$20; cathree=$14 } END { print cathree }'

# subsoal d
echo "d. pesanan atas nama adriaens: "
grep -i "Adriaens .*" Sandbox.csv | awk -F ',' '{print "purchase date: " $2}'
grep -i "Adriaens .*" Sandbox.csv | awk -F ',' '{print "quantity: " $18}'

# beberapa sumber yang digunakan
# https://stackoverflow.com/questions/28790371/bash-finding-maximum-value-in-a-particular-csv-column
# https://stackoverflow.com/questions/19075671/how-do-i-use-shell-variables-in-an-awk-script
