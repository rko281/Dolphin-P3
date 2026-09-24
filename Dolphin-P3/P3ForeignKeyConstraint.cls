"Filed out from Dolphin Smalltalk"!

P3Constraint subclass: #P3ForeignKeyConstraint
	instanceVariableNames: 'foreignKeyTable foreignKeyColumns'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ForeignKeyConstraint guid: (GUID fromString: '{37243091-7291-473a-8ac8-1f50d4e017ad}')!

P3ForeignKeyConstraint comment: 'I am P3ForeignKeyConstraint.I am a P3Constraint.I implement SQL FOREIGN KEY.I know to table and columns that I reference.'!

!P3ForeignKeyConstraint categoriesForClass!P3-Support! !

!P3ForeignKeyConstraint methodsFor!

constraintType	^ 'FOREIGN KEY'!

foreignKeyColumns	^ foreignKeyColumns!

foreignKeyColumns: anObject	foreignKeyColumns := anObject!

foreignKeyTable	^ foreignKeyTable!

foreignKeyTable: anObject	foreignKeyTable := anObject!

loadDetailsUsing: client	| statement result |	super loadDetailsUsing: client.	statement := client format: 'SELECT column_name FROM information_schema.constraint_column_usage WHERE constraint_schema = $1 AND constraint_name = $2'.	result := statement query: { self constraintSchema . self constraintName }.	self foreignKeyColumns: result firstColumnData.	statement := client format: 'SELECT table_name FROM information_schema.constraint_table_usage WHERE constraint_schema = $1 AND constraint_name = $2'.	result := statement query: { self constraintSchema . self constraintName }.	self foreignKeyTable: result firstFieldOfFirstRecord!

sqlDescription	^ String streamContents: [ :out |		out nextPutAll: 'FOREIGN KEY'.		((self constraintColumns ifNil: ['']) isEmpty				or: [ (self foreignKeyColumns  ifNil: ['']) isEmpty 						or: [ self foreignKeyTable isNil ] ])			ifFalse: [				out nextPutAll: ' ('; 				nextPutAll: ($, join: self constraintColumns); 				nextPutAll: ') REFERENCES ';				nextPutAll: self foreignKeyTable;				nextPut: $(;				nextPutAll: ($, join: self foreignKeyColumns);				nextPut: $) ] ]! !

!P3ForeignKeyConstraint categoriesForMethods!
constraintType!accessing!public! !
foreignKeyColumns!accessing!public! !
foreignKeyColumns:!accessing!public! !
foreignKeyTable!accessing!public! !
foreignKeyTable:!accessing!public! !
loadDetailsUsing:!accessing!public! !
sqlDescription!accessing!public! !
!

!P3ForeignKeyConstraint class methodsFor!

handlesType: type	^ type = 'FOREIGN KEY'! !

!P3ForeignKeyConstraint class categoriesForMethods!
handlesType:!accessing!public! !
!

