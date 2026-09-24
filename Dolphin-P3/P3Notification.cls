"Filed out from Dolphin Smalltalk"!

Notification subclass: #P3Notification
	instanceVariableNames: 'info'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Notification guid: (GUID fromString: '{66e05285-25d5-49dd-b182-78aa0f6f7eb1}')!

P3Notification comment: 'I am P3Notification.I get signalled when the PostgreSQL database backend server signals a notification, a kind of harmless warning.'!

!P3Notification categoriesForClass!P3-Core! !

!P3Notification methodsFor!

code	"Return my unique, locale independent, 5 character string code."		^ self info at: $C ifAbsent: [ nil ]!

description	"Return a textual description of the exception."	^ String streamContents: [ :stream |		stream << self class name << ' PostgreSQL'.		(self messageText ifNil: ['']) isEmpty			ifFalse: [ stream space; << self messageText ] ]!

info	^ info ifNil: [ info := Dictionary new ]!

info: anObject	info := anObject!

message	"Return my user oriented error message string.	This could be locale dependent.	My messageText gets initialized from this string"	^ self info at: $M ifAbsent: [ '' ]!

messageText	^ messageText ifNil: [ messageText := self message ]! !

!P3Notification categoriesForMethods!
code!accessing!public! !
description!accessing!public! !
info!accessing!public! !
info:!accessing!public! !
message!accessing!public! !
messageText!accessing!public! !
!

