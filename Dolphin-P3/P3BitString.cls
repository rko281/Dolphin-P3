"Filed out from Dolphin Smalltalk"!

Object subclass: #P3BitString
	instanceVariableNames: 'bits'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3BitString guid: (GUID fromString: '{c0df50d6-a8b2-4450-b7cc-39ce334c8ded}')!

P3BitString comment: 'I am P3BitString.Note that PSQL''s B''100'' is actually 2r001 in Pharo.My internal representation is an Integer.I am of the BIT VARYING type, with a flexible, as needed, length/size.'!

!P3BitString categoriesForClass!P3-Objects! !

!P3BitString methodsFor!

= anotherBitString	self == anotherBitString ifTrue: [ ^ true ].	self class = anotherBitString class ifFalse: [ ^ false ].	^ bits = anotherBitString bits!

bitAt: index	"One based index (PSQL is zero based), returns 0 or 1"		^ bits bitAt: index!

bitAt: index put: value	"One based index (PSQL is zero based), value must be 0 or 1"		bits := bits bitAt: index put: value!

bits	^ bits!

bits: integer	bits := integer!

hash	^ bits hash!

initialize	super initialize.	bits := 0!

p3PrintUsing: delegate on: stream	"Print me on stream via double dispatch on delegate.	Check the implementors of #p3PrintUsing:on:"	delegate printBitString: self on: stream!

printOn: stream	1 to: self size do: [ :index |		stream nextPut: (48 + (bits bitAt: index)) asCharacter ]!

size	^ bits = 0 ifTrue: [ 1 ] ifFalse: [ bits highBit ]! !

!P3BitString categoriesForMethods!
=!comparing!public! !
bitAt:!accessing!public! !
bitAt:put:!accessing!public! !
bits!accessing!public! !
bits:!private! !
hash!comparing!public! !
initialize!initialization!public! !
p3PrintUsing:on:!printing!public! !
printOn:!printing!public! !
size!accessing!public! !
!

!P3BitString class methodsFor!

bits: integer	^ self new		bits: integer;		yourself!

bits: integer count: count	^ self bits: integer!

one	^ self bits: 1!

readFrom: stream	| bits index |	bits := 0.	index := 1.	[ stream atEnd or: [ ('01' includes: stream peek) not ] ] whileFalse: [ 		bits := bits bitAt: index put: (stream next asciiValue - 48).		index := index + 1 ].	^ self bits: bits count: index - 1!

zero	^ self new! !

!P3BitString class categoriesForMethods!
bits:!instance creation!public! !
bits:count:!instance creation!public! !
one!instance creation!public! !
readFrom:!instance creation!public! !
zero!instance creation!public! !
!

