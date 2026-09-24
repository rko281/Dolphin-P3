"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3ResultReadEvent
	instanceVariableNames: 'result duration'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ResultReadEvent guid: (GUID fromString: '{8706a7b1-d385-46f1-8a88-cb2202deafb6}')!

P3ResultReadEvent comment: 'I am P3ResultReadEvent.I am a P3LogEvent.I represent a P3Result of a previously sent SQL query (statement) received from PostgreSQL.I hold the duration it took to execute the query and transfer the resulting data.Note that I hold all data returned.'!

!P3ResultReadEvent categoriesForClass!P3-Logging! !

!P3ResultReadEvent methodsFor!

duration	^ duration!

duration: anObject	duration := anObject!

printContentsOn: stream	stream print: #Result.	stream space.	self result printInfoOn: stream.	stream nextPutAll: ', '; print: self duration; nextPutAll: ' ms'!

result	^ result!

result: anObject	result := anObject! !

!P3ResultReadEvent categoriesForMethods!
duration!accessing!public! !
duration:!initialization!public! !
printContentsOn:!printing!public! !
result!accessing!public! !
result:!initialization!public! !
!

