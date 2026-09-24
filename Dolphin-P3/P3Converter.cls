"Filed out from Dolphin Smalltalk"!

Object subclass: #P3Converter
	instanceVariableNames: 'map'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Converter guid: (GUID fromString: '{fe43334e-826e-481a-8b32-deddec426409}')!

P3Converter comment: 'I am P3Converter.I convert field values to objects, taking into account their type.I known the character encoding and timezone of the current database connection.'!

!P3Converter categoriesForClass!P3-Support! !

!P3Converter methodsFor!

asciiCStringFrom: binaryStream
	^(binaryStream upTo: 0) asAnsiString!

asciiStreamFor: bytes length: length

	^(bytes next: length) asAnsiString readStream!

convert: bytes length: length description: description
	^(map at: description typeOid ifAbsent: [nil])
		ifNil: [(P3Error cannotConvertTypeOid: description typeOid) signal ]
		ifNotNil: [ :type | self perform: type second with: bytes with: length with: description ]!

convertBitStringFrom: bytes length: length description: description	^ P3BitString readFrom: (self asciiStreamFor: bytes length: length)!

convertBooleanArrayFrom: bytes length: length description: description
	| input |
	input := ReadStream on: (Utf8String fromByteArray: (bytes next: length)). 
	^ P3ArrayValueParser new 
		on: input;
		converter: [ :string | string first = $t ];
		next!

convertBooleanFrom: bytes length: length description: description	self assert: [length = 1].	^ bytes next = $t asciiValue!

convertBoxFrom: bytes length: length description: description	^ P3Box readFrom: (self asciiStreamFor: bytes length: length)!

