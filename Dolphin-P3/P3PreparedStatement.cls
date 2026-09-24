"Filed out from Dolphin Smalltalk"!

Object subclass: #P3PreparedStatement
	instanceVariableNames: 'client name paramDescriptions fieldDescriptions source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3PreparedStatement guid: (GUID fromString: '{fcfd136f-b703-47f1-b74c-eb5319813dd8}')!

P3PreparedStatement comment: 'I am P3PreparedStatement. Use me if you need to execute a query multiple times.Create an instance of me via P3Client>>#prepare: The argument to this method is a query string that can contain one or more placeholders. When executing the statement an array should be provided with a value for each placeholder.Examples:Prepare an insert statement and execute it two times with different parameters:	statement := client prepare: ''INSERT INTO table1 (id, name, enabled) VALUES ($1,$2,$3)''.	result := statement execute: #( 123 ''Hello World'' true ).	result := statement execute: #( 45 ''Greetings'' false ).It''s also possible to execute the two inserts in a single network roundtrip:	statement := client prepare: ''INSERT INTO table1 (id, name, enabled) VALUES ($1,$2,$3)''.	results := statement executeBatch: #( 		( 123 ''Hello World'' true )		( 45 ''Greetings'' false ) ).Select query:	statement := client prepare: ''SELECT name, enabled FROM table1 WHERE id = $1''.	result := statement query: #( 123 ).When I''m no longer needed I should be closed so that the PostgreSQL server side resources for this prepared statement are freed.See also https://en.wikipedia.org/wiki/Prepared_statementA prepared statement can be more efficient, especially if it is used multiple times. Prepared statements are also resilient against SQL injection attacks. On the server, prepared statements are bound to the current session.My API and the syntax that I use ($n) is mostly polymorphic with P3FormattedStatement. The difference is that I do much more than textual processing: my SQL template is actually parsed on the server, checking the syntax and partially planning the execution, during the actual execution phase, just the concrete argument values are transferred, taking advantage of some of the work that has already been done on the server. '!

!P3PreparedStatement categoriesForClass!P3-Core! !

!P3PreparedStatement methodsFor!

bindStrings: inputValues	| msgBuilder |	msgBuilder := client newMessageBuilder.	msgBuilder		nextPutString: '';		nextPutString: name;		nextPutInt16: 0;		nextPutInt16: inputValues size.	inputValues		with: paramDescriptions		do: [ :eachValue :paramDescription | 			eachValue				ifNil: [ msgBuilder nextPutNullParameter ]				ifNotNil: [ msgBuilder nextPutParameterAsText: eachValue description: paramDescription ] ].	msgBuilder nextPutInt16: 0. "All result columns use the text format"	client writeMessageNoFlush: msgBuilder asBytes tag: $B.		client logBinding: self inputValues: inputValues!

close	"Close this query and release server side resources."	client ifNil: [ ^ self ].	self writeCloseMessage: name type: $S.	self writeFlushMessage.			"Check for CloseComplete message"	client readMessage tag = $3		ifFalse: [ P3Error closeCompleteExpected signal ].			"This prepared statement can no longer be used."	client forgetPreparedStatementNamed: name.	client := nil!

converter 	^ client converter!

execute: inputRow	"Execute this SQL query with inputRow as the ordered collection of parameters.	Assume no rows will be returned."	client setSource: self source.	self bindStrings: inputRow.	self writeExecuteMessage: 0.	client writeSyncMessage.		^ (client runExtendedQueryResults: fieldDescriptions) first result!

executeBatch: inputRows	"Execute this SQL query multiple (inputRow size) times in a single network roundtrip.	Assume no rows will be returned."	inputRows isEmpty		ifTrue: [ ^ #() ].	client setSource: self source.	inputRows do: [ :eachRow |		self bindStrings: eachRow.		self writeExecuteMessage: 0 ].	client writeSyncMessage.		^ (client runExtendedQueryResults: fieldDescriptions) collect: [ :each | each result ]!

fieldCount	^ fieldDescriptions size!

fieldDescriptions	^ fieldDescriptions!

initializeWith: aClient name: aString parameters: aParamDescriptions fields: aRowFieldDescriptions	client := aClient.	name := aString.	paramDescriptions := aParamDescriptions.	fieldDescriptions := aRowFieldDescriptions!

name	^ name!

paramCount	^ paramDescriptions size!

paramDescriptions	^ paramDescriptions!

printOn: stream	super printOn: stream.	stream nextPut: $(; << name; nextPut: $)!

query: inputRow	"Execute this SQL query with inputRow as the ordered collection of parameters.	Answer a P3Result object with the field descriptions and rows."	client setSource: self source.	self bindStrings: inputRow.	self writeExecuteMessage: 0.	client writeSyncMessage.		^ (client runExtendedQueryResults: fieldDescriptions) first!

queryAll: inputRows	"Execute this SQL query multiple times.	Answer a collection of P3Result objects with the field descriptions and rows."	inputRows isEmpty		ifTrue: [ ^ #() ].	client setSource: self source.	inputRows do: [ :eachRow |		self bindStrings: eachRow.		self writeExecuteMessage: 0 ].	client writeSyncMessage.		^ client runExtendedQueryResults: fieldDescriptions!

source	"Return my SQL source"		^ source!

source: anSQLTemplateString	source := anSQLTemplateString!

writeCloseMessage: aName type: aChar	| msgBuilder |	msgBuilder := client newMessageBuilder.	msgBuilder 		nextPutByte: aChar asInteger;		nextPutString: aName.	client writeMessageNoFlush: msgBuilder asBytes tag: $C!

writeDescribeMessage: aName type: aChar	"Type $S to describe a prepared statement; or $P to describe a portal."	| msgBuilder |	msgBuilder := client newMessageBuilder.	msgBuilder		nextPutByte: aChar asInteger;		nextPutString: aName.	client writeMessageNoFlush: msgBuilder asBytes tag: $D!

writeExecuteMessage: rowLimit	| msgBuilder |	msgBuilder := client newMessageBuilder.	msgBuilder		nextPutString: '';		nextPutInt32: rowLimit.	client writeMessageNoFlush: msgBuilder asBytes tag: $E!

writeFlushMessage	client writeMessage: #[] tag: $H! !

!P3PreparedStatement categoriesForMethods!
bindStrings:!input/output!public! !
close!public! !
converter!accessing!public! !
execute:!public! !
executeBatch:!public! !
fieldCount!accessing!public! !
fieldDescriptions!accessing!public! !
initializeWith:name:parameters:fields:!initialization!public! !
name!accessing!public! !
paramCount!accessing!public! !
paramDescriptions!accessing!public! !
printOn:!printing!public! !
query:!public! !
queryAll:!public! !
source!accessing!public! !
source:!accessing!public! !
writeCloseMessage:type:!input/output!public! !
writeDescribeMessage:type:!input/output!public! !
writeExecuteMessage:!input/output!public! !
writeFlushMessage!input/output!public! !
!

!P3PreparedStatement class methodsFor!

newWith: aClient name: aString parameters: paramDescriptions fields: rowDescriptions	^ self new initializeWith: aClient name: aString parameters: paramDescriptions fields: rowDescriptions! !

!P3PreparedStatement class categoriesForMethods!
newWith:name:parameters:fields:!instance creation!public! !
!

