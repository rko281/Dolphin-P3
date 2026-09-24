"Filed out from Dolphin Smalltalk"!

P3GeometricObject subclass: #P3Circle
	instanceVariableNames: 'center radius'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Circle guid: (GUID fromString: '{e525a29c-ae99-4ced-91e8-72164cf0993e}')!

P3Circle comment: 'I am P3Circle	<(x,y),r>I am a P3GeometricObjectMy internal representation is a center point and a radius'!

!P3Circle categoriesForClass!P3-Objects! !

!P3Circle methodsFor!

= anotherCircle	self == anotherCircle ifTrue: [ ^ true ].	self class = anotherCircle class ifFalse: [ ^ false ].	^ center = anotherCircle center and: [ radius = anotherCircle radius ]!

area	^ Float pi * radius squared !

center	^ center!

center: point	center := point!

circumference	^ 2 * Float pi * radius!

diameter	^ radius * 2!

hash	^ (center hash hashMultiply + radius hash) hashMultiply!

printOn: stream	stream nextPut: $<.	center printOn: stream.	stream nextPut: $,.	radius printOn: stream.	stream nextPut: $>!

radius	^ radius!

radius: number	radius := number! !

!P3Circle categoriesForMethods!
=!comparing!public! !
area!accessing!public! !
center!accessing!public! !
center:!private! !
circumference!accessing!public! !
diameter!accessing!public! !
hash!comparing!public! !
printOn:!printing!public! !
radius!accessing!public! !
radius:!private! !
!

!P3Circle class methodsFor!

center: center radius: radius	^ self new		center: center;		radius: radius;		yourself!

readFrom: stream	| center radius |	(stream peekFor: $<) ifFalse: [ 		(P3Error parsingFailed: 'opening < not found') signal ].	center := P3Point readFrom: stream.	(stream peekFor: $,) ifFalse: [ 		(P3Error parsingFailed: 'separating , not found') signal ].	radius := Number readFrom: stream.	(stream peekFor: $>) ifFalse: [ 		(P3Error parsingFailed: 'closing > not found') signal ].	^ self center: center radius: radius!

tag	^ #circle!

unit	^ self center: P3Point origin radius: 1 ! !

!P3Circle class categoriesForMethods!
center:radius:!instance creation!public! !
readFrom:!instance creation!public! !
tag!accessing!public! !
unit!instance creation!public! !
!

