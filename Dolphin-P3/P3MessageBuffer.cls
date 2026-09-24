"Filed out from Dolphin Smalltalk"!

Object subclass: #P3MessageBuffer
	instanceVariableNames: 'tag payload size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3MessageBuffer guid: (GUID fromString: '{396dc215-54a2-4dee-8fae-fe1db314ff08}')!

P3MessageBuffer comment: 'I am P3MessageBuffer.I am a reusable buffer to hold a single protocol message read.I try to prevent allocations as much as possible.I grow as needed.'!

!P3MessageBuffer categoriesForClass!P3-Support! !

!P3MessageBuffer methodsFor!

capacity	^ self rawByteBuffer size!

initialize	super initialize.	self initializeForSize: 0!

initializeForSize: actualSize	(payload isNil or: [ actualSize > self capacity ])		ifTrue: [ payload := (ByteArray new: ((actualSize // 1024) + 1) * 1024) readStream ].	size := actualSize.	payload p3setFrom: 1 to: size!

payloadCopy	^ self rawByteBuffer copyFrom: 1 to: size!

rawByteBuffer	^ payload collection!

readFrom: readStream
	| length |
	self tag: readStream next asCharacter.
	length := (self uint32From: readStream) - 4.
	self initializeForSize: length.
	length > 0
		ifTrue: [ readStream next: self size into: self rawByteBuffer ]!

readStream	^ payload!

size	^ size!

tag	^ tag!

tag: character	tag := character!

uint32From: stream	| uint32 |	uint32 := stream next.	uint32 := (uint32 bitShift: 8) + stream next.	uint32 := (uint32 bitShift: 8) + stream next.	uint32 := (uint32 bitShift: 8) + stream next.	^ uint32! !

!P3MessageBuffer categoriesForMethods!
capacity!accessing!public! !
initialize!initialization!public! !
initializeForSize:!initialization!public! !
payloadCopy!accessing!public! !
rawByteBuffer!accessing!public! !
readFrom:!initialization!public! !
readStream!accessing!public! !
size!accessing!public! !
tag!accessing!public! !
tag:!initialization!public! !
uint32From:!public!reading! !
!

