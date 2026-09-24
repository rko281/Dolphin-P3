"Filed out from Dolphin Smalltalk"!

P3GeometricObject subclass: #P3Line
	instanceVariableNames: 'a b c'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Line guid: (GUID fromString: '{f7ba0ba4-dac4-427c-bfc9-2e5109ee20b3}')!

P3Line comment: 'I am P3Line	{a,b,c} ax+by+c=0I am a P3GeometricObjectMy internal representation consists of my 3 coefficients, a, b and c'!

!P3Line categoriesForClass!P3-Objects! !

!P3Line methodsFor!

= anotherLine	self == anotherLine ifTrue: [ ^ true ].	self class = anotherLine class ifFalse: [ ^ false ].	^ a = anotherLine a and: [ b = anotherLine b and: [ c = anotherLine c ] ]!

a	^ a!

a: number	a := number!

b	^ b!

b: number	b := number!

c	^ c!

c: number	c := number!

hash 	^ ((a hash + b hash) hashMultiply + c hash) hashMultiply !

printOn: stream	stream 		nextPut: ${;		print: a;		nextPut: $,;		print: b;		nextPut: $,;		print: c;		nextPut: $}! !

!P3Line categoriesForMethods!
=!comparing!public! !
a!accessing!public! !
a:!private! !
b!accessing!public! !
b:!private! !
c!accessing!public! !
c:!private! !
hash!comparing!public! !
printOn:!comparing!public! !
!

!P3Line class methodsFor!

a: a b: b c: c	^ self new		a: a;		b: b;		c: c;		yourself!

readFrom: stream	| a b c |	(stream peekFor: ${) ifFalse: [ 		(P3Error parsingFailed: 'opening { not found') signal ].	a := Number readFrom: stream.	(stream peekFor: $,) ifFalse: [ 		(P3Error parsingFailed: 'separator , not found') signal ].	b := Number readFrom: stream.	(stream peekFor: $,) ifFalse: [ 		(P3Error parsingFailed: 'separator , not found') signal ].	c := Number readFrom: stream.	(stream peekFor: $}) ifFalse: [ 		(P3Error parsingFailed: 'closing } not found') signal ].	^ self a: a b: b c: c!

tag	^ #line!

xAxis	^ self a: 0 b: 1 c: 0!

yAxis	^ self a: 1 b: 0 c: 0! !

!P3Line class categoriesForMethods!
a:b:c:!instance creation!public! !
readFrom:!instance creation!public! !
tag!accessing!public! !
xAxis!instance creation!public! !
yAxis!instance creation!public! !
!