convertByteArrayFrom: bytes length: length description: description	| size byteArray digitValues |	self assert: [(bytes next: 2) = #[92 120]]. "\x"	size := (length - 2) // 2.	digitValues := #(-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 0 1 2 3 4 5 6 7 8 9 -1 -1 -1 -1 -1 -1 -1 10 11 12 13 14 15 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 10 11 12 13 14 15 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1).	byteArray := ByteArray new: size.	1 to: size do: [ :index | | value |		value := digitValues at: bytes next + 1.		value := (value bitShift: 4) + (digitValues at: bytes next + 1).		byteArray at: index put: value ].	^ byteArray !

convertCircleFrom: bytes length: length description: description	^ P3Circle readFrom: (self asciiStreamFor: bytes length: length)!

convertDateAndTimeFrom: bytes length: length description: description	"TIMESTAMP WITH TIME ZONE (TIMESTAMPTZ) is stored internally in Postgres as UTC, but represented in the timezone of the connection, with a correct offset added. In other words, Postgres does the necessary shifting, we just have to read the result. For this to work, the connection output format must be ISO, the default."		^ (P3ISO8601Parser on: (self asciiStreamFor: bytes length: length))			timestampClass: DateAndTime;			parseDateAndTime!

convertDateAndTimeWithoutTimezoneFrom: bytes length: length description: description
	"We treat a 'tImestamp without time zone' field as a pure date+time value that will always answer the same value when read as when written.
	Since no timezone information is stored when writing this means the current local timezone offset is ignored.
	Hence we add this back when re-reading to get the same value.
	Use 'timestamp with time zone' (timestamptz) type for automatic conversion to/from timezones"

	"ORIGINAL COMMENT FOR REFERENCE: 
	TIMESTAMP WITHOUT TIME ZONE (TIMESTAMP) is stored internally in Postgres the way it was inserted, its representation remains constant, with no offset added. We use the timezone of the connection to do the necessary shifting. This assumes that the timezones used during insert/update and query are the same. For this to work, the connection output format must be ISO, the default."	| timestamp offset |	timestamp := (P3ISO8601Parser on: (self asciiStreamFor: bytes length: length))							timestampClass: DateAndTime;							parseDateAndTime.	^(offset := Locale timeZoneInformation offset) isZero
		ifTrue: [timestamp]
		ifFalse: [timestamp := timestamp p3translateTo: offset]!

convertDateFrom: bytes length: length description: description	"For this to work, the connection output format must be ISO, the default"		^ (P3ISO8601Parser on: (self asciiStreamFor: bytes length: length)) parseDate!

convertFixedBitStringFrom: bytes length: length description: description	^ P3FixedBitString readFrom: (self asciiStreamFor: bytes length: length)!

convertFloatArrayFrom: bytes length: length description: description
	| input |
	input := ReadStream on: (Utf8String fromByteArray: (bytes next: length)). 
	^ P3ArrayValueParser new 
		on: input;
		converter: [ :string | Float readFrom: string readStream ];
		next!

convertFloatFrom: bytes length: length description: description	^ Float readFrom: (self asciiStreamFor: bytes length: length)!

convertIntegerArrayFrom: bytes length: length description: description
	| input |
	input := ReadStream on: (Utf8String fromByteArray: (bytes next: length)). 
	^ P3ArrayValueParser new 
		on: input;
		converter: [ :string | Integer readFrom: string readStream ];
		next!

convertIntegerFrom: bytes length: length description: description
	^ Integer p3readFromByteStream: bytes length: length!

convertIntegerVectorFrom: bytes length: length description: description
	| input |
	input := ReadStream on: (Utf8String fromByteArray: (bytes next: length)). 
	^ P3IntegerVectorValueParser new
		  on: input;
		  next!

convertIntervalFrom: bytes length: length description: description	^ P3Interval readFrom: (self asciiStreamFor: bytes length: length)!

convertJsonFrom: bytes length: length description: description
	| input |
	input := ReadStream on: (Utf8String fromByteArray: (bytes next: length)). 
	^ STON readFrom: input readStream!

convertLineFrom: bytes length: length description: description	^ P3Line readFrom: (self asciiStreamFor: bytes length: length)!

convertLineSegmentFrom: bytes length: length description: description	^ P3LineSegment readFrom: (self asciiStreamFor: bytes length: length)!

convertPathFrom: bytes length: length description: description	^ P3Path readFrom: (self asciiStreamFor: bytes length: length)!

convertPointFrom: bytes length: length description: description	^ P3Point readFrom: (self asciiStreamFor: bytes length: length)!

convertPolygonFrom: bytes length: length description: description	^ P3Polygon readFrom: (self asciiStreamFor: bytes length: length)!

convertScaledDecimalFrom: bytes length: length description: description	^ ScaledDecimal readFrom: (self asciiStreamFor: bytes length: length)!

convertStringArrayFrom: bytes length: length description: description
	| input |
	input := ReadStream on: (Utf8String fromByteArray: (bytes next: length)). 
	^ P3ArrayValueParser new 
		on: input;
		next!

convertStringFrom: bytes length: length description: description

	| string |

	length = 0 ifTrue: [ ^ '' ].

	string := Utf8String basicNew: length.
	1 to: length do: [ :index | string basicAt: index put: bytes next].
	^string!

convertSymbolFrom: bytes length: length description: description	^ (self convertStringFrom: bytes length: length description: description) asSymbol!

convertTimeFrom: bytes length: length description: description	"TIME [ WITHOUT TIME ZONE ] corresponds to Time, i.e. 	both have no knowledge about the applicable time zone.	We assume the time to be correct as there is no sensible conversion to be done.	For this to work, the connection output format must be ISO, the default"		^ (P3ISO8601Parser on: (self asciiStreamFor: bytes length: length)) parseTime!

convertTimeWithTimezoneFrom: bytes length: length description: description
	"TIME WITH TIME ZONE corresponds to Time plus an offset. 
	Time does not hold a time zone nor an offset.
	We compare the offset coming in with the offset for that time today 
	in our connection's timezone, if they differ we correct to compensate.
	For this to work, the connection output format must be ISO, the default"

	| parser time offset connectionOffset translatedTime |
	parser := P3ISO8601Parser on: (self asciiStreamFor: bytes length: length).
	time := parser parseTime.
	offset := parser parseOptionalTimezoneOffset seconds.
	connectionOffset := "self timezone offsetForTimestamp: (DateAndTime now + time)" offset.
	^ offset = connectionOffset 
		ifTrue: [ time ]
		ifFalse: [ 
			translatedTime := time subtractTime: (offset - connectionOffset).
			^ translatedTime seconds < 0 
				ifTrue: [ translatedTime addSeconds: 24 * 60 * 60 ]
				ifFalse: [ translatedTime ] ]!

convertUuidFrom: bytes length: length description: description		^ GUID fromIdlString: ((self asciiStreamFor: bytes length: length) next: length)!

convertVoidFrom: bytes length: length description: description	self assert: [length = 0].	^ nil!

encodedCStringFrom: binaryStream

	"stringWriteStream reset.
	[ binaryStream peekFor: 0 ]
		whileFalse: [ stringWriteStream nextPut: (encoder nextFromStream: binaryStream) ].
	^ stringWriteStream contents"

	^Utf8String fromByteArray: (binaryStream upTo: 0)!

initialize	super initialize.	self initializeTypeMap!

initializeFrom: properties
	(properties at: 'server_encoding') = 'UTF8' ifFalse: [self error: 'enforce UTF8 encoding']!

initializeTypeMap	map := self class typeMap!

mapOid: anOoid type: aTypename to: aBlockOrSymbol	^ map at: anOoid put: { aTypename . aBlockOrSymbol }	!

printOn: stream	super printOn: stream.	stream nextPut: $(.	self timezone ifNotNil: [ :tmz | stream print: tmz ].	stream nextPut: $)! !

!P3Converter categoriesForMethods!
asciiCStringFrom:!input/output!public! !
asciiStreamFor:length:!private! !
convert:length:description:!converting!public! !
convertBitStringFrom:length:description:!converting!public! !
convertBooleanArrayFrom:length:description:!converting!public! !
convertBooleanFrom:length:description:!converting!public! !
convertBoxFrom:length:description:!converting/geometric!public! !
convertByteArrayFrom:length:description:!converting!public! !
convertCircleFrom:length:description:!converting/geometric!public! !
convertDateAndTimeFrom:length:description:!converting!converting/chronology!public! !
convertDateAndTimeWithoutTimezoneFrom:length:description:!converting!converting/chronology!public! !
convertDateFrom:length:description:!converting!converting/chronology!public! !
convertFixedBitStringFrom:length:description:!converting!public! !
convertFloatArrayFrom:length:description:!converting!public! !
convertFloatFrom:length:description:!converting!public! !
convertIntegerArrayFrom:length:description:!converting!public! !
convertIntegerFrom:length:description:!converting!public! !
convertIntegerVectorFrom:length:description:!converting!public! !
convertIntervalFrom:length:description:!converting!converting/chronology!public! !
convertJsonFrom:length:description:!converting!public! !
convertLineFrom:length:description:!converting/geometric!public! !
convertLineSegmentFrom:length:description:!converting/geometric!public! !
convertPathFrom:length:description:!converting/geometric!public! !
convertPointFrom:length:description:!converting/geometric!public! !
convertPolygonFrom:length:description:!converting/geometric!public! !
convertScaledDecimalFrom:length:description:!converting!public! !
convertStringArrayFrom:length:description:!converting!public! !
convertStringFrom:length:description:!converting!public! !
convertSymbolFrom:length:description:!converting!public! !
convertTimeFrom:length:description:!converting!converting/chronology!public! !
convertTimeWithTimezoneFrom:length:description:!converting!public! !
convertUuidFrom:length:description:!converting/special!public! !
convertVoidFrom:length:description:!converting!public! !
encodedCStringFrom:!input/output!public! !
initialize!initialize!public! !
initializeFrom:!initialize!public! !
initializeTypeMap!initialize!public! !
mapOid:type:to:!accessing!public! !
printOn:!printing!public! !
!

!P3Converter class methodsFor!

new
	^super new initialize!

supportedTypes	"Return the list of PostgreSQL internal type names that we can convert to objects."		^ self typeMap values collect: #first!

typeMap	^IdentityDictionary new
		at: 16 put: #(#bool #convertBooleanFrom:length:description:);
		at: 17 put: #(#bytea #convertByteArrayFrom:length:description:);
		at: 19 put: #(#name #convertStringFrom:length:description:);
		at: 20 put: #(#int8 #convertIntegerFrom:length:description:);
		at: 21 put: #(#int2 #convertIntegerFrom:length:description:);
		at: 23 put: #(#int4 #convertIntegerFrom:length:description:);
		at: 25 put: #(#text #convertStringFrom:length:description:);
		at: 26 put: #(#oid #convertIntegerFrom:length:description:);
		at: 700 put: #(#float4 #convertFloatFrom:length:description:);
		at: 701 put: #(#float8 #convertFloatFrom:length:description:);
		at: 1042 put: #(#bpchar #convertStringFrom:length:description:);
		at: 1043 put: #(#varchar #convertStringFrom:length:description:);
		at: 1560 put: #(#bit #convertFixedBitStringFrom:length:description:);
		at: 1562 put: #(#varbit #convertBitStringFrom:length:description:);
		at: 1700 put: #(#numeric #convertScaledDecimalFrom:length:description:);
		at: 2278 put: #(#void #convertVoidFrom:length:description:);
		"chronology"
		at: 1082 put: #(#date #convertDateFrom:length:description:);
		at: 1083 put: #(#time #convertTimeFrom:length:description:);
		at: 1114 put: #(#timestamp #convertDateAndTimeWithoutTimezoneFrom:length:description:);
		at: 1184 put: #(#timestamptz #convertDateAndTimeFrom:length:description:);
		at: 1186 put: #(#interval #convertIntervalFrom:length:description:);
		at: 1266 put: #(#timetz #convertTimeWithTimezoneFrom:length:description:);
		"special"
		at: 114 put: #(#json #convertJsonFrom:length:description:);
		at: 2950 put: #(#uuid #convertUuidFrom:length:description:);
		at: 3802 put: #(#jsonb #convertJsonFrom:length:description:);
		"arrays"
		at: 1000 put: #(#'_bool' #convertBooleanArrayFrom:length:description:);
		at: 1007 put: #(#'_int4' #convertIntegerArrayFrom:length:description:);
		at: 1009 put: #(#'_text' #convertStringArrayFrom:length:description:);
		at: 1015 put: #(#'_varchar' #convertStringArrayFrom:length:description:);
		at: 1022 put: #(#'_float8' #convertFloatArrayFrom:length:description:);
		at: 1028 put: #(#'_oid' #convertIntegerArrayFrom:length:description:);
		"geometric"
		at: 600 put: #(#point #convertPointFrom:length:description:);
		at: 601 put: #(#lseg #convertLineSegmentFrom:length:description:);
		at: 602 put: #(#path #convertPathFrom:length:description:);
		at: 603 put: #(#box #convertBoxFrom:length:description:);
		at: 604 put: #(#polygon #convertPolygonFrom:length:description:);
		at: 628 put: #(#line #convertLineFrom:length:description:);
		at: 718 put: #(#circle #convertCircleFrom:length:description:);
		"vectors"
		at: 30 put: #(#oidvector #convertIntegerVectorFrom:length:description: );
		yourself! !

!P3Converter class categoriesForMethods!
new!instance creation!public! !
supportedTypes!accessing!public! !
typeMap!accessing!public! !
!

