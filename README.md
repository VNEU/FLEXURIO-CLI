## Cara Penggunaan Program Flexurio
Panduan dibawah ini akan menjelaskan tentang cara penggunaan program flexurio.


Untuk membuat module baru di flexurio. Caranya seperti perintah dibawah ini.
```
.\flexurio server-newmodule (NAMA FOLDER) spasi (nama file)
```

Ketika anda bikin module baru di flexurio maka akan otomatis kebikin 2 file yaitu html dan js dan ketika anda creat(newmodule) kolomnya bisa anda atur sesuai dengan keinginan anda.

Di dalam file js akan kebikin 3 template yaitu :

1.created

2.helfer

3.events


Kemudian di file htmlnya akan kebikin tampilannya.

Untuk menjalan program flexurio di localhost anda tulis syntak.

```
./flexurio server-run
```

Untuk mempublis codingan anda pertama anda add(pilih) semua data file anda caranya seperti syntax dibawah ini.
```
git add *
```
Tanda bintang di atas menandakan ALL(semua) anda memilih semua file yang akan anda publish.

Kemudian ke langkah yang kedua adalah commit(melakukan) yaitu menjelaskan perubahan apa yang kita lakukan.

```
git commit
```

setelah menjalankan perintah git commit selanjutnya jalankan perintah.

```
git pull

```
 Perintah git pull yaitu menarik data dari server. Setalah perintah git pull berhasil jalankan peritah git push.

```
git push
```
Untuk melihat packade yang  anda miliki, caranya tulis perintah seperti dibawah ini.

```
./flexurio server-list
```
