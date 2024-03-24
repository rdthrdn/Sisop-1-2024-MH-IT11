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
