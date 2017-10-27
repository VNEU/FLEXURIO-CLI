#!/bin/bash
if [ "$1" == "server-newmodule" ]; then
    sDatabase=$(echo $3 | tr 'a-z' 'A-Z')
    sDatabaseL=$(echo "$sDatabase" | tr '[:upper:]' '[:lower:]')
    sDatabaseInput="$sDatabase DocInput"
    sDatabaseInput="${sDatabaseInput/ /}"
    sDatabaseLs="$sDatabaseL s"
    sDatabaseLs="${sDatabaseLs/ /}"

    sKK=$'"'
    sNew=$""
    sEdit=$""
    sKolomNew=$""
    sKolomEdit=$""
    sCekAda=$""
    sCekAdaData=$""
    sCekEdit=$""
    sCekEditData=$""

    sHTMLDisplay=$""
    sHTMLEdit=$""
    sHTMLNew=$""

    sFILTER=$""

    declare -i i=0
    while : ;
    do
       i=$(( i + 1 ))
       read -e -p "Please input name of column number - $i (* type DONE if all columns are already write off ) :" NAMAKOLOM

       namakolomU=$(echo $NAMAKOLOM | tr 'a-z' 'A-Z')
       namakolomL=$(echo "$NAMAKOLOM" | tr '[:upper:]' '[:lower:]')

       if [[ $NAMAKOLOM == "DONE" ]] ; then
           break
       else
           read -e -p "Please input data type for column number - $i [ $NAMAKOLOM ] : " TYPEDATA
       fi


       sNamaNew=$namakolomL$sDatabase
       sNamaNewKK=$sKK$sNamaNew$sKK
       sNamaEdit=$namakolomL$"Edit"$sDatabase
       sNamaEditKK=$sKK$sNamaEdit$sKK

       sFILTER=$sFILTER$"
       {$namakolomL: { \$regex : new RegExp(textSearch, 'i') }},
       "

       sNew=$sNew$"
       let $sNamaNew = tpl.\$('input[name=$sNamaNewKK]').val();
       "

       sEdit=$sEdit$"
       let $sNamaEdit = tpl.\$('input[name=$sNamaEditKK]').val();
       "

       sCekAda=$sCekAda$"!adaDATA($sNamaNew) | "
       sCekEdit=$sCekEdit$"!adaDATA($sNamaEdit) | "

       sKolomNew=$sKolomNew$"
       $namakolomL: $sNamaNew,
       "

       sKolomEdit=$sKolomEdit$"
       $namakolomL: $sNamaEdit,
       "

       sHTMLDisplay=$sHTMLDisplay$" {{$namakolomL}} - "

       sHTMLEdit=$sHTMLEdit$"

       <div class='form-group label-floating has-info col-md-6'>
       <label for='$sNamaEdit' class='control-label'>$namakolomU $sDatabase</label>
       <input name='$sNamaEdit' id='$sNamaEdit' type='text' class='form-control' style='font-size:larger;' value='{{$namakolomL}}'>
       </div>

       "

       sHTMLNew=$sHTMLNew$"

       <div class='form-group label-floating has-info col-md-6'>
       <label for='$sNamaNew' class='control-label'>$namakolomU $sDatabase</label>
       <input name='$sNamaNew' id='$sNamaNew' type='text' class='form-control' style='font-size:larger;'>
       </div>
       "
    done

    sHTMLDisplayView=$(sed 's/.\{2\}$//' <<< "$sHTMLDisplay")
    sCekAdaData=$(sed 's/.\{2\}$//' <<< "$sCekAda")
    sCekEditData=$(sed 's/.\{2\}$//' <<< "$sCekEdit")

    [ -d "FLEXURIO-CORE/client/views/$2" ] || mkdir "FLEXURIO-CORE/client/views/$2"

    sDATE=`date`
    sBY=`uname -a`
    sUSER=`whoami`

    sFLX=$"
        /**
        * Generated from flexurio at $sDATE
        * By $sUSER at $sBY
        */

    import { Template } from 'meteor/templating';
    import { Session } from 'meteor/session';
    import './$3.html';

    Template.$3.created = function () {
       Session.set('limit', 50);
       Session.set('oFILTERS', {});
       Session.set('oOPTIONS', {});
       Session.set('textSearch', '');
       Session.set('namaHeader', 'DATA $sDatabase');
       Session.set('dataDelete', '');
       Session.set('isCreating', false);
       Session.set('isDeleting', false);

       this.autorun(function () {
              subscribtion('$3', Session.get('oFILTERS'), Session.get('oOPTIONS'), Session.get('limit'));
       });
     };

      Template.$3.onRendered(function () {
          ScrollHandler();
      });

      Template.$3.helpers({
          isLockMenu: function () {
              return isLockMenu();
          },

          isActionADD: function () {
              return isAdminActions(Session.get('sURLMenu'), 'ADD');
          },

          isActionEDIT: function () {
              return isAdminActions(Session.get('sURLMenu'), 'EDIT');
          },

          isActionDELETE: function () {
              return isAdminActions(Session.get('sURLMenu'), 'DELETE');
          },

          isActionPRINT: function () {
              return isAdminActions(Session.get('sURLMenu'), 'PRINT');
          },

       sTinggiPopUp: function () {
          return 0.6*(\$(window).height());
       },
       isEditing: function() {
          return Session.get('idEditing') == this._id;
       },
       isDeleting: function() {
          return Session.get('isDeleting');
       },
       isCreating: function() {
          return Session.get('isCreating');
       },
       $3s: function() {
          let textSearch = '';
          if(adaDATA(Session.get('textSearch'))) {
             textSearch = Session.get('textSearch').replace('#', '').trim();
          }

          let oOPTIONS = {
             sort: {createAt: -1},
             limit: Session.get('limit')
          }

          let oFILTERS = {
             aktifYN: 1,
             \$or: [
             $sFILTER
             {_id: { \$regex : new RegExp(textSearch, 'i') }},
             ]
          }

          return $sDatabase.find(
              oFILTERS,
              oOPTIONS
          );
       }
    });

    Template.$3.events({
       'click a.cancel': function(e, tpl){
          e.preventDefault();
          Session.set('isCreating', false);
          Session.set('isEditing', false);
          Session.set('idEditing', '');
          Session.set('isDeleting', false);
       },

       'click a.deleteDataOK': function(e, tpl){
          e.preventDefault();
          delete$sDatabase();
          FlashMessages.sendWarning('Attention, ' + Session.get('dataDelete') + ' successfully DELETE !');
          Session.set('isDeleting', false);
       },
       'click a.deleteData': function(e, tpl){
          e.preventDefault();
          Scroll2Top();

          Session.set('isDeleting', true);
          Session.set('dataDelete', Session.get('namaHeader').toLowerCase() + ' ' + this.nama$sDatabase);
          Session.set('idDeleting', this._id);
       },

       'click a.create': function(e, tpl){
          e.preventDefault();
          Scroll2Top();

          Session.set('isCreating', true);
       },
       'keyup #nama$sDatabase': function (e, tpl) {
          e.preventDefault();
          if (e.keyCode == 13) {
             insert$sDatabase(tpl);
          }
       },
       'click a.save': function(e, tpl){
          e.preventDefault();
          insert$sDatabase(tpl);
       },

       'click a.editData': function(e, tpl){
          e.preventDefault();
          Scroll2Top();

          Session.set('idEditing', this._id);
          Session.set('isEditing', true);
       },
       'keyup #namaEdit$sDatabase': function (e, tpl) {
          e.preventDefault();
          if (e.keyCode == 13) {
             update$sDatabase(tpl);
          }
       },
       'click a.saveEDIT': function(e, tpl){
          e.preventDefault();
          update$sDatabase(tpl);
       },
       'submit form.form-comments': function (e, tpl) {
          e.preventDefault();
          flxcomments(e,tpl,$sDatabase);
      }

    });


    insert$sDatabase = function (tpl) {

       $sNew

       if($sCekAdaData) {
          FlashMessages.sendWarning('Please complete all of the data to be . . .');
          return;
       }

       $sDatabase.insert(
       {
          $sKolomNew
          aktifYN: 1,
          createByID: UserID(),
          createBy:UserName(),
          createAt: new Date()
       },
       function (err, id) {
          if(err) {
             FlashMessages.sendWarning('Sorry, Data could not be saved - Please repeat again.');
          } else {
             Session.set('isCreating', false);
             FlashMessages.sendSuccess('Thanks, your data is successfully saved');
          }
       }
       );
    };


    update$sDatabase = function (tpl) {

       $sEdit

       if($sCekEditData) {
          FlashMessages.sendWarning('Please complete all of the data to be . . .');
          return;
       }

       $sDatabase.update({_id:Session.get('idEditing')},
       { \$set:{
          $sKolomEdit
          updateByID: UserID(),
          updateBy:UserName(),
          updateAt: new Date()
       }
    },
    function (err, id) {
       if(err) {
          FlashMessages.sendWarning('Sorry, Data could not be saved - Please repeat again.');
       } else {
          Session.set('idEditing', '');
          Session.set('isEditing', false);
          FlashMessages.sendSuccess('Thanks, your data is successfully saved');
       }
    }
    );
    };

    delete$sDatabase = function () {

    if(!adaDATA(Session.get('idDeleting'))) {
       FlashMessages.sendWarning('Please select data that you want to remove . . .');
       return;
    }

    $sDatabase.update({_id:Session.get('idDeleting')},
        { \$set:{
           aktifYN: 0,
           deleteByID: UserID(),
           deleteBy:UserName(),
           deleteAt: new Date()
        }
     },
     function (err, id) {
        if(err) {
           FlashMessages.sendWarning('Sorry, Data could not be saved - Please repeat again.');
        } else {
           Session.set('idEditing', '');
           FlashMessages.sendSuccess('Thanks, your data is successfully saved');
        }
     }
     );
    };


    "

    echo "$sFLX" >  "FLEXURIO-CORE/client/views/$2/$3.js"
    echo "JS bootstraping success created . . . "

    sFLXHTML=$"
    <!-- Generated from flexurio at $sDATE By $sUSER at $sBY -->

    <template name='$3'>
     <div class='container-fluid app'>
        {{>utama}}
        {{>menuSearch}}
        {{#if isActionADD}}
           {{>menuAdd}}
        {{/if}}

        <div class='row main {{isLockMenu}} animasiAtas'>

           <!-- HEADER LISTVIEW -->
           <div class='list-group panel panel-default headerApp'>
              {{>headerListview}}

              {{#each $3s}}
                 <div class='list-group-item'>
                    <div class='row-content'>
                       <BR>
                       <p>
                       $sHTMLDisplay
                       </p>

                          <div class='least-content' style='top:20px;'>
                             {{>actionListview}}
                          </div>
                    </div>
                 </div>

                  {{>flxcomments isCommentOpen=false _id=_id comments=comments}}

                 {{#if isEditing}}
                    {{>blockModals}}
                    <div class='container animasiAtas' style='position:fixed;top:10%;left:10%;width:80%;z-index:10001;'>
                       <div class='col-md-12' style='height:auto;max-height:{{sTinggiPopUp}}px;overflow-y:scroll;'>
                       $sHTMLEdit
                       </div>

                       <div class='pull-right'>
                       <a class='saveEDIT btn btn-primary' style='background-color:green;color:white;'>SAVE</a>
                       </div>
                    </div>
                 {{/if}}
              {{/each}}
           </div>
           {{>menuLoadMore}}
        </div>

        {{#if isCreating}}
           {{>blockModals}}
           <div class='container animasiAtas' style='position:fixed;top:10%;left:10%;width:80%;z-index:10001;'>
              <div class='col-md-12' style='height:auto;max-height:{{sTinggiPopUp}}px;overflow-y:scroll;'>
              $sHTMLNew
              </div>

              <div class='pull-right'>
                 <a class='save btn btn-primary' style='background-color:green;color:white;'>SAVE</a>
              </div>
           </div>
        {{/if}}

        {{#if isDeleting}}
           {{>formDeleting}}
        {{/if}}
     </div>
    </template>

    "

    echo "$sFLXHTML" >  "FLEXURIO-CORE/client/views/$2/$3.html"
    echo "HTML bootstraping success created . . . "

    echo "$sDatabase = new Mongo.Collection('$3'); " > .temp
    cat .temp >> FLEXURIO-CORE/lib/collections.js
    echo "COLLECTIONS bootstraping success created . . . "

    echo "publishData('$3', $sDatabase, {}, {});" > .temp
    cat .temp >> FLEXURIO-CORE/server/publications.js
    echo "PUBLICATIONS bootstraping success created . . . "

    sAuthPub=$"
    $sDatabase.allow({
     'insert': function (userId, doc) {
        return true;
     },
     'remove': function (userId, doc) {
         if (Roles.userIsInRole(userId, ['root', 'administrator'])) {
             return true;
         } else {
             return false;
         }
     },
     'update': function (userId, doc, fieldNames, modifier) {
        return true;
     }
    });
    "
    echo "$sAuthPub" > .temp
    cat .temp >> "$LOKASINIPUN/FLEXURIO-CORE/server/publicationsAuth.js"
    echo "AUTH PUBLICATIONS bootstraping success created . . . "


    sROUT=$"
    Router.route('/$3', function () {
      Session.set('sURLMenu', '$3');
     this.render('$3');
    });
    "

    echo "$sROUT" > .temp
    cat .temp >> "$LOKASINIPUN/FLEXURIO-CORE/lib/router.js"
    echo "ROUTES bootstraping success created . . . "
fi
