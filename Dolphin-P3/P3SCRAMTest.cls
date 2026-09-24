"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3SCRAMTest
	instanceVariableNames: 'scram'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3SCRAMTest guid: (GUID fromString: '{c8e1c0a8-57e8-4815-a820-820ddbc0d940}')!

P3SCRAMTest comment: 'Unit tests for P3SCRAM.https://tools.ietf.org/html/rfc5802https://tools.ietf.org/html/rfc7677'!

!P3SCRAMTest categoriesForClass!P3-Tests! !

!P3SCRAMTest methodsFor!

setUp	super setUp.	scram := P3SCRAM new!

testSHA256
	| stream |
	scram sha256.	scram user: 'user'.	scram password: 'pencil'.	scram clientNounce: 'rOprNGfwEbeRWgbNEkqO'.	self 		assert: scram clientFirstMessage 		equals: 'n,,n=user,r=rOprNGfwEbeRWgbNEkqO'.	scram serverFirstMessage: 'r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,s=W22ZaJ0SNY7soEsUEjb6gQ==,i=4096'.	self assert: scram serverNounce equals: '%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0'.
	stream := WriteStream on: (String new: 16).
	scram salt printBase64On: stream.	self assert: stream contents equals: 'W22ZaJ0SNY7soEsUEjb6gQ=='.	self assert: scram iterations equals: 4096.	self 		assert: scram clientFinalMessage 		equals: 'c=biws,r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,p=dHzbZapWIk4jUhN+Ute9ytag9zjfMHgsqmmiz7AndVQ='.	scram serverFinalMessage: 'v=6rriTRBi23WpRR/wtup+mMhUZUn/dB5nLTJRsjl95G4='	! !

!P3SCRAMTest categoriesForMethods!
setUp!public!running! !
testSHA256!public!tests! !
!

