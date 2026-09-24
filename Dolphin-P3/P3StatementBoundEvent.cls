"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3StatementBoundEvent
	instanceVariableNames: 'statement inputValues'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3StatementBoundEvent guid: (GUID fromString: '{53a0cbb6-4f1b-4bd9-a75e-479822db6a91}')!

P3StatementBoundEvent comment: 'I am P3StatementBoundEvent.I am a P3LogEvent.I represent binding of a previously prepared P3PreparedStatement.Note that I hold all data used.'!

!P3StatementBoundEvent categoriesForClass!P3-Logging! !

!P3StatementBoundEvent methodsFor!

inputValues	^ inputValues!

inputValues: anObject	inputValues := anObject!

printContentsOn: stream	stream print: #Bind.	stream space.	self statement name do: [ :each |		(String lineDelimiter includes: each) 			ifTrue: [ stream space ]			ifFalse: [ stream nextPut: each ] ].	stream 		nextPutAll: ', ';  		print: self statement paramCount; 		nextPutAll: (' value(s)' )!

statement	^ statement!

statement: anObject	statement := anObject! !

!P3StatementBoundEvent categoriesForMethods!
inputValues!accessing!public! !
inputValues:!initialization!public! !
printContentsOn:!printing!public! !
statement!accessing!public! !
statement:!initialization!public! !
!

