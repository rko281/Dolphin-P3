"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3ISO8601ParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ISO8601ParserTest guid: (GUID fromString: '{cd00b5ce-c027-4688-86f0-ebb9bca0c769}')!

P3ISO8601ParserTest comment: 'P3ISO8601ParserTest holds tests for P3ISO8601Parser'!

!P3ISO8601ParserTest categoriesForClass!P3-Tests! !

!P3ISO8601ParserTest methodsFor!

testDate	self 		assert: (P3ISO8601Parser on: '2020-10-12') parseDate 		equals: (Date year: 2020 month: 10 day: 12).	self 		assert: (P3ISO8601Parser on: '2020-02-29') parseDate 		equals: (Date year: 2020 month: 02 day: 29).	self 		assert: (P3ISO8601Parser on: '2020-01-01') parseDate 		equals: (Date year: 2020 month: 01 day: 01).	self 		assert: (P3ISO8601Parser on: '2020-12-31') parseDate 		equals: (Date year: 2020 month: 12 day: 31).!

testDateAndTime	self 		assert: (P3ISO8601Parser on: '2020-10-13 10:49:48.251174+02') parseDateAndTime		equals: (DateAndTime year: 2020 month: 10 day: 13 hour: 10 minute: 49 second: (48 + (251174000 / 1000000000)) offset: 2 hours).	self 		assert: (P3ISO8601Parser on: '2020-10-13 10:49:48.251174') parseDateAndTime		equals: (DateAndTime year: 2020 month: 10 day: 13 hour: 10 minute: 49 second: (48 + (251174000 / 1000000000)) offset: Duration zero).!

testTime	self 		assert: (P3ISO8601Parser on: '07:08:09') parseTime		equals: (Time fromSeconds: ((7 * 3600) + (8 * 60) + 9)).	self 		assert: (P3ISO8601Parser on: '01:02:03.000123') parseTime		equals: (Time fromDuration: ((1 * 3600) + (2 * 60) +  (3 + (123/1000000))) seconds).! !

!P3ISO8601ParserTest categoriesForMethods!
testDate!public!tests! !
testDateAndTime!public!tests! !
testTime!public!tests! !
!

