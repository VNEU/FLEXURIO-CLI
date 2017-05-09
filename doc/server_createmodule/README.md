# CREATE NEW MODULE APP

To create new module you can use *flexurio server-newmodule*. For example you want create Category of Book ( Remember - we want create POS for Book Store ). Before start, make sure you already in project folder FLEXURIO. So, lets start to create book Category.

In flexurio already tool to generate standart module, you can execute command : * flexurio server-newmodule [foldername] [modulename]* so we want create category, so execute command like this :
```
$ flexurio server-newmodule master bookcategory
```
and then your terminal display will show output :

```
Please input name of column number - 1 (* type DONE if all columns are already write off ) :name
Please input data type for column number - 1 [ name ] : string

```
let say we just need one fild "name". So we finished this by write DONE.

Check your folder FLEXURIO-CORE/client/views/, you will have folder master with 2 files bookcategory.js and bookcategory.html.

So Lets run your server by *flexurio server-run* and visit http://localhost:3000/bookcategory





Bact to [MENU TUTORIAL](https://vneu.github.io/FLEXURIO-CLI)
