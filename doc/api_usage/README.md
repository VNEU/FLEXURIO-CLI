# API USAGE

if you success access http://localhost:3000/flxAPI/kecamatan. Let we try with curl.

## GET TOKEN AUTH TOKEN
```
curl http://localhost:3000/flxAPI/login/ -d "username=[YOUR-USERNAME]&password=[YOUR-PASSWORD]"

```

terminal will return with

```
{
  "status": "success",
  "data": {
    "authToken": "m0dvOeLka-uWKVJLhej50R__rddI3kFbIlJJqE-8EUH",
    "userId": "7Mycorub6GyjaLdHM"
  }

```

That your token and user id to access REST API

## ACCESS DATA WITH TOKEN
To get data KECAMATAN, you can use :
```
curl -H "x-auth-token: [YOUR authToken]" -H "x-user-id: [YOUR userId]" http://localhost:3000/flxAPI/kecamatan/
```

Bact to [MENU TUTORIAL](https://vneu.github.io/FLEXURIO-CLI)
