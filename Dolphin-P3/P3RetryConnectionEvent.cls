"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3RetryConnectionEvent
	instanceVariableNames: 'remaining delay'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3RetryConnectionEvent guid: (GUID fromString: '{53b3e650-8529-49b0-b1f5-a3394798c74e}')!

P3RetryConnectionEvent comment: 'I am P3RetryConnectionEvent.I am a P3LogEvent.I represent the fact that a PostgreSQL client connection failed and is being retried.'!

!P3RetryConnectionEvent categoriesForClass!P3-Logging! !

!P3RetryConnectionEvent methodsFor!

delay	^ delay!

delay: anObject	delay := anObject!

printContentsOn: stream	stream print: #RetryConnection; space; print: remaining; nextPutAll: ' remaining, after '; print: delay; nextPut: $s!

remaining	^ remaining!

remaining: anObject	remaining := anObject! !

!P3RetryConnectionEvent categoriesForMethods!
delay!accessing!public! !
delay:!accessing!public! !
printContentsOn:!printing!public! !
remaining!accessing!public! !
remaining:!accessing!public! !
!

