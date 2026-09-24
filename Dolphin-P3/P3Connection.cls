"Filed out from Dolphin Smalltalk"!

Object subclass: #P3Connection
	instanceVariableNames: 'socket readStream writeStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Connection guid: (GUID fromString: '{f3056261-882c-4090-b6c3-c8b20246fc39}')!

P3Connection comment: ''!

!P3Connection categoriesForClass!Kernel-Objects! !

!P3Connection methodsFor!

close

	socket close!

flush

	writeStream flush!

isConnected

	^socket isOpen!

next

	^readStream next!

next: anInteger

	^readStream next: anInteger!

next: anInteger into: aCollection

	1 to: anInteger do: [ :index | aCollection at: index put: readStream next]!

nextPut: anObject

	writeStream nextPut: anObject!

nextPutAll: anObject

	writeStream nextPutAll: anObject!

on: aSocket

	socket := aSocket.
	readStream := aSocket readStream.
	writeStream := aSocket writeStream!

secureConnection

	socket secureConnection! !

!P3Connection categoriesForMethods!
close!operations!public! !
flush!public!writing! !
isConnected!public!testing! !
next!public!reading! !
next:!public!reading! !
next:into:!public!reading! !
nextPut:!public!writing! !
nextPutAll:!public!writing! !
on:!initializing!public! !
secureConnection!operations!public! !
!

!P3Connection class methodsFor!

on: aSocket

	^self new
		on: aSocket;
		yourself! !

!P3Connection class categoriesForMethods!
on:!public! !
!

