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
