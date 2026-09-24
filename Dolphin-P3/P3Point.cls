"Filed out from Dolphin Smalltalk"!

P3GeometricObject subclass: #P3Point
	instanceVariableNames: 'x y'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Point guid: (GUID fromString: '{cfae188f-4b35-433b-b2c0-be9362f22da8}')!

P3Point comment: 'I am P3Point	(x,y)I am a P3GeometricObjectMy internal representation consists of my x and y coordinate'!

!P3Point categoriesForClass!P3-Objects! !

!P3Point methodsFor!

= anotherPoint	self == anotherPoint ifTrue: [ ^ true ].	self class = anotherPoint class ifFalse: [ ^ false ].	^ x = anotherPoint x and: [ y = anotherPoint y ]!

hash	^ ( x hash hashMultiply + y hash) hashMultiply!

printOn: stream	stream nextPut: $(.	x printOn: stream.	stream nextPut: $,.	y printOn: stream.	stream nextPut: $)!

x	^ x!

x: number	x := number!

y	^ y!

y: number	y := number! !

!P3Point categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
printOn:!printing!public! !
x!accessing!public! !
x:!private! !
y!accessing!public! !
y:!private! !
!

!P3Point class methodsFor!

origin	^ self zero!

readFrom: stream	| x y |	(stream peekFor: $() ifFalse: [ 		(P3Error parsingFailed: 'opening ( not found') signal ].	x := Number readFrom: stream.	(stream peekFor: $,) ifFalse: [ 		(P3Error parsingFailed: 'separator , not found') signal ].	y := Number readFrom: stream.	(stream peekFor: $)) ifFalse: [ 		(P3Error parsingFailed: 'closing ) not found') signal ].	^ self x: x y: y!

tag	^ #point!

unit	^ self x: 1 y: 1!

x: x y: y	^ self new		x: x;		y: y;		yourself!

zero	^ self x: 0 y: 0! !

!P3Point class categoriesForMethods!
origin!instance creation!public! !
readFrom:!instance creation!public! !
tag!accessing!public! !
unit!instance creation!public! !
x:y:!instance creation!public! !
zero!instance creation!public! !
!

