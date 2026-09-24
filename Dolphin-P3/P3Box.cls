"Filed out from Dolphin Smalltalk"!

P3GeometricObject subclass: #P3Box
	instanceVariableNames: 'upperRight lowerLeft'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Box guid: (GUID fromString: '{1206fc47-531e-4702-8b63-160d96e69814}')!

P3Box comment: 'I am P3Box	(x1,y1),(x2,y2)I am a P3GeometricObjectMy internal representation is an upper right and lower left point'!

!P3Box categoriesForClass!P3-Objects! !

!P3Box methodsFor!

= anotherBox	self == anotherBox ifTrue: [ ^ true ].	self class = anotherBox class ifFalse: [ ^ false ].	^ upperRight = anotherBox upperRight and: [ lowerLeft = anotherBox lowerLeft ]!

area	^ self width * self height!

center	^ P3Point x: (self width / 2 + lowerLeft x) y: (self height / 2 + lowerLeft y)!

hash	^ (upperRight hash + lowerLeft hash) hashMultiply!

height	^ upperRight y - lowerLeft y!

lowerLeft	^ lowerLeft !

lowerLeft: point	lowerLeft := point!

printOn: stream	upperRight printOn: stream.	stream nextPut: $,.	lowerLeft printOn: stream!

upperRight	^ upperRight!

upperRight: point	upperRight := point!

width	^ upperRight x - lowerLeft x! !

!P3Box categoriesForMethods!
=!comparing!public! !
area!accessing!public! !
center!accessing!public! !
hash!comparing!public! !
height!accessing!public! !
lowerLeft!accessing!public! !
lowerLeft:!private! !
printOn:!printing!public! !
upperRight!accessing!public! !
upperRight:!private! !
width!accessing!public! !
!

!P3Box class methodsFor!

readFrom: stream	| upperRight lowerLeft |	upperRight := P3Point readFrom: stream.	(stream peekFor: $,) ifFalse: [ 			(P3Error parsingFailed: 'separator , not found') signal ].	lowerLeft := P3Point readFrom: stream.	^ self upperRight: upperRight lowerLeft: lowerLeft!

tag	^ #box!

unit	^ self upperRight: P3Point unit lowerLeft: P3Point zero!

upperRight: upperRight lowerLeft: lowerLeft	^ self new		upperRight: upperRight;		lowerLeft: lowerLeft;		yourself!

zero	^ self upperRight: P3Point zero lowerLeft: P3Point zero! !

!P3Box class categoriesForMethods!
readFrom:!instance creation!public! !
tag!accessing!public! !
unit!instance creation!public! !
upperRight:lowerLeft:!instance creation!public! !
zero!instance creation!public! !
!

