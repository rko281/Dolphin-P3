"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3ConnectionPoolTest
	instanceVariableNames: 'pool'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ConnectionPoolTest guid: (GUID fromString: '{556b9384-dc1a-407b-bec9-9cbbf9d9b352}')!

P3ConnectionPoolTest comment: 'P3ConnectionPoolTest holds unit tests for the P3ConnectionPool class.I reuse the configuration of P3ClientTest.'!

!P3ConnectionPoolTest categoriesForClass!P3-Tests! !

!P3ConnectionPoolTest methodsFor!

setUp	super setUp.	pool := P3ConnectionPool new.	pool url: P3ClientTest url!

tearDown	pool close!

testError	self assert: pool size equals: 0.	self 		should: [ pool withConnection: [ :p3Client | 							p3Client query: 'SELECT * FROM abcdef'] ] 		raise: P3Error.	self assert: pool size equals: 0!

testOne	self assert: pool size equals: 0.	self 		assert: (pool withConnection: [ :p3Client | 							(p3Client query: 'SELECT 1+2') firstFieldOfFirstRecord ]) 		equals: 3.	self 		assert: (pool withConnection: [ :p3Client | 							(p3Client query: 'SELECT 10-2') firstFieldOfFirstRecord ]) 		equals: 8.	self assert: pool size equals: 1!

testWarmUp	self assert: pool size equals: 0.	pool warmUp.	self assert: pool size equals: pool capacity.	pool withConnection: [ :p3Client | 		p3Client query: 'SELECT table_name FROM information_schema.tables' ].	self assert: pool size equals: pool capacity.	pool close.	self assert: pool size equals: 0! !

!P3ConnectionPoolTest categoriesForMethods!
setUp!public!running! !
tearDown!public!running! !
testError!public!tests! !
testOne!public!tests! !
testWarmUp!public!tests! !
!

