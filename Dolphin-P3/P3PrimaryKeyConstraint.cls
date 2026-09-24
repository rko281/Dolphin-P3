"Filed out from Dolphin Smalltalk"!

P3Constraint subclass: #P3PrimaryKeyConstraint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3PrimaryKeyConstraint guid: (GUID fromString: '{033e2011-4090-4f61-887b-8b4a996bc195}')!

P3PrimaryKeyConstraint comment: ''!

!P3PrimaryKeyConstraint categoriesForClass!P3-Support! !

!P3PrimaryKeyConstraint methodsFor!

constraintType	^ 'PRIMARY KEY'!

sqlDescription	^ String streamContents: [ :out |		out nextPutAll: 'PRIMARY KEY'.		(self constraintColumns ifNil: ['']) isEmpty ifFalse: [			out 				nextPutAll: ' ('; 				nextPutAll: ($, join: self constraintColumns); 				nextPut: $) ] ]! !

!P3PrimaryKeyConstraint categoriesForMethods!
constraintType!accessing!public! !
sqlDescription!accessing!public! !
!

!P3PrimaryKeyConstraint class methodsFor!

handlesType: type	^ type = 'PRIMARY KEY'! !

!P3PrimaryKeyConstraint class categoriesForMethods!
handlesType:!accessing!public! !
!

