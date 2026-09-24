"Filed out from Dolphin Smalltalk"!

Object subclass: #P3URL
	instanceVariableNames: 'string elements'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3URL guid: (GUID fromString: '{36826edb-59e6-4cc0-9f22-1331edf97cad}')!

P3URL comment: ''!

!P3URL categoriesForClass!Kernel-Objects! !

!P3URL methodsFor!

firstPathSegment

	^self queryAt: #firstPathSegment ifAbsent: ['']!

host

	^self queryAt: #host ifAbsent: ['']!

parse

	| stream position userPwd subStream host |

	stream := string readStream.
	elements := IdentityDictionary new.

	elements at: #scheme put: (stream upTo: $:).
	(stream next: 2) = '//' ifFalse: [self parseError].

	position := stream position.
	userPwd := stream upTo: $@.
	stream atEnd 
	ifTrue: 
		[stream position: position]
	ifFalse: 
		[subStream := userPwd readStream.
		elements 
			at: #username put: (subStream upTo: $:);
			at: #password put: subStream upToEnd].

	position := stream position.
	host := stream upTo: $:.
	stream atEnd 
	ifTrue: 
		[stream position: position.
		elements at: #host put: (stream upTo: $/)]
	ifFalse: 
		[elements 
			at: #host put: host;
			at: #port put: (Integer readFrom: stream).
		stream atEnd ifFalse: [stream next = $/ ifFalse: [self parseError]]].

	elements at: #firstPathSegment put: (stream upTo: $?).
	stream atEnd ifFalse: 
		[(stream upTo: $=) = 'sslmode' ifFalse: [self parseError].
		elements at: #sslmode put: (stream upToEnd)]!

parseError

	self error: 'unexpected format for P3 url'!

password

	^self queryAt: #password ifAbsent: [nil]!

portIfAbsent: aBlock

	^self queryAt: #port ifAbsent: aBlock!

queryAt: aSymbol ifAbsent: aBlock

	^elements at: aSymbol ifAbsent: aBlock!

queryAt: aSymbol ifPresent: aBlock

	^elements at: aSymbol ifPresent: aBlock!

scheme

	^self queryAt: #scheme ifAbsent: ['']!

string
	^string!

string: anObject
	string := anObject!

username

	^self queryAt: #username ifAbsent: [nil]! !

!P3URL categoriesForMethods!
firstPathSegment!accessing!public! !
host!accessing!public! !
parse!parsing!public! !
parseError!parsing!public! !
password!accessing!public! !
portIfAbsent:!accessing!public! !
queryAt:ifAbsent:!accessing!public! !
queryAt:ifPresent:!accessing!public! !
scheme!accessing!public! !
string!accessing!private! !
string:!accessing!private! !
username!accessing!public! !
!

!P3URL class methodsFor!

fromString: aString

	^self new 
		string: aString;
		parse;
		yourself! !

!P3URL class categoriesForMethods!
fromString:!public! !
!

