"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3PBKDF2Test
	instanceVariableNames: 'pbkdf2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3PBKDF2Test guid: (GUID fromString: '{5c76667a-b423-46d2-a030-a5ca8a4a1489}')!

P3PBKDF2Test comment: 'Unit tests for P3PBKDF2https://tools.ietf.org/html/rfc6070https://stackoverflow.com/questions/5130513/pbkdf2-hmac-sha2-test-vectors'!

!P3PBKDF2Test categoriesForClass!P3-Tests! !

!P3PBKDF2Test methodsFor!

setUp	super setUp.	pbkdf2 := P3PBKDF2 new!

testHMACSHA256Vector1	| dk expected |	pbkdf2 		hmacSHA256; 		password: 'password'; 		salt: 'salt'; 		iterations: 1.	dk := pbkdf2 deriveKey.	expected := ByteArray readHexFrom: ('12 0f b6 cf fc f8 b3 2c       43 e7 22 52 56 c4 f8 37       a8 65 48 c9 2c cc 35 48       08 05 98 7c b7 0b e1 7b' reject: [ :each | each isSeparator ]).	self assert: dk equals: expected  !

testHMACSHA256Vector2	| dk expected |	pbkdf2 		hmacSHA256; 		password: 'password'; 		salt: 'salt'; 		iterations: 2.	dk := pbkdf2 deriveKey.	expected := ByteArray readHexFrom: ('ae 4d 0c 95 af 6b 46 d3       2d 0a df f9 28 f0 6d d0       2a 30 3f 8e f3 c2 51 df       d6 e2 d8 5a 95 47 4c 43' reject: [ :each | each isSeparator ]).	self assert: dk equals: expected  !

testHMACSHA256Vector3	| dk expected |	pbkdf2 		hmacSHA256; 		password: 'password'; 		salt: 'salt'; 		iterations: 4096.	dk := pbkdf2 deriveKey.	expected := ByteArray readHexFrom: ('c5 e4 78 d5 92 88 c8 41       aa 53 0d b6 84 5c 4c 8d       96 28 93 a0 01 ce 4e 11       a4 96 38 73 aa 98 13 4a' reject: [ :each | each isSeparator ]).	self assert: dk equals: expected  !

testHMACSHA256Vector4	"This takes several minutes, but it does pass"	"| dk expected |dk := P3PBKDF2 new 	hmacSHA256; 	password: 'password'; 	salt: 'salt'; 	iterations: 16777216;	deriveKey.expected := ByteArray readHexFrom: ('cf 81 c6 6f e8 cf c0 4d       1f 31 ec b6 5d ab 40 89       f7 f1 79 e8 9b 3b 0b cb       17 ad 10 e3 ac 6e ba 46' reject: #isSeparator).self assert: dk = expected"!

testHMACSHA256Vector5	| dk expected |	pbkdf2 		hmacSHA256; 		password: 'passwordPASSWORDpassword'; 		salt: 'saltSALTsaltSALTsaltSALTsaltSALTsalt'; 		iterations: 4096.	dk := pbkdf2 deriveKeyOfSize: 40.	expected := ByteArray readHexFrom: ('34 8c 89 db cb d3 2b 2f       32 d8 14 b8 11 6e 84 cf       2b 17 34 7e bc 18 00 18       1c 4e 2a 1f b8 dd 53 e1       c6 35 51 8c 7d ac 47 e9' reject: [ :each | each isSeparator ]).	self assert: dk equals: expected  !

testHMACSHA256Vector6	| dk expected |	pbkdf2 		hmacSHA256; 		password: 'pass' , 0 asCharacter asString , 'word'; 		salt: 'sa' , 0 asCharacter asString , 'lt'; 		iterations: 4096.	dk := pbkdf2 deriveKeyOfSize: 16.	expected := ByteArray readHexFrom: ('89 b6 9d 05 16 f8 29 89       3c 69 62 26 65 0a 86 87' reject: [ :each | each isSeparator ]).	self assert: dk equals: expected  ! !

!P3PBKDF2Test categoriesForMethods!
setUp!public!running! !
testHMACSHA256Vector1!public!tests! !
testHMACSHA256Vector2!public!tests! !
testHMACSHA256Vector3!public!tests! !
testHMACSHA256Vector4!public!tests! !
testHMACSHA256Vector5!public!tests! !
testHMACSHA256Vector6!public!tests! !
!

