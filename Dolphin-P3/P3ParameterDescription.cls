"Filed out from Dolphin Smalltalk"!

Object subclass: #P3ParameterDescription
	instanceVariableNames: 'typeOid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ParameterDescription guid: (GUID fromString: '{6365c2e8-51b8-40a6-af89-b0253bd8b0cc}')!

P3ParameterDescription comment: 'I am P3ParameterDescription.I am used to support the extended query protocol.In particular, after the prepare/parse phase, my instances describe the type of each binding parameter.'!

!P3ParameterDescription categoriesForClass!P3-Support! !

!P3ParameterDescription methodsFor!

printOn: stream	super printOn: stream.	stream nextPut: $(.	stream << self typeName.	stream nextPut: $)!

typeName	^ (P3Converter typeMap at: self typeOid ifAbsent: [ { self typeOid }]) first!

typeOid	^ typeOid!

typeOid: anObject	typeOid := anObject! !

!P3ParameterDescription categoriesForMethods!
printOn:!printing!public! !
typeName!accessing!public! !
typeOid!accessing!public! !
typeOid:!accessing!public! !
!

