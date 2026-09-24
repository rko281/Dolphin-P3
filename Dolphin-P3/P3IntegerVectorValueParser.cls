"Filed out from Dolphin Smalltalk"!

Object subclass: #P3IntegerVectorValueParser
	instanceVariableNames: 'stream converter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3IntegerVectorValueParser guid: (GUID fromString: '{e76fb871-78f2-4aec-bafd-40d5f2acf4a9}')!

P3IntegerVectorValueParser comment: 'I represent a Parser which can parse ancient PostgreSQL oidvector (OID:30) type, which looks like array of positive integers, but has different textual representation. Example of the textual representation: ''2281 26 2281 21 2281''.We have four different vector types:```sqlselect distinct typname from pg_type where typname ~ ''^[^_].*vector'';``````┌─────────────┐│   typname   │├─────────────┤│ gtsvector   ││ int2vector  ││ oidvector   ││ tsvector    │└─────────────┘```'!

!P3IntegerVectorValueParser categoriesForClass!P3-Support! !

!P3IntegerVectorValueParser methodsFor!

consumeWhitespace	"Strip whitespaces from the input stream."	[ stream atEnd not and: [ stream peek = Character space ] ] 		whileTrue: [ stream next ]!

convertElement: string	^ converter 		ifNil: [ string ]		ifNotNil: [ converter value: string ]!

converter: block	"Set my converter to block, which will parse the text of array elements"		converter := block!

initialize	"set default converter"	super initialize.	converter := [ :string |  Integer fromString: string]!

next	"Parse and return the next array value"	self consumeWhitespace.	^ Array streamContents: [ :array | 		  [ stream atEnd ] 			  whileFalse: [ 				  array nextPut: (self convertElement: self parseElement).				  self consumeWhitespace.] ]!

on: readStream	"Initialize me on the textual readStream given"		stream := readStream!

parseElement	^ String streamContents: [ :string | 		  [ stream atEnd or: [ Character space = stream peek ] ] 			  whileFalse: [ string nextPut: stream next ] ]! !

!P3IntegerVectorValueParser categoriesForMethods!
consumeWhitespace!private/parsing!public! !
convertElement:!private/parsing!public! !
converter:!instance creation!public! !
initialize!initialization!public! !
next!accessing!public! !
on:!instance creation!public! !
parseElement!private/parsing!public! !
!

!P3IntegerVectorValueParser class methodsFor!

new

	^super new initialize! !

!P3IntegerVectorValueParser class categoriesForMethods!
new!instance creation!public! !
!

