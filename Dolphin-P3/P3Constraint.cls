"Filed out from Dolphin Smalltalk"!

Object subclass: #P3Constraint
	instanceVariableNames: 'constraintSchema constraintName tableSchema tableName isDeferrable initiallyDeferred enforced constraintColumns'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Constraint guid: (GUID fromString: '{b82c803d-e8a9-4664-be8a-bf10d8a59b49}')!

P3Constraint comment: 'I am P3Constraint.I am an abstract class.I represent an SQL constraint.I have- a name- a schem:table that I am defined on- a list of columns on which I am applicableI can reproduce my SQL definition.Use me to get all constraints for a given table.My concrete subclasses implement actual constraint types. '!

!P3Constraint categoriesForClass!P3-Support! !

!P3Constraint methodsFor!

constraintColumns	^ constraintColumns!

constraintColumns: anObject	constraintColumns := anObject!

constraintName	^ constraintName!

constraintName: anObject	constraintName := anObject!

constraintSchema	^ constraintSchema!

constraintSchema: anObject	constraintSchema := anObject!

constraintType	self subclassResponsibility!

enforced	^ enforced!

enforced: anObject	enforced := anObject!

initiallyDeferred	^ initiallyDeferred!

initiallyDeferred: anObject	initiallyDeferred := anObject!

isCheck	^ self constraintType = 'CHECK'!

isDeferrable	^ isDeferrable!

isDeferrable: anObject	isDeferrable := anObject!

isForeignKey	^ self constraintType = 'FOREIGN KEY'!

isPrimaryKey	^ self constraintType = 'PRIMARY KEY'!

isUnique	^ self constraintType = 'UNIQUE'!

loadDetailsUsing: client	| statement result |	statement := client format: 'SELECT column_name FROM information_schema.key_column_usage WHERE constraint_schema = $1 AND constraint_name = $2'.	result := statement query: { self constraintSchema . self constraintName }.	self constraintColumns: result firstColumnData!

printOn: stream	super printOn: stream.	stream nextPut: $(. 	self constraintName ifNotNil: [ :name | 		stream nextPutAll: name ]. 	self sqlDescription ifNotNil: [ :description |		self constraintName ifNotNil: [ stream space ].		stream nextPutAll: description ].	stream nextPut: $)!

sqlDescription	self subclassResponsibility!

tableName	^ tableName!

tableName: anObject	tableName := anObject!

tableSchema	^ tableSchema!

tableSchema: anObject	tableSchema := anObject! !

!P3Constraint categoriesForMethods!
constraintColumns!accessing!public! !
constraintColumns:!accessing!public! !
constraintName!accessing!public! !
constraintName:!accessing!public! !
constraintSchema!accessing!public! !
constraintSchema:!accessing!public! !
constraintType!accessing!public! !
enforced!accessing!public! !
enforced:!accessing!public! !
initiallyDeferred!accessing!public! !
initiallyDeferred:!accessing!public! !
isCheck!public!testing! !
isDeferrable!accessing!public! !
isDeferrable:!accessing!public! !
isForeignKey!public!testing! !
isPrimaryKey!public!testing! !
isUnique!public!testing! !
loadDetailsUsing:!accessing!public! !
printOn:!accessing!public! !
sqlDescription!accessing!public! !
tableName!accessing!public! !
tableName:!accessing!public! !
tableSchema!accessing!public! !
tableSchema:!accessing!public! !
!

!P3Constraint class methodsFor!

allForTable: tableName in: schemaName using: client	| statement result specificClass constraint |	statement := client format: 'SELECT constraint_schema, constraint_name, constraint_type, is_deferrable, initially_deferred, enforced FROM information_schema.table_constraints WHERE table_schema = $1 AND table_name= $2'.	result := statement query: { schemaName . tableName }.	^ result data collect: [ :row |		specificClass := self subclasses 							detect: [ :each | each handlesType: row third ] 							ifNone: [ self error: 'unknown contraint type' ].		constraint := specificClass new.		constraint			tableSchema: schemaName;			tableName: tableName;			constraintSchema: row first;			constraintName: row second;			isDeferrable: row fourth = 'YES';			initiallyDeferred: row fifth = 'YES';			enforced: row = 'YES'.		constraint loadDetailsUsing: client.		constraint ]!

handlesType: type	self subclassResponsibility!

referencingConstraintNamesForTable: tableName in: schemaName using: client	"Return (table_name, constraint_name) pairs where the given schemaName:tableName is referenced.	Do not return the actual constraint object as this might be costly to compute."	| statement result |	statement := client format: 'SELECT tc.table_name, ctu.constraint_nameFROM information_schema.constraint_table_usage AS ctu, information_schema.table_constraints AS tcWHERE ctu.table_schema = $1 AND ctu.table_name = $2 AND ctu.constraint_name = tc.constraint_name AND tc.constraint_type = ''FOREIGN KEY'''.	result := statement query: { schemaName . tableName }.	^ result data! !

!P3Constraint class categoriesForMethods!
allForTable:in:using:!accessing!public! !
handlesType:!accessing!public! !
referencingConstraintNamesForTable:in:using:!accessing!public! !
!

