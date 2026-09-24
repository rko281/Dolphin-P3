"Filed out from Dolphin Smalltalk"!

Object subclass: #P3ISO8601Parser
	instanceVariableNames: 'stream timestampClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ISO8601Parser guid: (GUID fromString: '{a82527f6-a4b0-4317-8aae-25f9a8479443}')!

P3ISO8601Parser comment: 'I am P3ISO8601Parser.I am a fast, non-validating ISO 8601 parser for Time, Date and DateAndTime objects.I only accept the PostgreSQL ISO output format.	YYYY-MM-DD hh:mm:ss.nnnnnnnnn[+|-]FF[.ff]'!

!P3ISO8601Parser categoriesForClass!P3-Support! !

!P3ISO8601Parser methodsFor!

initialize	timestampClass := DateAndTime!

on: readStream	stream := readStream !

parseDate	| year month day |	year := self parsePositiveInteger.	month := day := 1.	(stream peekFor: $-)		ifTrue: [ 			month := self parsePositiveInteger.			(stream peekFor: $-)				ifTrue: [ 					day := self parsePositiveInteger ] ].	^ Date year: year month: month day: day !

parseDateAndTime	| date time timezoneOffset |	date := self parseDateElements.	stream peekFor: $ .	time := self parseTimeElements.	timezoneOffset := self parseOptionalTimezoneOffset.	^ timestampClass 			year: date first 			month: date second 			day: date third 			hour: time first 			minute: time second 			second: (time third + (time fourth / 1000000000))			offsetSeconds: timezoneOffset seconds asSeconds!

parseDateElements	| year month day |	year := self parsePositiveInteger.	month := day := 1.	(stream peekFor: $-)		ifTrue: [ 			month := self parsePositiveInteger.			(stream peekFor: $-)				ifTrue: [ 					day := self parsePositiveInteger ] ].	^ Array with: year with: month with: day!

parseDecimalFraction	| integer power |	integer := 0.	power := 1.	[ '0123456789' includes: stream peek ] 		whileTrue: [ 			integer := integer * 10 + stream next asciiValue - 48.			power := power * 10 ].	^ integer / power!

parseOptionalTimezoneOffset	^ ('+-' includes: stream peek)			ifTrue: [ self parseTimezoneOffset ]			ifFalse: [ 0 ]!

parsePositiveInteger	| integer |	integer := 0.	[ '0123456789' includes: stream peek ] 		whileTrue: [ 			integer := integer * 10 + stream next asciiValue - 48 ].	^ integer!

parseTime	| hours minutes seconds nanoSeconds |	hours := self parsePositiveInteger.	minutes := seconds := nanoSeconds := 0.	(stream peekFor: $:)		ifTrue: [ 			minutes := self parsePositiveInteger.			(stream peekFor: $:)				ifTrue: [ 					seconds := self parsePositiveInteger.					(stream peekFor: $.)						ifTrue: [ 							nanoSeconds := self parseDecimalFraction * 1e9 ] ] ].
	^Time fromDuration: (hours hours + minutes minutes + seconds seconds + nanoSeconds nanoseconds)!

parseTimeElements	| hours minutes seconds nanoSeconds |	hours := self parsePositiveInteger.	minutes := seconds := nanoSeconds := 0.	(stream peekFor: $:)		ifTrue: [ 			minutes := self parsePositiveInteger.			(stream peekFor: $:)				ifTrue: [ 					seconds := self parsePositiveInteger.					(stream peekFor: $.)						ifTrue: [ 							nanoSeconds := self parseDecimalFraction * 1e9 ] ] ].	^ Array with: hours with: minutes with: seconds with: nanoSeconds  !

parseTimezoneOffset	| sign hours minutes |	sign := stream next = $- ifTrue: [ -1 ] ifFalse: [ 1 ].	hours := self parsePositiveInteger.	minutes := (stream peekFor: $:)		ifTrue: [ self parsePositiveInteger ]		ifFalse: [ 0 ].	^ sign * ((hours * 3600) + (minutes * 60))!

timestampClass: aClass	"Set the class for timestamps, which will be sent #year:month:day:hour:minute:second:nanoSecond:offset:"		timestampClass := aClass! !

!P3ISO8601Parser categoriesForMethods!
initialize!initialization!public! !
on:!initialization!public! !
parseDate!parsing!public! !
parseDateAndTime!parsing!public! !
parseDateElements!parsing!public! !
parseDecimalFraction!parsing!public! !
parseOptionalTimezoneOffset!parsing!public! !
parsePositiveInteger!parsing!public! !
parseTime!parsing!public! !
parseTimeElements!parsing!public! !
parseTimezoneOffset!parsing!public! !
timestampClass:!initialization!public! !
!

!P3ISO8601Parser class methodsFor!

new

	^super new initialize!

on: stringOrReadStream	^ self new 		on: (stringOrReadStream isString ifTrue: [stringOrReadStream readStream] ifFalse: [stringOrReadStream]); 		yourself! !

!P3ISO8601Parser class categoriesForMethods!
new!instance creation!public! !
on:!instance creation!public! !
!

