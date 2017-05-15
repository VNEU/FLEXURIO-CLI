# CREATE API

## CONFIGURATIONS
To Setup REST API open file at server/rest.js. Let say we want to create rest api for table KECAMATAN. So add :

```
Api.addCollection(KECAMATAN, {
    endpoints: {
        get: {
            authRequired: true
        },
        post: {
            authRequired: false
        },
        put: {
            authRequired: true,
            roleRequired: 'admin'
        },
        delete: {
            authRequired: true,
            roleRequired: 'admin'
        }

    }
});

```

Restart server with ```flexurio server-run``` and open http://localhost:3000, make sure you login and set url to http://localhost:3000/flxAPI/kecamatan


Bact to [MENU TUTORIAL](https://vneu.github.io/FLEXURIO-CLI)
