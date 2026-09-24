"Filed out from Dolphin Smalltalk"!

P3GeometricObject subclass: #P3Polygon
	instanceVariableNames: 'points'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Polygon guid: (GUID fromString: '{c7f13d23-f779-40eb-b670-88f5dc156c05}')!

P3Polygon comment: 'I am P3Polygon	((x1,y1), ... ,(xn,yn))I am a P3GeometricObjectMy internal representation is an ordered collection of points'!

!P3Polygon categoriesForClass!P3-Objects! !

!P3Polygon methodsFor!

= anotherPolygon	self == anotherPolygon ifTrue: [ ^ true ].	self class = anotherPolygon class ifFalse: [ ^ false ].	^ points = anotherPolygon points!

hash	^ points hash!

isClosed	^ true!

isOpen	^ false!

numberOfPoints	^ points size!

points	^ points!

points: collectionOfPoints	points := collectionOfPoints !

printOn: stream	stream nextPut: $(.	self printPointsOn: stream.	stream nextPut: $)!

printPointsOn: stream	points 		do: [ :each | each printOn: stream ] 		separatedBy: [ stream nextPut: $, ]! !

!P3Polygon categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isClosed!public!testing! !
isOpen!public!testing! !
numberOfPoints!accessing!public! !
points!accessing!public! !
points:!private! !
printOn:!printing!public! !
printPointsOn:!printing!public! !
!

!P3Polygon class methodsFor!

points: aCollectionOfPoints	^ self new		points: aCollectionOfPoints asOrderedCollection;		yourself!

readFrom: stream	| points |	points := OrderedCollection new.	(stream peekFor: $() ifFalse: [ 		(P3Error parsingFailed: 'opening ( not found') signal ].	[ stream atEnd or: [ stream peek = $) ] ] whileFalse: [ | point |		point := P3Point readFrom: stream.		points add: point.		(stream atEnd or: [ stream peek = $) ] ) 			ifFalse: [ 				(stream peekFor: $,) ifFalse: [ 					(P3Error parsingFailed: 'separating , not found') signal ] ] ].	(stream peekFor: $)) ifFalse: [ 		(P3Error parsingFailed: 'closing ) not found') signal ].		^ self points: points!

tag	^ #polygon! !

!P3Polygon class categoriesForMethods!
points:!instance creation!public! !
readFrom:!instance creation!public! !
tag!accessing!public! !
!

