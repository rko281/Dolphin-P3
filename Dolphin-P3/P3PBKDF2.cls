"Filed out from Dolphin Smalltalk"!

Object subclass: #P3PBKDF2
	instanceVariableNames: 'password salt pseudoRandom iterations'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3PBKDF2 guid: (GUID fromString: '{08a147d4-4bbb-440b-918b-2d278e9ed846}')!

P3PBKDF2 comment: 'I am P3PBKDF2 (Password-Based Key Derivation Function 2).https://en.wikipedia.org/wiki/PBKDF2https://tools.ietf.org/html/rfc2898	P3PBKDF2 new		hmacSHA1; 		password: ''password''; 		salt: ''salt''; 		iterations: 4096;		deriveKey.'!

!P3PBKDF2 categoriesForClass!P3-Support! !

!P3PBKDF2 methodsFor!

deriveKey	"Derive and return a key based on my settings.	The size will conform with the block size of my pseudo random function."		^ self deriveKeyBlock: 1!

deriveKeyBlock: blockNumber	| data derivedKeyBlock |	data := self pseudoRandom: password with: (self saltFor: blockNumber).	derivedKeyBlock := data.	(iterations - 1) timesRepeat: [ 		data := self pseudoRandom: password with: data.
		data keysAndValuesDo: [ :index :byte | derivedKeyBlock at: index put: ((derivedKeyBlock at: index) bitXor: byte)]].	^ derivedKeyBlock  !

deriveKeyOfSize: byteSize	"Derive and return a byteSize key based on my settings."	^ ByteArray new: byteSize streamContents: 
		[ :out || blockNumber bytesProduced derivedKeyBlock count |
		blockNumber := 1.
		bytesProduced := 0.		[ bytesProduced < byteSize ] whileTrue: [ 			derivedKeyBlock := self deriveKeyBlock: blockNumber.			blockNumber := blockNumber + 1.			count := (byteSize - bytesProduced) min: derivedKeyBlock size.			out nextPutAll: (derivedKeyBlock first: count).			bytesProduced := bytesProduced + count ] ]!

hmacSHA256

	self pseudoRandom: 
		[:key :message | 
		P3HMACSHA256 new
			key: key;
			digestMessage: message]!

iterations	^ iterations!

iterations: numberOfRounds	iterations := numberOfRounds!

password	^ password!

password: anObject	password := anObject asByteArray!

pseudoRandom	^ pseudoRandom!

pseudoRandom: block	pseudoRandom := block!

pseudoRandom: key with: message	^ pseudoRandom value: key value: message!

salt	^ salt!

salt: anObject	salt := anObject asByteArray!

saltFor: blockNumber	^ salt , ((4 to: 1 by: -1) collect: [ :index | blockNumber byteAt: index]) asByteArray! !

!P3PBKDF2 categoriesForMethods!
deriveKey!public! !
deriveKeyBlock:!private! !
deriveKeyOfSize:!public! !
hmacSHA256!initialization!public! !
iterations!accessing!public! !
iterations:!accessing!public! !
password!accessing!public! !
password:!accessing!public! !
pseudoRandom!accessing!public! !
pseudoRandom:!accessing!public! !
pseudoRandom:with:!private! !
salt!accessing!public! !
salt:!accessing!public! !
saltFor:!private! !
!

