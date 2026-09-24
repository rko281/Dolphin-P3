"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3QueryWrittenEvent
	instanceVariableNames: 'query'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3QueryWrittenEvent guid: (GUID fromString: '{69900cbf-8529-4949-ac7c-004e6d2857aa}')!

P3QueryWrittenEvent comment: 'I am P3QueryWrittenEvent.I am a P3LogEvent.I represent an SQL query (statement) that was sent to PostgreSQL.'!

!P3QueryWrittenEvent categoriesForClass!P3-Logging! !

!P3QueryWrittenEvent methodsFor!

printContentsOn: stream	stream print: #Query.	stream space.	self query do: [ :each |		(String lineDelimiter includes: each) 			ifTrue: [ stream space ]			ifFalse: [ stream nextPut: each ] ]!

query	^ query!

query: anObject	query := anObject! !

!P3QueryWrittenEvent categoriesForMethods!
printContentsOn:!printing!public! !
query!accessing!public! !
query:!initialization!public! !
!

