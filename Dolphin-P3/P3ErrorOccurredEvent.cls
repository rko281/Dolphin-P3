"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3ErrorOccurredEvent
	instanceVariableNames: 'exception'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ErrorOccurredEvent guid: (GUID fromString: '{87b1154b-8e02-4ae3-acfc-a3a5ae649195}')!

P3ErrorOccurredEvent comment: 'I am P3ErrorOccurredEvent.I am a P3LogEvent.I represent the occurrence of a P3Error or P3Notification.'!

!P3ErrorOccurredEvent categoriesForClass!P3-Logging! !

!P3ErrorOccurredEvent methodsFor!

exception	^ exception!

exception: anObject	exception := anObject!

printContentsOn: stream	stream print: #Error; space; nextPutAll: self exception description! !

!P3ErrorOccurredEvent categoriesForMethods!
exception!accessing!public! !
exception:!initialization!public! !
printContentsOn:!printing!public! !
!

