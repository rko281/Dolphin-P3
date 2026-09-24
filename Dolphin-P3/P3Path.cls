"Filed out from Dolphin Smalltalk"!

P3Polygon subclass: #P3Path
	instanceVariableNames: 'open'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Path guid: (GUID fromString: '{9d9aaf5c-ed76-46cc-853f-562983688a3b}')!

P3Path comment: 'I am P3Path	[(x1,y1), ... ,(xn,yn)] open	((x1,y1), ... ,(xn,yn)) closedI am a P3Polygon and a P3GeometricObjectI inherit my representation and add the option to be open instead of closed'!

!P3Path categoriesForClass!P3-Objects! !

!P3Path methodsFor!

= anotherPath	^ super = anotherPath and: [ open = anotherPath isOpen ]!

beOpen	open := true!

hash	^ super hash xor: open hash!

initialize	super initialize.	open := false!

isClosed	^ open not!

isOpen	^ open!

printOn: stream	stream nextPut: (self isOpen ifTrue: [ $[ ] ifFalse: [ $( ]).	self printPointsOn: stream.	stream nextPut: (self isOpen ifTrue: [ $] ] ifFalse: [ $) ])		! !

!P3Path categoriesForMethods!
=!comparing!public! !
beOpen!initialization!public! !
hash!comparing!public! !
initialize!initialization!public! !
isClosed!public!testing! !
isOpen!public!testing! !
printOn:!printing!public! !
!

!P3Path class methodsFor!

openPoints: collectionOfPoints	^ (self points: collectionOfPoints)		beOpen;		yourself!

readFrom: stream	| points closer path |	points := OrderedCollection new.	closer := nil.	stream peek = $( ifTrue: [ closer := $) ].	stream peek = $[ ifTrue: [ closer := $] ].	closer 		ifNil: [ (P3Error parsingFailed: 'opening ( or [ not found') signal ] 		ifNotNil: [ stream next ]. 	[ stream atEnd or: [ stream peek = closer ] ] whileFalse: [ | point |		point := P3Point readFrom: stream.		points add: point.		(stream atEnd or: [ stream peek = closer ] ) 			ifFalse: [ 				(stream peekFor: $,) ifFalse: [ 					(P3Error parsingFailed: 'separating , not found') signal ] ] ].	(stream peekFor: closer) ifFalse: [ 		(P3Error parsingFailed: 'closing ) or ] not found') signal ].		path := self points: points.	closer = $] ifTrue: [ path beOpen ].	^ path!

tag	^ #path! !

!P3Path class categoriesForMethods!
openPoints:!instance creation!public! !
readFrom:!instance creation!public! !
tag!accessing!public! !
!

