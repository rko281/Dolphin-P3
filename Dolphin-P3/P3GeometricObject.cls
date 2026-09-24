"Filed out from Dolphin Smalltalk"!

Object subclass: #P3GeometricObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3GeometricObject guid: (GUID fromString: '{946d8f3e-9e78-40a2-825c-62494a031d8a}')!

P3GeometricObject comment: 'I am P3GeometricObject, the abstract superclass for all PostgreSQL geometric data types, representing two-dimensional spatial objects.'!

!P3GeometricObject categoriesForClass!P3-Objects! !

!P3GeometricObject methodsFor!

p3PrintUsing: delegate on: stream	"Print me on stream via double dispatch on delegate.	Check the implementors of #p3PrintUsing:on:"	delegate printGeometricObject: self on: stream!

printPsqlOn: stream	stream 		nextPutAll: self tag; 		space; 		nextPut: $'; 		print: self; 		nextPut: $'!

tag	^ self class tag! !

!P3GeometricObject categoriesForMethods!
p3PrintUsing:on:!printing!public! !
printPsqlOn:!printing!public! !
tag!accessing!public! !
!

!P3GeometricObject class methodsFor!

new

	^super new initialize!

tag	self subclassResponsibility! !

!P3GeometricObject class categoriesForMethods!
new!instance creation!public! !
tag!accessing!public! !
!

