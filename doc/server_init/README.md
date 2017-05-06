# CREATE NEW PROJECT

## CREATE PROJECT FROM SCRATCH
```
$ flexurio create [Project Name]

```

## ALREADY HAVE PROJECT

if you already folder prject, go to that folder
```
$ cd [Your Project Folder]
$ ls

```

check list document in that folder, are that already folder name *FLEXURIO-CORE*, if not exist, create with

```
$ flexurio server-init
```

that command will clone FLEXURIO-CORE to your project folder.

## RUN FLEXURIO

### RUN ON LOCAL
If you want run flexurio on local, use command :
```
$ flexurio server-run
```
### RUN ON MONGODB SERVER
If you want run flexurio with database server mongodb, use command :
```
$ flexurio server-runProductions username:password@serverMongo:portMongo databaseAuthMongo
```

for example :
```
$ flexurio server-runProductions username:password@192.168.1.1:10010 admin

```

open your browser and visit : http://localhost:3000


Next to [DEPLOY YOUR APP](https://vneu.github.io/FLEXURIO-CLI/doc/server_deploy)
