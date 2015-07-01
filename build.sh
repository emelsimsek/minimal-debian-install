#!/bin/bash

# Bir komutun hata vermesi durumunda betiği derhal durduralım.
set -e 
set -x

# Pardus reposunda Debian Installer ile ilgili ufak bir problem var.
# Debian installer, çekirdeği bulamıyor. Pardus Kurumsal sürümü Mint installer kullandığı
# için, bu debian installer çalıştırma gereği duyulmamış sanıyorum. 
# Debian installer kullanmaya karar verirsek, bu sorunun düeltilmesini sağlayacağız.
# O zamana kadar Debian mirror'larını kullanacağız.

MIRROR_URL="http://ftp.tr.debian.org/debian/"

rm -rf live
mkdir live
cd live

# lb config komutu ile konfigürasyon işlemlerini gerçekleştirelim.
# Burada belirtilmeyen her parametrenin default değeri kullanılmaktadır.
# Tanımlanabilecek tüm parametreler için bakınız: "man lb config"

lb config --verbose \
         --parent-mirror-bootstrap      $MIRROR_URL \
         --mirror-bootstrap             $MIRROR_URL \
         --parent-mirror-chroot        $MIRROR_URL \
         --mirror-chroot                $MIRROR_URL \
         --parent-mirror-binary        $MIRROR_URL \
         --mirror-binary                $MIRROR_URL \
         --parent-mirror-debian-installer  $MIRROR_URL \
         --mirror-debian-installer         $MIRROR_URL \


# Kurulum sırasında Debian Installer'ın kullanıcıdan interaktif olarak
# aldığı cevapları önceden tanımlayarak (preseeding), kurulumu otomatikleştirelim.

cp ../preseed.cfg config/debian-installer/
cp ../preseed.cfg config/includes.installer
cp ../preseed.cfg config/preseed/

# Bootloader (isolinux) konfigürasyonunu live build için tanımlayalım.
# Default bootloader isolinux'dür. isolinux default konfigürasyonunu şu şekilde değiştiriyoruz.
# 1. Menü'yü değiştirerek, "install" dışındaki seçenekleri kaldırıyoruz.
# 2. 0 olan Timeout değerini değiştirerek install seçeneğinin otomatik olarak başlatılmasını sağlıyoruz.

cp  -r ../bootloaders config/
cp ../binary config/

lb build

