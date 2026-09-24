"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3StatementPreparedEvent
	instanceVariableNames: 'statement query'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3StatementPreparedEvent guid: (GUID fromString: '{b2dd505f-85bb-4426-a1f4-cb6555cc1c9b}')!

P3StatementPreparedEvent comment: 'I am P3StatementPreparedEvent.I am a P3LogEvent.I represent a P3PreparedStatement, an SQL query (statement) prepared (preparsed) by PostgreSQL.'!

!P3StatementPreparedEvent categoriesForClass!P3-Logging! !

!P3StatementPreparedEvent methodsFor!

printContentsOn: stream	stream print: #Prepare.	stream space.	self query do: [ :each |		(String lineDelimiter includes: each) 			ifTrue: [ stream space ]			ifFalse: [ stream nextPut: each ] ].	stream 		nextPutAll: ', '; 		print: self statement paramCount;		nextPutAll: ' parameter(s)'!

query	^ query!

query: anObject	query := anObject!

statement	^ statement!

statement: anObject	statement := anObject! !

!P3StatementPreparedEvent categoriesForMethods!
printContentsOn:!printing!public! !
query!accessing!public! !
query:!initialization!public! !
statement!accessing!public! !
statement:!initialization!public! !
!

