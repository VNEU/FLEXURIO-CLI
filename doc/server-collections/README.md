# COLLECTIONS & ROUTES


## COLLECTIONS

Collection on Flexurio use MongoDB Concept. Declaration at `FLEXURIO-CORE/lib/collections.js` for example we want to create `bookcategory` collections to store messages data.
if you want NON OFFLINE MODE, just remove `Ground.Collection(bookcategory);`.

```javascript
BOOKCATEGORY = new Mongo.Collection('bookcategory');
Ground.Collection(BOOKCATEGORY);
```

## ROUTES
Location router at `FLEXURIO-CORE/lib/router.js` for example we want to create route `bookcategory` that want to show page template bookcategory.

On router.js :
```javascript
Router.route('/bookcategory', function () {
    this.render('bookcategory');
});
```



Bact to [HOME TUTORIAL](https://vneu.github.io/FLEXURIO-CLI)
