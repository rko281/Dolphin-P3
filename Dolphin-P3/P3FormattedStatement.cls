"Filed out from Dolphin Smalltalk"!

Object subclass: #P3FormattedStatement
	instanceVariableNames: 'client source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3FormattedStatement guid: (GUID fromString: '{9bc1cc02-213a-4af3-ab0a-e60ce5159f2c}')!

P3FormattedStatement comment: 'I am P3FormattedStatement, an SQL template with placeholders that, together with arguments, can be executed.I am a tool to safely and more easily create SQL statements and queries that contain arguments. I know the correct textual representation of a set of primitive types. I do proper string escaping.Since I know the client that created me, I can be executed autonomously.You create instances of me by sending #format: to a P3Client instance.For example,	statement := client format: ''SELECT name, enabled FROM table1 WHERE id >= $1 ORDER BY id''.	result := statement query: #( 345 ).in the above 345 will be bound to (and replace) $1 in the SQL template.The syntax that I use ($n) and my public API is mostly polymorphic with P3PreparedStatement. The difference is that I do simple string processing on the client without any interaction with the server.'!

!P3FormattedStatement categoriesForClass!P3-Core! !

!P3FormattedStatement methodsFor!

bind: arguments	"Build and return the actual SQL statement by splicing in the arguments for all placeholders in the template"		^ String streamContents: [ :out | | readStream |			readStream := self source readStream.			[ readStream atEnd ] whileFalse: [ | char |				(char := readStream next) = $$					ifTrue: [ | index argument |						index := Integer readFrom: readStream.						argument := arguments at: index.						argument p3PrintUsing: self on: out ]					ifFalse: [ out nextPut: char ] ] ]!

client: aP3Client	client := aP3Client!

close!

execute: arguments	"Bind the arguments given to the placeholders in my SQL template and	execute this statement using my client, returning the result"	^ client execute: (self bind: arguments)!

executeBatch: argumentsCollection	"Bind each set of arguments from the argumentsCollection given	to the placeholders in my SQL template and execute this statement using my client, 	returning the collection of results"	^ argumentsCollection collect: [ :each | self execute: each ]!

printBitString: bitString on: stream	"Use the B'0101' syntax for bit strings"		stream nextPut: $B; nextPut: $'; print: bitString; nextPut: $'!

printByteArray: byteArray on: stream	"Use the bytea Hex Format for bytes (ByteArray),	as in '\xDEADBEEF'"		| hex |	stream nextPutAll: '''\x'.	hex := '0123456789ABCDEF'.	byteArray do: [ :byte | 		stream 			nextPut: (hex at: (byte bitShift: -4) + 1);			nextPut: (hex at: (byte bitAnd: 15) + 1) ].	stream nextPut: $'!

printDate: date on: stream	"Use ISO 8601 YYYY-MM-DD"		stream nextPut: $'.	date printOn: stream format: 'yyyy-MM-dd'.	stream nextPut: $'!

printDateAndTime: dateAndTime on: stream	"Use ISO 8601 YYYY-MM-DDThh:mm:ss.s+ZZ:zz"		stream nextPut: $'.	dateAndTime printOn: stream withLeadingSpace: false.	stream nextPut: $' !

printGeometricObject: geometricObject on: stream	"Delegate to P3GeometricObject that knows how to print itself in typed quoted PSQL text format"		geometricObject printPsqlOn: stream!

printInterval: interval on: stream	"Delegate partially to P3Interval that knows how to print itself in postgresql style"		stream nextPutAll: #interval; space; nextPut: $'; print: interval; nextPut: $'!

printNullOn: stream	"nil becomes NULL"		stream nextPutAll: 'NULL'!

printObject: object on: stream	"In general, just use the standard print string representation"		object printOn: stream !

printOn: stream	super printOn: stream.	stream nextPut: $(; << source; nextPut: $)!

printScaledDecimal: scaledDecimal on: stream	"For ScaledDecimals, use a regular floating point like representation"		scaledDecimal displayOn: stream!

printString: string on: stream	"For strings use single quotes and the doubling of single quotes when they are part of the string"		stream nextPut: $'.	string do: [ :each |		each = $' ifTrue: [ stream nextPut: $' ].		stream nextPut: each ].	stream nextPut: $'!

printTime: time on: stream	"Use ISO 8601 hh:mm:ss"		stream nextPut: $'.	time printOn: stream format: 'HH:mm:ss'.	stream nextPut: $'!

printValuesArray: valuesArray on: stream	valuesArray isEmpty ifTrue: [ ^ stream nextPutAll: '''{}''' ]. "prevent untyped empty array error"
	stream nextPutAll: #array.	stream nextPut: $[.	valuesArray do: [ :each | each p3PrintUsing: self on: stream ] separatedBy: [stream nextPut: $,].	stream nextPut: $]!

query: arguments	"Bind the arguments given to the placeholders in my SQL template and	execute this query using my client, returning the result"		^ client query: (self bind: arguments)!

queryAll: argumentsCollection	"Bind each set of arguments from the argumentsCollection given	to the placeholders in my SQL template and execute this query using my client, 	returning the collection of results"	^ argumentsCollection collect: [ :each | self query: each ]!

source	"Return my SQL source"		^ source!

sql: anSQLTemplateString	source := anSQLTemplateString ! !

!P3FormattedStatement categoriesForMethods!
bind:!private! !
client:!initialization!public! !
close!public! !
execute:!public! !
executeBatch:!public! !
printBitString:on:!printing/dispatched!public! !
printByteArray:on:!printing/dispatched!public! !
printDate:on:!printing/dispatched!public! !
printDateAndTime:on:!printing/dispatched!public! !
printGeometricObject:on:!printing/dispatched!public! !
printInterval:on:!printing/dispatched!public! !
printNullOn:!printing/dispatched!public! !
printObject:on:!printing/dispatched!public! !
printOn:!printing!public! !
printScaledDecimal:on:!printing/dispatched!public! !
printString:on:!printing/dispatched!public! !
printTime:on:!printing/dispatched!public! !
printValuesArray:on:!printing/dispatched!public! !
query:!public! !
queryAll:!public! !
source!accessing!public! !
sql:!initialization!public! !
!

