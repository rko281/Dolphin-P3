"Filed out from Dolphin Smalltalk"!

Object subclass: #P3ValuesArray
	instanceVariableNames: 'array'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ValuesArray guid: (GUID fromString: '{5bba7933-c4f5-4167-a71d-0aad32cda293}')!

P3ValuesArray comment: 'I am P3ValuesArray.I hold a list of database values that are rendered recursively as an array of values.I am a helper object used for statement construction.The following example shows a technique to use parameters for ''IN (...)'' using ''= ANY''.statement := client prepare: ''SELECT * FROM my_table WHERE id = ANY ($1)''.statement query: { P3ValuesArray withAll: #(1 2) }.statement := client format: ''SELECT * FROM fmi_owner WHERE id = ANY ($1)''.statement query: { P3ValuesArray withAll: #(1 2) }.'!

!P3ValuesArray categoriesForClass!P3-Objects! !

!P3ValuesArray methodsFor!

do: block	array do: block!

isEmpty	^ array isNil or: [ array isEmpty ]!

p3PrintUsing: delegate on: stream	"Print me on stream via double dispatch on delegate.	Check the implementors of #p3PrintUsing:on:"	delegate printValuesArray: self on: stream!

size	^ array ifNil: [ 0 ] ifNotNil: [ array size ]!

values	^ array!

values: anArray	array := anArray! !

!P3ValuesArray categoriesForMethods!
do:!enumerating!public! !
isEmpty!public!testing! !
p3PrintUsing:on:!printing!public! !
size!accessing!public! !
values!accessing!public! !
values:!accessing!public! !
!

!P3ValuesArray class methodsFor!

empty	^ self withAll: #()!

withAll: collection	^ self new		values: collection asArray;		yourself! !

!P3ValuesArray class categoriesForMethods!
empty!public!requirements! !
withAll:!instance creation!public! !
!

