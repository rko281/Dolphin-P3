"Filed out from Dolphin Smalltalk"!

Object subclass: #P3Interval
	instanceVariableNames: 'years months days hours minutes seconds'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Interval guid: (GUID fromString: '{a60a8ab1-c177-46b8-93d8-99c36fc66054}')!

P3Interval comment: 'I am P3Interval, a time duration (INTERVAL).I store all components separately.I support the ''postgres'' default IO format.I can also print myself using the ''iso8601 with designators'' format.This is currently an MVP implementation.'!

!P3Interval categoriesForClass!P3-Objects! !

!P3Interval methodsFor!

= anotherInterval	self == anotherInterval		ifTrue: [ ^ true ].	self class = anotherInterval class		ifFalse: [ ^ false ].	^ years = anotherInterval years		and: [ months = anotherInterval months				and: [ days = anotherInterval days						and: [ hours = anotherInterval hours								and: [ minutes = anotherInterval minutes										and: [ seconds = anotherInterval seconds ] ] ] ] ]!

asDuration

	^Duration hours: hours minutes: minutes seconds: seconds!

days	^ days!

days: anObject	days := anObject!

hash	^ ((years hash + months hash + days hash) hashMultiply		+ (hours hash + minutes hash + seconds hash) hashMultiply)		hashMultiply!

hours	^ hours!

hours: anObject	hours := anObject!

initialize	super initialize.	years := months := days := hours := minutes := seconds := 0!

minutes	^ minutes!

minutes: anObject	minutes := anObject!

months	^ months!

months: anObject	months := anObject!

p3PrintUsing: delegate on: stream	"Print me on stream via double dispatch on delegate.	Check the implementors of #p3PrintUsing:on:"	delegate printInterval: self on: stream!

printIso8601On: stream	stream nextPut: $P.	years = 0 ifFalse: [ 		stream print: years; nextPut: $Y ].	months = 0 ifFalse: [		stream print: months; nextPut: $M ].	days = 0 ifFalse: [		stream print: days; nextPut: $D ].	stream nextPut: $T.	hours = 0 ifFalse: [ 		stream print: hours; nextPut: $H ].	minutes = 0 ifFalse: [		stream print: minutes; nextPut: $M ].	seconds = 0 ifFalse: [		stream print: seconds; nextPut: $S ]!

printOn: stream	| space |	space := false.	years = 0 ifFalse: [ 		stream print: years; space.		stream nextPutAll: (years = 1 ifTrue: [ 'year' ] ifFalse: [ 'years' ]).		space := true ].	months = 0 ifFalse: [		space ifTrue: [ stream space ]. 		stream print: months; space.		stream nextPutAll: (months = 1 ifTrue: [ 'mon' ] ifFalse: [ 'mons' ]).		space := true ].	days = 0 ifFalse: [		space ifTrue: [ stream space ]. 		stream print: days; space.		stream nextPutAll: (days = 1 ifTrue: [ 'day' ] ifFalse: [ 'days' ]).		space := true ].	space ifTrue: [ stream space ].
	hours printOn: stream base: 10 nDigits: 2.	stream nextPut: $:.	minutes printOn: stream base: 10 nDigits: 2.	stream nextPut: $:.	seconds < 10 ifTrue: [ stream print: 0 ].	seconds printOn: stream!

seconds	^ seconds!

seconds: anObject	seconds := anObject!

years	^ years!

years: anObject	years := anObject! !

!P3Interval categoriesForMethods!
=!comparing!public! !
asDuration!converting!public! !
days!accessing!public! !
days:!accessing!public! !
hash!comparing!public! !
hours!accessing!public! !
hours:!accessing!public! !
initialize!initialization!public! !
minutes!accessing!public! !
minutes:!accessing!public! !
months!accessing!public! !
months:!accessing!public! !
p3PrintUsing:on:!printing!public! !
printIso8601On:!printing!public! !
printOn:!printing!public! !
seconds!accessing!public! !
seconds:!accessing!public! !
years!accessing!public! !
years:!accessing!public! !
!

!P3Interval class methodsFor!

new

	^super new initialize!

readDesignator: stream	self skipSeparators: stream.	^ String streamContents: [ :out |		[ stream atEnd not and: [ stream peek isLetter or: [ stream peek = $: ] ] ] 			whileTrue: [ out nextPut: stream next ] ]!

readFrom: stream	| years months days hours minutes seconds number word helper count |	years := months := days := hours := minutes := seconds := 0.	helper := [ :value :designator |		(designator beginsWith: 'year') ifTrue: [ years := value ].		(designator beginsWith: 'mon') ifTrue: [ months := value ].		(designator beginsWith: 'day') ifTrue: [ days := value ] ].	count := number := 0.	[ count <= 3 ] whileTrue: [		self skipSeparators: stream.		number := stream atEnd ifTrue: [ nil ] ifFalse: [ Number readFrom: stream ].		word := self readDesignator: stream.		word = ':' 			ifTrue: [ count := 4 ]			ifFalse: [ 				helper value: number value: word.		 		count := count + 1 ] ].	stream atEnd 		ifFalse: [ 			hours := number.			stream peekFor: $:.			minutes := Number readFrom: stream.			stream peekFor: $:.			seconds := Number readFrom: stream ].	^ self years: years months: months days: days hours: hours minutes: minutes seconds: seconds!

skipSeparators: stream	[ stream atEnd not and: [ stream peek isSeparator ] ] whileTrue: [ stream next ]!

years: years months: months days: days hours: hours minutes: minutes seconds: seconds	^ self new		years: years;		months: months;		days: days;		hours: hours;		minutes: minutes;		seconds: seconds;		yourself!

zero	^ self new! !

!P3Interval class categoriesForMethods!
new!instance creation!public! !
readDesignator:!private! !
readFrom:!instance creation!public! !
skipSeparators:!private! !
years:months:days:hours:minutes:seconds:!instance creation!public! !
zero!instance creation!public! !
!

