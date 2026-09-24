"Filed out from Dolphin Smalltalk"!

Object subclass: #P3RowFieldDescription
	instanceVariableNames: 'fieldName tableOid attributeNumber typeOid typeSize typeModifier format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3RowFieldDescription guid: (GUID fromString: '{2875b873-8844-4c9b-b762-fb46da4584f8}')!

P3RowFieldDescription comment: 'I am P3RowFieldDescriptionI hold meta data regarding the result of an SQL query. I describe one field/column in the result.I know how to interpret and convert raw bytes with the help of a P3Converter (see #convert:length:using:) into objects.'!

!P3RowFieldDescription categoriesForClass!P3-Support! !

!P3RowFieldDescription methodsFor!

attributeNumber	^ attributeNumber!

attributeNumber: anObject	attributeNumber := anObject!

convert: bytes length: length using: converter	^ converter convert: bytes length: length description: self!

fieldName	^ fieldName!

fieldName: anObject	fieldName := anObject!

format	^ format!

format: anObject	format := anObject!

printOn: stream	super printOn: stream.	stream nextPut: $(.	stream << fieldName.	stream space.	stream << self typeName.	stream nextPut: $)!

tableOid	^ tableOid!

tableOid: anObject	tableOid := anObject!

typeModifier	^ typeModifier!

typeModifier: anObject	typeModifier := anObject!

typeName	^ (P3Converter typeMap at: self typeOid ifAbsent: [ {self typeOid} ]) first!

typeOid	^ typeOid!

typeOid: anObject	typeOid := anObject!

typeSize	^ typeSize!

typeSize: anObject	typeSize := anObject! !

!P3RowFieldDescription categoriesForMethods!
attributeNumber!accessing!public! !
attributeNumber:!accessing!public! !
convert:length:using:!converting!public! !
fieldName!accessing!public! !
fieldName:!accessing!public! !
format!accessing!public! !
format:!accessing!public! !
printOn:!printing!public! !
tableOid!accessing!public! !
tableOid:!accessing!public! !
typeModifier!accessing!public! !
typeModifier:!accessing!public! !
typeName!accessing!public! !
typeOid!accessing!public! !
typeOid:!accessing!public! !
typeSize!accessing!public! !
typeSize:!accessing!public! !
!

