"Filed out from Dolphin Smalltalk"!

Object subclass: #P3HMACSHA256
	instanceVariableNames: 'key ipad epad'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3HMACSHA256 guid: (GUID fromString: '{0ccae5ee-f961-49f1-a066-aec1a39cb6a6}')!

P3HMACSHA256 comment: ''!

!P3HMACSHA256 categoriesForClass!Kernel-Objects! !

!P3HMACSHA256 methodsFor!

blockSize

	^64!

digestMessage: aString
	
	| m1 m2 |

	m1 := ByteArray new: key size.
	m2 := ByteArray new: key size.
	1 to: key size do: [ :index | m1 at: index put: ((key at: index) bitXor: (epad at: index))].
	1 to: key size do: [ :index | m2 at: index put: ((key at: index) bitXor: (ipad at: index))].

	^self hashMessage: m1, (self hashMessage: m2, aString asByteArray )!

hashMessage: aByteArray

	^BCryptLibrary default
		p3hash: aByteArray
		algorithm: 65 "BCRYPT_SHA256_ALG_HANDLE"
		length: ##(256 / 8)!

initialize
	
	ipad := ByteArray
		new: self blockSize
		withAll: 54.
	epad := ByteArray
		new: self blockSize
		withAll: 92!

key: aByteArray
	key := aByteArray.
	key size > self blockSize ifTrue: [ key := self hashMessage: key ].
	key size < self blockSize ifTrue: [ key := key , (ByteArray new: self blockSize - key size) ]! !

!P3HMACSHA256 categoriesForMethods!
blockSize!accessing!public! !
digestMessage:!accessing!public! !
hashMessage:!accessing!public! !
initialize!initialization!public! !
key:!accessing!public! !
!

!P3HMACSHA256 class methodsFor!

new

	^super new initialize! !

!P3HMACSHA256 class categoriesForMethods!
new!instance creation!public! !
!

