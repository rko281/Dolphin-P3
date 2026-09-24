"Filed out from Dolphin Smalltalk"!

P3Constraint subclass: #P3UniqueConstraint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3UniqueConstraint guid: (GUID fromString: '{057f00d4-dfa9-4a60-abdc-5d5ae2418770}')!

P3UniqueConstraint comment: ''!

!P3UniqueConstraint categoriesForClass!P3-Support! !

!P3UniqueConstraint methodsFor!

constraintType	^ 'UNIQUE'!

sqlDescription	^ String streamContents: [ :out |		out nextPutAll: 'UNIQUE'.		(self constraintColumns ifNil: ['']) isEmpty ifFalse: [			out 				nextPutAll: ' ('; 				nextPutAll: ($, join: self constraintColumns); 				nextPut: $) ] ]! !

!P3UniqueConstraint categoriesForMethods!
constraintType!accessing!public! !
sqlDescription!accessing!public! !
!

!P3UniqueConstraint class methodsFor!

handlesType: type	^ type = 'UNIQUE'! !

!P3UniqueConstraint class categoriesForMethods!
handlesType:!accessing!public! !
!

