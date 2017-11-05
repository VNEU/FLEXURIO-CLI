#!/bin/bash
LOKASINIPUN=$PWD
if [ "$1" == "server-newmodule" ]; then
    sDatabase=$(echo $3 | tr 'a-z' 'A-Z')
    sDatabaseL=$(echo "$sDatabase" | tr '[:upper:]' '[:lower:]')
    sDatabaseInput="$sDatabase DocInput"
    sDatabaseInput="${sDatabaseInput/ /}"
    sDatabaseLs="$sDatabaseL s"
    sDatabaseLs="${sDatabaseLs/ /}"


    sKK=$'"'
    sNew=$""
    sKolomNew=$""
    sKolomEdit=$""
    sCekAda=$""
    sCekAdaData=$""
    sDOMEdit=$""

    sHTMLDisplay=$""
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

       sDOMEdit=$sDOMEdit$"
       document.getElementById('$namakolomL').value = this.$sNamaNew;
       "

       sNew=$sNew$"
       let $sNamaNew = tpl.\$('input[name=$sNamaNewKK]').val();
       "

       sCekAda=$sCekAda$"!adaDATA($sNamaNew) | "

       sKolomNew=$sKolomNew$"
       $namakolomL: $sNamaNew,
       "

       sKolomEdit=$sKolomEdit$"
       $namakolomL: $sNamaEdit,
       "

       sHTMLDisplay=$sHTMLDisplay$" {{$namakolomL}} - "

       sHTMLNew=$sHTMLNew$"
        <label for='$sNamaNew' class='control-label'>$namakolomU $sDatabase</label>
        <input name='$sNamaNew' id='$sNamaNew' type='text' class='form-control' style='font-size:larger;' autofocus>
       "
    done

    sHTMLDisplayView=$(sed 's/.\{2\}$//' <<< "$sHTMLDisplay")
    sCekAdaData=$(sed 's/.\{2\}$//' <<< "$sCekAda")

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
          Session.set('idEditing', '');
       },

       'click a.deleteDataOK': function(e, tpl){
          e.preventDefault();
          delete$sDatabase();
          FlashMessages.sendWarning('Attention, ' + Session.get('dataDelete') + ' successfully DELETE !');
          \$('#modal_formDeleting').modal('hide');
       },
       'click a.deleteData': function(e, tpl){
          e.preventDefault();
          Session.set('dataDelete', Session.get('namaHeader').toLowerCase() + ' ' + this.nama$sDatabase);
          Session.set('idDeleting', this._id);
          \$('#modal_formDeleting').modal('show');
       },

       'click a.create': function(e, tpl){
          e.preventDefault();
          \$('#modal_$3').modal('show')
       },
       'keyup #nama$sDatabase': function (e, tpl) {
           e.preventDefault();
           if (e.keyCode == 13) {
               if (adaDATA(Session.get('idEditing'))) {
                   update$sDatabase(tpl);
               } else {
                   insert$sDatabase(tpl);
               }
           }
       },
       'click a.save': function(e, tpl){
            e.preventDefault();
            if (adaDATA(Session.get('idEditing'))) {
                update$sDatabase(tpl);
            } else {
                insert$sDatabase(tpl);
            }
          \$('#modal_$3').modal('hide')
       },

       'click a.editData': function(e, tpl){
          e.preventDefault();
          $sDOMEdit
          Session.set('idEditing', this._id);
          \$('#modal_$3').modal('show')
       },
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

        $sNew

       if($sCekAdaData) {
          FlashMessages.sendWarning('Please complete all of the data to be . . .');
          return;
       }

       $sDatabase.update({_id:Session.get('idEditing')},
       { \$set:{
          $sKolomNew
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
        {{>formDeleting}}
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
              {{/each}}
           </div>
           {{>menuLoadMore}}
        </div>


        <div class='modal_$3 modal' id='modal_$3' name='modal_$3'>
            <div class='modal-dialog' role='document'>
                <div class='modal-content'>
                    <div class='modal-body'>
                        <div class='form-group label-floating has-info col-md-12'>
                        $sHTMLNew
                        </div>
                        <div class='modal-footer'>
                            <a class='save btn btn-primary' style='background-color:green;color:white;'>SAVE</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

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
