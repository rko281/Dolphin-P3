"Filed out from Dolphin Smalltalk"!

Object subclass: #P3ConnectionPool
	instanceVariableNames: 'url configurator pool access'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ConnectionPool guid: (GUID fromString: '{74ac7d5c-383a-4ed8-9784-1b1e79e859f4}')!

P3ConnectionPool comment: 'I am P3ConnectionPool.I offer a pool of shared PSQL connections (P3Client instances) as a resource.After configuring me with at least a url, you use me by calling #withConnection:  pool := P3ConnectionPool url: ''psql://sven@localhost''.  pool withConnection: [ :p3Client | 	  p3Client query: ''SELECT table_name FROM information_schema.tables'' ].  pool close.When a connection is in use, it is not part of the pool.When a connection is returned/released to the pool, it becomes available for reuse.The pool''s size is the number of open connection ready to be reused.The pool''s capacity is the maximum number of connection that will be pooled.Excess connections will be closed when they are returned/released to the pool.New connections are created as needed.You can set a #configurator to further initialize new connections.You can use #warmUp or #warmUp: to precreate a number of connections.When an error occurs, the connection should not be reused and be closed by the caller.'!

!P3ConnectionPool categoriesForClass!P3-Core! !

!P3ConnectionPool methodsFor!

acquireConnection	"Return a connection (P3Client) from the pool or create a new one.	While in use the connection (P3Client) is removed from the pool."		^ access critical: [ 		pool isEmpty			ifTrue: [ self makeP3Client ] 			ifFalse: [ pool removeLast ] ]!

capacity	^ pool basicSize!

close	"Close all pooled connections and remove them"		pool do: [ :each | each close ].	pool removeAll!

configurator: oneArgumentBlock	"Set oneArgumentBlock to be my configurator.	This is code that will be executed once on each newly created connection (P3Client).	The default configuration asserts #isWorking on the argument"		configurator := oneArgumentBlock !

initialize	super initialize.	access := Mutex new.	pool := OrderedCollection new: 10.	configurator := [ :p3Client | self assert: [p3Client isWorking] ]!

makeP3Client	| p3Client |	p3Client := P3Client url: url.	configurator ifNotNil: [ configurator value: p3Client ].	^ p3Client!

printOn: stream	super printOn: stream.	stream 		nextPut: $(; 		print: self url; space; 		print: self size; nextPut: $/; print: self capacity; 		nextPut: $)!

releaseConnection: connection	"Return connection (a P3Client) to the pool.	If the pool is at its capacity, close it.	After this, the caller can no longer use connection."		access critical: [  		pool size < pool basicSize			ifTrue: [ pool addLast: connection ]			ifFalse: [ connection close ] ]!

size	^ pool size!

size: capacity	"Size me to capacity: the maximum number of connections (P3Clients) that I will hold"		pool := OrderedCollection new: capacity!

url	^ url!

url: aPsqlUrl	"Set the P3Client url"		url := aPsqlUrl !

warmUp	"Warm up the receiver to its full capacity.	This will create all pooled connections at once."		self warmUp: self capacity!

warmUp: numberOfConnections	"Warm up the pool to numberOfConnections.	Effectively creating that many connections at once"		| connections |	connections := Array streamContents: [ :out |		numberOfConnections timesRepeat: [ 			out nextPut: self acquireConnection ] ].	connections do: [ :each | self releaseConnection: each ]!

withConnection: oneArgumentBlock	"Execute oneArgumentBlock with a connection (P3Client) as argument,	acquiring it from the pool and releasing it to the pool when done,	unless an error occurs (in which case the caller should close)."		| connection result error |	connection := self acquireConnection.	error := result := nil.	result := [ [ oneArgumentBlock value: connection ] 			on: Error 			do: [ :exception | error := exception. error pass ] ] 		ensure: [ error ifNil: [ self releaseConnection: connection ] ].	^ result! !

!P3ConnectionPool categoriesForMethods!
acquireConnection!public! !
capacity!accessing!public! !
close!initialization!public! !
configurator:!initialization!public! !
initialize!initialization!public! !
makeP3Client!private! !
printOn:!printing!public! !
releaseConnection:!public! !
size!accessing!public! !
size:!initialization!public! !
url!accessing!public! !
url:!initialization!public! !
warmUp!public! !
warmUp:!public! !
withConnection:!public! !
!

!P3ConnectionPool class methodsFor!

new

	^super new initialize!

url: anUrl	^ self new url: anUrl! !

!P3ConnectionPool class categoriesForMethods!
new!instance creation!public! !
url:!instance creation!public! !
!

