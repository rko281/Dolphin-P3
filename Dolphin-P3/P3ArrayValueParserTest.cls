"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3ArrayValueParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ArrayValueParserTest guid: (GUID fromString: '{8efca163-6d6f-4378-9132-3ff751573beb}')!

P3ArrayValueParserTest comment: 'P3ArrayValueParserTest holds unit tests for P3ArrayValueParser.'!

!P3ArrayValueParserTest categoriesForClass!P3-Tests! !

!P3ArrayValueParserTest methodsFor!

testIntegers	self 		assert: (P3ArrayValueParser new 			on: '{{1,2},{3,4},{0,-1}}' readStream;			converter: [ :string | Integer fromString: string ];			next)		equals: #( (1 2) (3 4) (0 -1) )!

testPlain	self 		assert: (P3ArrayValueParser new 			on: '{{one,two},{three,four},{NULL,""}' readStream;			next)		equals: #( ('one' 'two') ('three' 'four') (nil '') )!

testSpecial	self 		assert: (P3ArrayValueParser new 			on: '{{one,two},{"\"","\\"},{NULL,""},{"NULL",1}' readStream;			next)		equals: #( ('one' 'two') ('"' '\') (nil '') ('NULL' '1') )! !

!P3ArrayValueParserTest categoriesForMethods!
testIntegers!public!tests! !
testPlain!public!tests! !
testSpecial!public!tests! !
!

