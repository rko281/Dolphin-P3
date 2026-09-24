"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3IntegerVectorValueParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3IntegerVectorValueParserTest guid: (GUID fromString: '{f615ca38-62b4-49b2-be26-5478be05ba26}')!

P3IntegerVectorValueParserTest comment: ''!

!P3IntegerVectorValueParserTest categoriesForClass!P3-Tests! !

!P3IntegerVectorValueParserTest methodsFor!

testPlain	"assuming PostgreSQL will always use exactly one space as separator, but we parse multispace as well"	self		assert: (P3IntegerVectorValueParser new				 on: '  12   1221 0 -123 1221   12  ' readStream;				 next)		equals: #( 12 1221 0 -123 1221 12 )! !

!P3IntegerVectorValueParserTest categoriesForMethods!
testPlain!public!tests! !
!

