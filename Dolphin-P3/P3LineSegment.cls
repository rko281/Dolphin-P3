"Filed out from Dolphin Smalltalk"!

P3GeometricObject subclass: #P3LineSegment
	instanceVariableNames: 'start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3LineSegment guid: (GUID fromString: '{1062c3fc-a040-4c59-bffe-934b932da2af}')!

P3LineSegment comment: 'I am P3LineSegment	[(x1,y1),(x2,y2)]I am a P3GeometricObjectMy internal representation is a start and stop point'!

!P3LineSegment categoriesForClass!P3-Objects! !

!P3LineSegment methodsFor!

= anotherLineSegment	self == anotherLineSegment ifTrue: [ ^ true ].	self class = anotherLineSegment class ifFalse: [ ^ false ].	^ start = anotherLineSegment start and: [ stop = anotherLineSegment stop ]!

hash	^ (start hash + stop hash) hashMultiply!

length	^ ((stop x - start x) squared + (stop y - start y) squared) sqrt!

printOn: stream	stream nextPut: $[.	start printOn: stream.	stream nextPut: $,.	stop printOn: stream.	stream nextPut: $]!

start	^ start!

start: point	start := point!

stop	^ stop!

stop: point	stop := point! !

!P3LineSegment categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
length!accessing!public! !
printOn:!printing!public! !
start!accessing!public! !
start:!private! !
stop!accessing!public! !
stop:!private! !
!

!P3LineSegment class methodsFor!

readFrom: stream	| start stop |	(stream peekFor: $[) ifFalse: [ 		(P3Error parsingFailed: 'opening [ not found') signal ].	start := P3Point readFrom: stream.	(stream peekFor: $,) ifFalse: [ 		(P3Error parsingFailed: 'separator , not found') signal ].	stop := P3Point readFrom: stream.	(stream peekFor: $]) ifFalse: [ 		(P3Error parsingFailed: 'closing ] not found') signal ].	^ self start: start stop: stop!

start: start stop: stop	^ self new		start: start;		stop: stop;		yourself!

tag	^ #lseg!

xAxisUnit	^ self start: P3Point zero stop: (P3Point x: 1 y: 0) !

yAxisUnit	^ self start: P3Point zero stop: (P3Point x: 0 y: 1) ! !

!P3LineSegment class categoriesForMethods!
readFrom:!instance creation!public! !
start:stop:!instance creation!public! !
tag!accessing!public! !
xAxisUnit!instance creation!public! !
yAxisUnit!instance creation!public! !
!

