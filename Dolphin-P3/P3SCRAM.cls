"Filed out from Dolphin Smalltalk"!

Object subclass: #P3SCRAM
	instanceVariableNames: 'user password salt hmac iteratedHash clientNounce serverNounce saltedPassword'
	classVariableNames: 'Store'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3SCRAM guid: (GUID fromString: '{78653551-2e32-47a6-a288-5227df969711}')!

P3SCRAM comment: 'I am P3SCRAM (Salted Challenge Response Authentication Mechanism for SASL (Simple Authentication and Security Layer) as well as GSS-API (Generic Security Service Application Program Interface).https://en.wikipedia.org/wiki/Salted_Challenge_Response_Authentication_Mechanismhttps://en.wikipedia.org/wiki/Simple_Authentication_and_Security_Layerhttps://en.wikipedia.org/wiki/Generic_Security_Services_Application_Program_Interfacehttps://tools.ietf.org/html/rfc5802https://tools.ietf.org/html/rfc7677SCRAM is a client-first protocol, I implement the client side.0. setup  scram := P3SCRAM sha256; user: ''user''; password: ''pencil''.1. client -> server (send identification & random nounce)  scram clientFirstMessage. "n,,n=user,r=XXX1"2. server -> client (receive challenge, extended random nounce, salt & iterations)  scram serverFirstMessage: ''r=XXX1XXX,s=YYYY,i=NNNN''.3. client -> server (send proof, server will verify)  scram clientFinalMessage. "c=biws,r=XXX1XXX,p=PPPP"4. server -> client (receive success, client will verify)	scram serverFinalMessage: ''v=VVVV''.Performance noteThe computation of the saltedPasssword takes a noticeable amount of time,especially with SHA-256 and the conventional 4096 iterations.For this reason this computation is cached.Furthermore, to save time between usages, clients can store my instancesin my store, under a key, so they can reuse them, potentially gainingspeed by using a cached result. See P3SCRAM class>>#storeAt:ifAbsentPut:This speedup is for all but the first execution of a particular authentication.Security noteThe information held in my instances is sensitive.For this reason, my class side store will be reset before each image save.About PostgreSQL''s password storage If you execute ''SELECT rolname,rolpassword FROM pg_authid'' with enough privileges,you can see how PostgreSQL stores passwords. In the case of SCRAM-SHA-256, rolpassword seems to have the following format (using terms used in this implementation): SCRAM-SHA-256$<iterations>:<salt(base64>$<storedKey(base64>:<serverKey(base64)>Using iterations and salt, and of course the password itself, constitutes enough information to calculate everything that does not depend on the nounces.'!

!P3SCRAM categoriesForClass!P3-Support! !

!P3SCRAM methodsFor!

authMessage	^ self clientFirstMessageBare , ',' 		, self serverFirstMessage , ',' 		, self clientFinalMessageWithoutProof !

base64Encode: aByteArray

	| stream |

	stream := WriteStream on: (String new: 16).
	aByteArray printBase64On: stream.
	^stream contents!

channelBinding	^ 'n,,'!

clearSaltedPassword	saltedPassword := nil!

clientFinalMessage	"This is the response message that the client sends to the server,	answering a previously received serverFirstMessage with a proof"		^ self clientFinalMessageWithoutProof 		, ',p=' , (self base64Encode: self clientProof)!

clientFinalMessageWithoutProof	^ 'c=' , (self base64Encode: self channelBinding asByteArray)		, ',r=' , self fullNounce !

clientFirstMessage	"This is the first message that the client sends to the server 	to start the authentication process. You have to initialize me	with either SHA1 or SHA256, a required password and an optional user identity."		^ self channelBinding , self clientFirstMessageBare!

clientFirstMessageBare	^ 'n=' , (self user ifNil: [ '' ])		, ',r=' , self clientNounce!

clientKey	^ hmac 		key: self saltedPassword; 		digestMessage: 'Client Key'!

clientNounce	^ clientNounce ifNil: [ clientNounce := (GUID newUnique asInteger printStringBase: 36) first: 16 ]!

clientNounce: string	clientNounce := string!

clientProof

	| clientKey clientSignature clientProof |

	clientKey := self clientKey.
	clientSignature := self clientSignature.
	clientProof := ByteArray new: self clientKey size.
	1 to: self clientKey size do: [ :index | clientProof at: index put: ((clientKey at: index) bitXor: (clientSignature at: index))].
	^ clientProof!

clientSignature	^ hmac 		key: self storedKey; 		digestMessage: self authMessage !

fullNounce	^ self clientNounce , self serverNounce !

iterations	^ iteratedHash iterations!

