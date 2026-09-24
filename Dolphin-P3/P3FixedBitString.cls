"Filed out from Dolphin Smalltalk"!

P3BitString subclass: #P3FixedBitString
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3FixedBitString guid: (GUID fromString: '{46f33c60-9f21-4285-9083-ee1f639384dd}')!

P3FixedBitString comment: 'I am P3FixedBitString.I am a P3BitString.I represent the BIT(N) type, with a fixed length/size.'!

!P3FixedBitString categoriesForClass!P3-Objects! !

!P3FixedBitString methodsFor!

= anotherFixedBitString	self == anotherFixedBitString ifTrue: [ ^ true ].	self class = anotherFixedBitString class ifFalse: [ ^ false ].	^ bits = anotherFixedBitString bits and: [ size = anotherFixedBitString size ]!

bitAt: index	(index between: 1 and: size)		ifFalse: [ 
			self errorSubscriptBounds: index ].	^ super bitAt: index!

bitAt: index put: value	(index between: 1 and: size)		ifFalse: [ 			self errorSubscriptBounds: index].	^ super bitAt: index put: value!

hash	^ (super hash + size hash) hashMultiply!

initialize	super initialize.	size := 1!

size	^ size!

size: numberOfBits	size := numberOfBits ! !

!P3FixedBitString categoriesForMethods!
=!comparing!public! !
bitAt:!accessing!public! !
bitAt:put:!accessing!public! !
hash!comparing!public! !
initialize!initialization!public! !
size!accessing!public! !
size:!private! !
!

!P3FixedBitString class methodsFor!

bits: integer	^ self bits: integer count: (integer highBit max: 1)!

bits: integer count: count	^ self new 		bits: integer;		size: count;		yourself! !

!P3FixedBitString class categoriesForMethods!
bits:!instance creation!public! !
bits:count:!instance creation!public! !
!

