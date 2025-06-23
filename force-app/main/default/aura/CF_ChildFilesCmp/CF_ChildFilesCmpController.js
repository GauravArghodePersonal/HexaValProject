({
    onInit : function( component, event, helper ) {

        var objectName = component.get( 'v.sObjectName' );
        var recordId = component.get( 'v.recordId' );
        var fieldSetName = component.get( 'v.fieldSetName' );

        Promise.all([
                helper.getRelatedFilesColumnsAsync( component, fieldSetName ),        // FieldSetMember
                helper.getObjectDescribeAsync( component, objectName )  // DescribeSObjectResult
            ]).then( $A.getCallback( function( results ) {

                var fieldSetColumns = results[0];
                var objectDescribe = results[1];

                component.set( 'v.columns', helper.transformToDataTableColumns( fieldSetColumns ) );
                component.set( 'v.sObjectDescribe', objectDescribe );

                var selectedIndex = component.get( 'v.selectedIndex' );
                var filesAndNotesFilter = component.get( 'v.filesAndNotesFilter' );
                var childRelationshipNames = component.get( 'v.childRelationshipNames' );
                var childRelationshipFiles = [];

                // if specific list of relationship names are not provided
                // then use all available child relationships in object describe
                if ( $A.util.isEmpty( childRelationshipNames ) ) {
                    childRelationshipNames = helper.getChildRelationshipNamesSorted( component, objectDescribe );
                } else {
                    childRelationshipNames = childRelationshipNames.split( ',' );
                }

                if ( !$A.util.isEmpty( childRelationshipNames ) ) {

                    for ( var i = 0; i < childRelationshipNames.length; i++ ) {

                        var relationshipName = childRelationshipNames[i].trim().toUpperCase();
                        var isSelected = ( i == selectedIndex );

                        childRelationshipFiles[i] = {
                            'name' : relationshipName,
                            'describe' : objectDescribe.childRelationships[relationshipName],
                            'selected' : isSelected,
                            'files' : null
                        };

                        if ( isSelected ) {
                            component.set( 'v.selectedRelationship', childRelationshipFiles[i] );
                        }

                    }

                }

                component.set( 'v.childRelationshipFiles', childRelationshipFiles );

                return helper.loadAllChildRelationshipFilesAsync( component );

            })).catch( $A.getCallback( function( err ) {

                helper.toastMessage( 'Sorry, error initializing component', err, 'error' );

            }));

    },

    onDataTableSort : function( component, event, helper ) {

        var sortedByFieldName = event.getParam( 'fieldName' );
        var sortedDirection = event.getParam( 'sortDirection' );

        component.set( 'v.sortedByFieldName', sortedByFieldName );
        component.set( 'v.sortedDirection', sortedDirection );

        // TODO implement sort
        // things to consider,
        //      when field name starts with 'LinkTo' then
        //      the real field name is that without the 'LinkTo' prefix,
        //      and since that field refers to a lookup field, what we
        //      really want to sort by is that referenced object's "name" field.
        //      For example:
        //          "LinkToOwnerId" => "OwnerId" => "Owner.Name"

    },

    onChildRelationshipClick : function( component, event, helper ) {

        var childRelationshipFiles = component.get( 'v.childRelationshipFiles' );
        var selectedIndex = component.get( 'v.selectedIndex' );
        var clickedIndex = event.currentTarget.getAttribute( 'data-index' );

        childRelationshipFiles[selectedIndex].selected = false;
        childRelationshipFiles[clickedIndex].selected = true;

        component.set( 'v.selectedFiles', childRelationshipFiles[clickedIndex].files );
        component.set( 'v.childRelationshipFiles', childRelationshipFiles );
        component.set( 'v.selectedIndex', clickedIndex );
        component.set( 'v.selectedRelationship', childRelationshipFiles[clickedIndex] );

        helper.getRelatedFilesForIndexAsync( component, clickedIndex, false )
            .catch( $A.getCallback( function( err ) {

                helper.toastMessage( 'Sorry, error getting files', err, 'error' );

            }));

    },

    onFileClick : function( component, event, helper ) {

        var clickedFileId = event.srcElement.getAttribute( 'data-fileId' );
        var fileIds = component.get( 'v.selectedFiles' ).map( function( file ) { return file.ContentDocumentId; } );

        helper.navigateToFiles( clickedFileId, fileIds );

    },

    onUserClick : function( component, event, helper ) {

        var clickedUserId = event.srcElement.getAttribute( 'data-userId' );

        helper.navigateToRecord( clickedUserId );

    }
})