iterations: count	self iterations = count		ifTrue: [ ^ self ].	iteratedHash iterations: count.	self clearSaltedPassword !

password	^ password!

password: string	password = string		ifTrue: [ ^ self ].	password := string.	self clearSaltedPassword!

salt	^ salt!

salt: byteArray	salt = byteArray		ifTrue: [ ^ self ].	salt := byteArray.	self clearSaltedPassword !

saltedPassword	"Cached to improve performance"		^ saltedPassword ifNil: [ 			saltedPassword := iteratedHash 				password: self password; 				salt: self salt; 				deriveKey ]!

serverFinalMessage: string	"This is the response message that the server sends to the client	answering a previous clientFinalMessage. If there is no error,	it contains a proof that is verified and asserted."		| info |	info := self class parseMessage: string.	info at: #e ifPresent: [ :errorMessage | self error: 'P3SCRAM Error: ' , errorMessage ].	self assert: [(ByteArray fromBase64String: (info at: #v)) = self serverSignature]!

serverFirstMessage
	^ 'r=' , self fullNounce 		, ',s=' , (self base64Encode: self salt)		, ',i=' , iteratedHash iterations displayString!

serverFirstMessage: string	"This is the challenge message that the server sends to the client 	in response to my clientFirstMessage. Parse it and process its contents."		| info r |	info := self class parseMessage: string.	self salt: (ByteArray fromBase64String: (info at: #s)).	self iterations: (Integer fromString: (info at: #i)).	r := info at: #r.	self assert: [r beginsWith: self clientNounce].	self serverNounce: (r allButFirst: self clientNounce size)!

serverKey	^ hmac		key: self saltedPassword;		digestMessage: 'Server Key'!

serverNounce	^ serverNounce ifNil: [ serverNounce := (GUID newUnique asInteger printStringBase: 36) last: 16 ]!

serverNounce: string	serverNounce := string!

serverSignature	^ hmac		key: self serverKey;		digestMessage: self authMessage !

sha256

	hmac := P3HMACSHA256 new.
	iteratedHash := P3PBKDF2 new hmacSHA256.!

storedKey	^ hmac hashMessage: self clientKey !

user	^ user!

user: string	user := string! !

!P3SCRAM categoriesForMethods!
authMessage!private! !
base64Encode:!private! !
channelBinding!accessing!public! !
clearSaltedPassword!private! !
clientFinalMessage!public! !
clientFinalMessageWithoutProof!private! !
clientFirstMessage!public! !
clientFirstMessageBare!private! !
clientKey!private! !
clientNounce!accessing!public! !
clientNounce:!accessing!public! !
clientProof!private! !
clientSignature!private! !
fullNounce!accessing!public! !
iterations!accessing!public! !
iterations:!accessing!public! !
password!accessing!public! !
password:!accessing!public! !
salt!accessing!public! !
salt:!accessing!public! !
saltedPassword!private! !
serverFinalMessage:!public! !
serverFirstMessage!private! !
serverFirstMessage:!public! !
serverKey!private! !
serverNounce!accessing!public! !
serverNounce:!accessing!public! !
serverSignature!private! !
sha256!initialization!public! !
storedKey!private! !
user!accessing!public! !
user:!accessing!public! !
!

!P3SCRAM class methodsFor!

initialize
	SessionManager current when: #sessionStopped send: #shutDown to: self!

parseMessage: string	"Expected format: [k=v],[k=v],... with empty (,,) and single elements (n=) being ignored"		| info |	info := Dictionary new.	($, split: string) do: [ :attributeString | | index |		index := attributeString indexOf: $=.		(index between: 2 and: attributeString size - 1)			ifTrue: [ | key value |				key := attributeString first: index - 1.				value := attributeString allButFirst: index.				info at: key put: value ] ].	^ info!

reset	"Completely throw away my store. It contains sensitive information."		Store := nil!

shutDown	"Prevent my store of sensitive information to be saved with an image"		self reset!

store
	"I maintain a store with instances registered under a key, using a TTLCache of 1 hour"
	
	^ Store ifNil: [ Store := Dictionary new "TTLCache new timeToLive: 1 hour; yourself "]!

storeAt: key ifAbsentPut: block	"If my store holds a previously registered and used instance, return it,	else evaluate block, which should return a newly created instance, that I store and return.	Used instances cache their saltedPassword for improved performance for 1 hour."	^ self store 		at: key 		ifAbsentPut: block! !

!P3SCRAM class categoriesForMethods!
initialize!class initialization!public! !
parseMessage:!private! !
reset!class initialization!public! !
shutDown!public!system startup! !
store!accessing!public! !
storeAt:ifAbsentPut:!accessing!public! !
!

