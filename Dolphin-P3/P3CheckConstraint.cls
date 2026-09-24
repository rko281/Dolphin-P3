"Filed out from Dolphin Smalltalk"!

P3Constraint subclass: #P3CheckConstraint
	instanceVariableNames: 'checkClause'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3CheckConstraint guid: (GUID fromString: '{a4504617-471c-4226-b50e-213ad93104be}')!

P3CheckConstraint comment: 'I am P3CheckConstraint.I am a P3Constraint.I implement SQL CHECK.I know my check clause.'!

!P3CheckConstraint categoriesForClass!P3-Support! !

!P3CheckConstraint methodsFor!

checkClause	^ checkClause!

checkClause: anObject	checkClause := anObject!

constraintType	^ 'CHECK'!

loadDetailsUsing: client	| statement result |	super loadDetailsUsing: client.	statement := client format: 'SELECT check_clause FROM information_schema.check_constraints WHERE constraint_schema = $1 AND constraint_name = $2'.	result := statement query: { self constraintSchema . self constraintName }.	self checkClause: result firstFieldOfFirstRecord!

sqlDescription	^ String streamContents: [ :out |		out nextPutAll: 'CHECK'.		self checkClause ifNotNil: [ :clause | 			out space; nextPutAll: clause ] ]! !

!P3CheckConstraint categoriesForMethods!
checkClause!accessing!public! !
checkClause:!accessing!public! !
constraintType!accessing!public! !
loadDetailsUsing:!accessing!public! !
sqlDescription!accessing!public! !
!

!P3CheckConstraint class methodsFor!

handlesType: type	^ type = 'CHECK'! !

!P3CheckConstraint class categoriesForMethods!
handlesType:!accessing!public! !
!

