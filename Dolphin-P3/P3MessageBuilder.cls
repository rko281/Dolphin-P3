"Filed out from Dolphin Smalltalk"!

Object subclass: #P3MessageBuilder
	instanceVariableNames: 'byteStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3MessageBuilder guid: (GUID fromString: '{a755fc67-1d6e-4f7e-879c-1ced06593e0b}')!

P3MessageBuilder comment: 'I am P3MessageBuilder.I am a helper class used to construct binary messages.'!

!P3MessageBuilder categoriesForClass!P3-Support! !

!P3MessageBuilder methodsFor!

asBytes	^ byteStream contents!

initialize	byteStream := WriteStream on: (ByteArray new: 200)!

nextPutByte: anInteger	byteStream nextPut: anInteger!

nextPutInt16: anInteger	2 to: 1 by: -1 do: [ :index | byteStream nextPut: (anInteger byteAt: index) ]!

nextPutInt32: anInteger	4 to: 1 by: -1 do: [ :index | byteStream nextPut: (anInteger byteAt: index) ]!

nextPutNullParameter	"Write a NULL Parameter"	byteStream nextPutAll: #[255 255 255 255]!

nextPutParameterAsText: aValue description: paramDescription

	| tempStream |

	tempStream := (String new: 128) writeStream. 
	aValue p3PrintUsing: self on: tempStream.
	self nextPutInt32: tempStream position.
	byteStream nextPutAll: tempStream contents asByteArray!

nextPutString: aString	byteStream nextPutAll: aString asByteArray; nextPut: 0!

printBitString: bitString on: stream	"Delegate to P3[Fixed]BitString that knows how to print itself in unescaped, raw PSQL text format"		bitString printOn: stream!

printByteArray: byteArray on: stream	"Use the bytea Hex Format for bytes (ByteArray), as in \xDEADBEEF"		| hex |	stream nextPutAll: '\x'.	hex := '0123456789ABCDEF'.	byteArray do: [ :byte | 		stream 			nextPut: (hex at: (byte bitShift: -4) + 1);			nextPut: (hex at: (byte bitAnd: 15) + 1) ]!

printDate: date on: stream	"Use ISO 8601 YYYY-MM-DD"		stream nextPut: $'.	date printOn: stream format: 'yyyy-MM-dd'.	stream nextPut: $'!

printDateAndTime: dateAndTime on: stream	"Use ISO 8601 YYYY-MM-DDThh:mm:ss.s+ZZ:zz"		stream nextPut: $'.	dateAndTime printOn: stream withLeadingSpace: false.	stream nextPut: $' !

printGeometricObject: geometricObject on: stream	"Delegate to P3GeometricObject that knows how to print itself in unescaped, raw PSQL text format"		geometricObject printOn: stream!

printInterval: interval on: stream	"Delegate to P3Interval that knows how to print itself in postgresql style"		stream print: interval!

printNullOn: stream	"This cannot happen since nil is already handled earlier,	see P3PreparedStatement>>#bindStrings:"		self shouldNotImplement !

printObject: object on: stream	"In general, just use the standard print string representation"		object printOn: stream !

printScaledDecimal: scaledDecimal on: stream	"For ScaledDecimals, use a regular floating point like representation"		scaledDecimal displayOn: stream!

printString: string on: stream	"For strings just output the characters of the string, no escaping is needed"		stream nextPutAll: string!

printTime: time on: stream	"Use ISO 8601 hh:mm:ss"		stream nextPut: $'.
	time printOn: stream format: 'HH:mm:ss'.	stream nextPut: $'!

printValuesArray: valuesArray on: stream	stream nextPut: ${.	valuesArray do: [ :each |		each p3PrintUsing: self on: stream ] separatedBy: [ stream nextPut: $, ].	stream nextPut: $}!

writeTo: aConnection tag: aChar	aConnection nextPut: aChar asInteger.! !

!P3MessageBuilder categoriesForMethods!
asBytes!converting!public! !
initialize!initialization!public! !
nextPutByte:!public!writing! !
nextPutInt16:!public!writing! !
nextPutInt32:!public!writing! !
nextPutNullParameter!public!writing! !
nextPutParameterAsText:description:!public!writing! !
nextPutString:!public!writing! !
printBitString:on:!printing/dispatched!public! !
printByteArray:on:!printing/dispatched!public! !
printDate:on:!printing/dispatched!public! !
printDateAndTime:on:!printing/dispatched!public! !
printGeometricObject:on:!printing/dispatched!public! !
printInterval:on:!printing/dispatched!public! !
printNullOn:!printing/dispatched!public! !
printObject:on:!printing/dispatched!public! !
printScaledDecimal:on:!printing/dispatched!public! !
printString:on:!printing/dispatched!public! !
printTime:on:!printing/dispatched!public! !
printValuesArray:on:!printing/dispatched!public! !
writeTo:tag:!public!writing! !
!

!P3MessageBuilder class methodsFor!

new	^ super new initialize! !

!P3MessageBuilder class categoriesForMethods!
new!instance creation!public! !
!

