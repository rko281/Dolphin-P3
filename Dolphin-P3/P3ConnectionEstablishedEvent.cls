"Filed out from Dolphin Smalltalk"!

P3LogEvent subclass: #P3ConnectionEstablishedEvent
	instanceVariableNames: 'settings properties'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ConnectionEstablishedEvent guid: (GUID fromString: '{2b3caf0e-ef88-457b-bc94-e551bfb40c3d}')!

P3ConnectionEstablishedEvent comment: 'I am P3ConnectionEstablishedEvent.I am a P3LogEvent.I represent the opening of a PostgreSQL client connection.I hold a copy of the settings and properties of the P3Client.'!

!P3ConnectionEstablishedEvent categoriesForClass!P3-Logging! !

!P3ConnectionEstablishedEvent methodsFor!

authenticationType	^ self properties at: #'authentication_type' ifAbsent: [#Trust]!

clearPassword	settings removeKey: #password!

database	^ settings at: #database ifAbsent: [ nil ]!

host	^ settings at: #host ifAbsentPut: [ 'localhost' ]!

isSSL	^ settings at: #ssl ifAbsent: [ false ]!

password	^ settings at: #password ifAbsent: [ nil ]!

port	^ settings at: #port ifAbsentPut: [ 5432 ]!

printContentsOn: stream	stream print: #Connect.	stream space; nextPutAll: 'psql://'.	self user ifNotNil: [ :user | stream nextPutAll: user; nextPut: $@ ].	stream nextPutAll: self host; nextPut: $:; print: self port.	self database ifNotNil: [ :database | stream nextPut: $/; nextPutAll: database ].	self isSSL ifTrue: [ stream nextPutAll: '?sslmode=require' ].	self authenticationType ifNotNil: [ :type | stream space; nextPutAll: type ]!

properties	^ properties!

properties: anObject	properties := anObject!

settings	^ settings!

settings: anObject	settings := anObject!

user	^ settings at: #user ifAbsent: [ nil ]! !

!P3ConnectionEstablishedEvent categoriesForMethods!
authenticationType!accessing!public! !
clearPassword!initialization!public! !
database!accessing!public! !
host!accessing!public! !
isSSL!public!testing! !
password!accessing!public! !
port!accessing!public! !
printContentsOn:!printing!public! !
properties!accessing!public! !
properties:!initialization!public! !
settings!accessing!public! !
settings:!initialization!public! !
user!accessing!public! !
!

