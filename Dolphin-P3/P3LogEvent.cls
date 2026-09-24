"Filed out from Dolphin Smalltalk"!

Announcement subclass: #P3LogEvent
	instanceVariableNames: 'timestamp id session'
	classVariableNames: 'IdCounter LogEventAnnouncer'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3LogEvent guid: (GUID fromString: '{a6f947b1-0a56-41bb-b814-177f80887dc8}')!

P3LogEvent comment: 'I am P3LogEvent.I am an Announcement.Instances of my subclasses are sent to my announcer while P3Client executes.This constitutes an object based logging mechanism.My print representation is a single line in a textual log.I hold the following information:- a timestamp <DateAndTime> when the event was created- a unique ID <Integer> within this image lifetime- a PostgreSQL session identifier <Integer> (backend process id) that represents a connection'!

!P3LogEvent categoriesForClass!P3-Logging! !

!P3LogEvent methodsFor!

announcer	^ self class announcer!

emit	self announcer announce: self!

id	^ id!

initialize	super initialize.	timestamp := DateAndTime now.	id := self nextId!

nextId	^ self class nextId!

printContentsOn: stream	"Subclasses should implement this to add output"		self subclassResponsibility !

printOn: stream
	timestamp printOn: stream format: 'yyyy-MM-dd'.	stream space.	timestamp printOn: stream format: 'yyyy-MM-dd'.	stream space.	(id \\ 1000) printOn: stream base: 10 nDigits: 3.	stream nextPutAll: ' [P3] '.	session ifNotNil: [ stream print: session; space ].	self printContentsOn: stream!

session	^ session!

session: anObject	session := anObject!

timestamp	^ timestamp! !

!P3LogEvent categoriesForMethods!
announcer!accessing!public! !
emit!actions!public! !
id!accessing!public! !
initialize!initialization!public! !
nextId!accessing!public! !
printContentsOn:!printing!public! !
printOn:!printing!public! !
session!accessing!public! !
session:!initialization!public! !
timestamp!accessing!public! !
!

!P3LogEvent class methodsFor!

announcer	"Return my Announcer, the object that I send my log events to"		^ LogEventAnnouncer ifNil: [ LogEventAnnouncer := Announcer new ]!

initialize	IdCounter := 0.	SessionManager current 
		when: #sessionStarted
		send: #startUp
		to: self.!

logToTranscript	"Arrange for a textual representation of the log events sent to my announcer to be printed on the Transcript"		self stopLoggingToTranscript.	^ self announcer 		when: self 		do: [ :event | Transcript cr; print: event ; flush]		for: self!

nextId	"This should be thread safe because SmallInteger 	arithmetic primitives cannot be interrupted"		^ IdCounter := IdCounter + 1!

open	"Open an inspector on my announcer, which should offer a UI to see log events"		^ self announcer inspect!

startUp	"Reset the id counter"		IdCounter := 0!

stopLoggingToTranscript	"Stop sending a textual representation of my log events to the Transcript (see #logToTranscript)"	self announcer unsubscribe: self! !

!P3LogEvent class categoriesForMethods!
announcer!accessing!public! !
initialize!initialization!public! !
logToTranscript!convenience!public! !
nextId!accessing!public! !
open!convenience!public! !
startUp!public!system startup! !
stopLoggingToTranscript!convenience!public! !
!

