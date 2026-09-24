"Filed out from Dolphin Smalltalk"!

Object subclass: #P3Client
	instanceVariableNames: 'connection session settings properties converter message access url isLogging'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Client guid: (GUID fromString: '{271b691c-801b-4709-bcb0-0d5854eb44f9}')!

P3Client comment: 'I am P3Client, a lean and mean PostgreSQL client.PostgreSQL, often simply Postgres, is a free and open-source, ACID-compliant and transactional object-relational database management system (ORDBMS).I use frontend/backend protocol 3.0 (PostgreSQL version 7.4 [2003] and later), implementing the simple query cycle. I support plaintext and md5 password authentication. When SQL queries return row data, I efficiently convert incoming data to objects. I support most common PostgreSQL types (P3Converter supportedTypes).I can be configured manually or through a URL.  P3Client new url: ''psql://username:password@localhost:5432/databasename?sslmode=require''.Not all properties need to be specified, the minimum is the following URL.  P3Client new url: ''psql://user@localhost''.I have a minimal public protocol, basically #query: (#execute: is an alias).Opening a connection to the server (#open) and running the authentication and startup protocols (#connect) are done automatically when needed from #query.I also support SSL connections. Use #connectSSL to initiate such a connection.I represent a single database connection or session, I am not thread safe.Examples Here is the simplest test that does an actual query, it should return true.    (P3Client new url: ''psql://sven@localhost'') in: [ :client |        [ client isWorking ] ensure: [ client close ] ].Here is how to create a simple table with some rows in it.    (P3Client new url: ''psql://sven@localhost'') in: [ :client |        client execute: ''DROP TABLE IF EXISTS table1''.        client execute: ''CREATE TABLE table1 (id INTEGER, name TEXT, enabled BOOLEAN)''.        client execute: ''INSERT INTO table1 (id, name, enabled) VALUES (1, ''''foo'''', true)''.        client execute: ''INSERT INTO table1 (id, name, enabled) VALUES (2, ''''bar'''', false)''.        client close ].	Now we can query the contents of the simple table we just created.    (P3Client new url: ''psql://sven@localhost'') in: [ :client |        [ client query: ''SELECT * FROM table1'' ] ensure: [ client close ] ].The result is an instance of P3Result    a P3Result(''SELECT 2'' 2 records 3 columns)P3Result contains 3 elements,  results, descriptions & data:- Results is a string (collection of strings for multiple embedded queries) indicating successful execution.- Descriptions is a collection of row field description objects.- Data is a collection of rows with fully converted field values as objects.The data itself is an array with 2 sub arrays, one for each record.    #( #(1 ''foo'' true) #(2 ''bar'' false) )Finally we can clean up.    (P3Client new url: ''psql://sven@localhost'') in: [ :client |        [ client execute: ''DROP TABLE table1'' ] ensure: [ client close ] ].References -  https://postgresql.org-  https://en.wikipedia.org/wiki/PostgreSQL-  https://www.postgresql.org/docs/9.6/static/protocol.htmlSee also P3DatabaseDriver, an interface between Glorp, an advanced object-relational mapper, and me.'!

!P3Client categoriesForClass!P3-Core! !

!P3Client methodsFor!

asCString: string	| bytes |	bytes := ByteArray new: string size + 1.	"implicit cheap ASCII conversion"	bytes replaceFrom: 1 to: string size with: string startingAt: 1. 	"last byte is 0"	^ bytes!

authenticationTypes
	^#(
		nil 
		#handleAuthenticationKerberosV5 
		#handleAuthenticationCleartextPassword 
		nil 
		#handleAuthenticationMD5Password 
		#handleAuthenticationSCMCredential 
		#handleAuthenticationGSS 
		nil 
		#handleAuthenticationSSPI 
		#handleAuthenticationSASL
	)!

beThreadSafe
	"Configure me so that I can be safely used from multiple threads/processes during important operations"
	
	access := Mutex new!

clearSession	session := nil!

clearSSL	settings removeKey: #ssl ifAbsent: [ ]!

clearTextPasswordMessage	self password ifNil: [ P3Error passwordRequired signal ].	^ self asCString: self password!

close	"Cleanly close my connection with the server"	connection ifNotNil: [		self logDisconnected. 		[ 			self writeMessage: #[] tag: $X.			connection close ] on: Error do: [ :x | x return: nil ].				self clearSession.		connection := nil		 ]!

compactUrl	^ '<1s>@<2s>' << {self url firstPathSegment. self url host}!

connect	"Connect me to a PostgreSQL database. 	Run the authentication and startup protocols. Configure the session."	self critical: [ 		self			ensureOpen;			connectInternal;			clearSSL;			logConnected ]!

connectInternal	"Run the authentication and startup protocols. Configure the session."		self 		writeMessage: self startupMessage;		reset;		runAuthentication;		runStartup;		initializeConverter!

connection	"Return the network connection I am using.	When I am not connected, return nil."		^ connection!

connectSSL	"Connect me to a PostgreSQL database over an encrypted SSL connection. 	Run the authentication and startup protocols. Configure the session."	self critical: [		self			ensureOpen;			upgradeToSSL;			connectInternal;			setSSL;			logConnected ]!

converter	"Return the converter that I am using.	It holds the character encoding and timezone of the current database connection."		^ converter ifNil: [ converter := P3Converter new ]!

converter: anObject	converter := anObject!

createPreparedStatementNamed: name withParameters: parameterDescriptions andFields: rowDescriptions	| preparedStatement |	preparedStatement := P3PreparedStatement 		newWith: self 		name: name 		parameters: parameterDescriptions 		fields: rowDescriptions.	(properties at: 'prepared_statements' ifAbsentPut: [ Dictionary new ])		at: name put: preparedStatement.	^ preparedStatement!

critical: block	^ access		ifNil: [block]		ifNotNil: [ access critical: block ]!

database	"Return the database name I (want to) connect to.	For the default, nil is used."		^ settings at: #database ifAbsent: [ nil ]!

database: string	"Set the name of the database to connect to.	Set to nil or do not set to use the default."		settings at: #database put: string!

ensureConnected	self isConnected		ifFalse: [ 			self isSSL				ifTrue: [ self connectSSL ]				ifFalse: [ self connect ] ]!

ensureOpen	connection ifNil: [ self open ]!

errorNoticeInfo: payload	| info fieldType |	info := Dictionary new.	[ (fieldType := payload next) isZero ] 		whileFalse: [ 			info 				at: fieldType asCharacter 				put: (self converter asciiCStringFrom: payload) ].	^ info!

execute: query	"Execute an SQL query against PostgreSQL, assuming no rows will be returned.	Result is a string (collection of strings for multiple embedded queries) indicating successful execution.	This is an alias for #query returning just the command result."		| result |	result := self query: query.	^ result results!

forgetPreparedStatementNamed: name	properties 		at: 'prepared_statements' 		ifPresent: [ :preparedStatements | 			preparedStatements removeKey: name ifAbsent: [ ] ]!

format: anSQLTemplateString	"Create and return a P3FormattedStatement based on anSQLTemplateString and bound to me.	The template contains numbered placeholders, $1, $2, etc, that are filled with concrete	arguments when the statement is executed. 	This should be safer and more correct than building a query manually."		^ P3FormattedStatement new		client: self;		sql: anSQLTemplateString;		yourself!

handleAuthentication: code
	| type |

	code = 0 "OK" ifTrue: [^true].
	type := self authenticationTypes 		at: code 		ifAbsent: [ (P3Error unsupportedAuthenticationType: code) signal ].
	properties at: #'authentication_type' ifAbsentPut: [type].	^ self perform: type!

handleAuthenticationCleartextPassword	self writeMessage: self clearTextPasswordMessage tag: $p.	^ false!

handleAuthenticationGSS	(P3Error unsupportedAuthenticationType: #GSS) signal!

handleAuthenticationKerberosV5	(P3Error unsupportedAuthenticationType: #KerberosV5) signal!

handleAuthenticationMD5Password
	| salt |
	salt := message readStream next: 4.
	self writeMessage: (self md5PasswordMessage: salt) tag: $p.
	^ false!

handleAuthenticationOk	^ true!

handleAuthenticationSASL	| saslAuthenticationMechanisms |	saslAuthenticationMechanisms := Array streamContents: [ :out | | line |		[ (line := self converter asciiCStringFrom: message readStream) isEmpty ]			whileFalse: [ out nextPut: line ] ].	(saslAuthenticationMechanisms includes: 'SCRAM-SHA-256')		ifTrue: [			self runSASLSCRAMSHA256Authentication. 			^ false ].	(P3Error unsupportedAuthenticationType: #SASL) signal!

handleAuthenticationSCMCredential	(P3Error unsupportedAuthenticationType: #SCMCredential) signal!

handleAuthenticationSSPI	(P3Error unsupportedAuthenticationType: #SSPI) signal!

host	"Return the host name I (want to) connect to.	The default is localhost."	^ settings at: #host ifAbsentPut: [ 'localhost' ]!

host: string	"Set the name of the host to connect to.	If not set, defaults to localhost."		settings at: #host put: string!

initialize	super initialize.		settings := IdentityDictionary new.	properties := Dictionary new.
	isLogging := false.		self beThreadSafe!

initializeConverter	self converter initializeFrom: properties!

isConnected	"Return true when my connection is in working order (from my end)"	^ connection notNil			and: [ connection isConnected 				and: [ session notNil ] ]!

isLogging

	^isLogging!

isServerVersionAtLeastMajor: major minor: minor	"Return true when the server version if at least major.minor, false otherwise"		| serverVersion |	serverVersion := ($. split: self serverVersion) collect: [ :each |		"try to be robust for non-numeric version elements"		[Number fromString: each] on: InvalidFormat do: [ :exc | exc return: nil] ].	^ serverVersion first > major			or: [ 				serverVersion first = major 					and: [ serverVersion second >= minor ] ]!

isSSL	"Return true if my current connection is SSL encrypted"		^ settings at: #ssl ifAbsent: [ false ]!

isWorking	"Do a trivial query to confirm that I can interact with the server.	Return true if successful"		| n result |	n := (Random new next * 999) asInteger.	result := self query: ('SELECT <1d> AS N' << n ).	^ result result = 'SELECT 1' and: [ result firstFieldOfFirstRecord = n ]!

listDatabases	"Return the list of known database names.	I can only be connected to a single database, see #database"		^ (self query: 'SELECT datname FROM pg_database ORDER BY 1') firstColumnData!

listEnums	"Return the list of currently defined/visible ENUMs as a collection of type OID, type name pairs.	See also #loadEnums"		^ (self query: 'SELECT oid, typname FROM pg_type WHERE oid IN (SELECT DISTINCT enumtypid FROM pg_enum)') data!

listSchemas	"Return the list of known schema or namespace names"		^ (self query: 'SELECT schema_name FROM information_schema.schemata ORDER BY 1') firstColumnData!

listTablesInSchema: schemaName	"Return the list of known table names in a given schema as table name, table type pairs."		| statement |	statement := self format: 'SELECT table_name, table_type FROM information_schema.tables WHERE table_schema = $1 ORDER BY 1'.	^ (statement query: { schemaName } ) data!

loadEnums	"Define converters for all ENUM type OIDs currently visible, converting their values to Symbols.	In PSQL ENUMs constitute distinct type OIDs and must be thus be defined before they can be used in results.	Since new ENUMs can be added at any time, there is no good/correct time to call this method.	Either call #loadEnums as an initialization for a new connection, or after (all) ENUMs are (re)defined.	Return the collection of enum type names processed."		^ self listEnums collect: [ :each |		self converter			mapOid: each first 			type: each second asSymbol 			to: #convertSymbolFrom:length:description:.		each second asSymbol ]!

logBinding: statement inputValues: inputValues
	isLogging ifFalse: [^self].	(self newLogEvent: P3StatementBoundEvent)		statement: statement;		inputValues: inputValues;		emit.	properties at: #query_started put: Time millisecondClockValue!

logConnected
	isLogging ifFalse: [^self].	(self newLogEvent: P3ConnectionEstablishedEvent)		settings: settings copy;		properties: properties copy;		emit!

logDisconnected
	isLogging ifFalse: [^self].	(self newLogEvent: P3ConnectionClosedEvent)		emit !

logError: error
	isLogging ifFalse: [^self].	(self newLogEvent: P3ErrorOccurredEvent)		exception: error;		emit!

logPreparedStatement: statement query: query
	isLogging ifFalse: [^self].	(self newLogEvent: P3StatementPreparedEvent)		statement: statement;		query: query;		emit!

logQuery: query
	isLogging ifFalse: [^self].	(self newLogEvent: P3QueryWrittenEvent)		query: query;		emit.	properties at: #query_started ifAbsentPut: [Time millisecondClockValue]!

logResult: result	| duration |
	isLogging ifFalse: [^self].	duration := (properties at: #query_started ifAbsent: [nil]) ifNil: [0] ifNotNil: [ :initialMilliseconds | Time millisecondClockValue - initialMilliseconds ].	(self newLogEvent: P3ResultReadEvent)		result: result;		duration: duration;		emit.	properties removeKey: #query_started ifAbsent: [  ]!

logRetryConnection: remaining
	isLogging ifFalse: [^self].	(self newLogEvent: P3RetryConnectionEvent)		remaining: remaining;		delay: self retryDelay;		emit!

md5PasswordMessage: salt	"concat('md5', md5(concat(md5(concat(password, username)), random-salt))).	Keep in mind the md5() function returns its result as a hex string."		self error: 'not supported'!

newLogEvent: logEventClass	^ logEventClass new			session: self session;			yourself!

newMessageBuilder	^ P3MessageBuilder new!

open
	"Open my connection with the server (do not yet #connect)"
	| socket |
	self close.
	socket := TlsSocket port: self port host: self host.
	socket shouldSecureOnConnect: false.
	socket connect.
	connection := 	P3Connection on: socket.	
	message := P3MessageBuffer new!

password	"Return the password of my database connection.	For no password, nil is used."	^ settings at: #password ifAbsent: [ nil ]!

password: string	"Set the password to use when connecting.	Set to nil or don't set to use no password."	settings at: #password put: string!

port	"Return the port I (want to) connect to.	The default is 5432."	^ settings at: #port ifAbsentPut: [ 5432 ]!

port: integer	"Set the port to connect to.	If not set, defaults to 5432."		settings at: #port put: integer!

prepare: query	"Create a P3PreparedStatement with a default name derived from the query string. 	Only the first 63 characters of the name are significant. For longer queries try	to make a unique name by using the hash value of the query string."	| name |		name := query.	name size > 63		ifTrue: [ 			| hashString |			hashString := name hash printStringRadix: 16 showRadix: false.			name := (name copyFrom: 1 to: 62 - hashString size), '_', hashString ].			^ self prepare: query named: name!

prepare: query named: queryName	"Create and return an instance of P3PreparedStatement by parsing query, 	which can contain one or more placeholders, once. Later the prepared statement can be executed 	multiple times by providing an array with a value for each placeholder. 	When no longer needed, the prepared statement should be closed. See P3PreparedStatement.	Each prepared statement must have a unique name. Note that in a standard Postgres installation 	only the first 63 characters of queryName are significant."	^self critical: [| parameterDescriptions rowDescriptions statement |		self 			ensureConnected;			writeParseMessage: query name: queryName types: #();			writeDescribeMessage: queryName type: $S;			writeSyncMessage.		self readMessage tag = $1			ifFalse: [ P3Error parseCompleteExpected signal ].		self readMessage tag = $t			ifTrue: [ parameterDescriptions := self processParameterDescription: message readStream ]			ifFalse: [ 				parameterDescriptions := #().				message tag = $n 					ifFalse: [ P3Error noDataExpected signal ] ].		self readMessage tag = $T			ifTrue: [ rowDescriptions := self processRowDescription: message readStream ]			ifFalse: [ 				rowDescriptions := #().				message tag = $n					ifFalse: [ P3Error noDataExpected signal ] ].		self readMessage tag = $Z			ifFalse: [ P3Error readyForQueryExpected signal ].		statement := self 			createPreparedStatementNamed: queryName 			withParameters: parameterDescriptions 			andFields: rowDescriptions.					statement source: query.			self logPreparedStatement: statement query: query.

		statement]!

preparedStatementNamed: name	"Return the P3PreparedStatement previously created under name, else signal NotFound"		^(properties at: 'prepared_statements') at: name!

printOn: stream	super printOn: stream.	stream nextPut: $(.	self printStateOn:  stream.	stream nextPut: $)!

printStateOn: stream	stream display: self compactUrl.	self session ifNotNil: [ stream space; print: session ]!

processBackendKeyData: payload
	session := payload p3uint32.
	properties at: 'backend_process_id' put: session.
	properties at: 'backend_secret_key' put: payload p3uint32!

processDataRowUsing: description
	| count record readStream |
	readStream := message readStream.
	count := readStream p3uint16.
	record := Array new: count.
	1 to: count do: [ :index | | size |
		size := readStream p3uint32.
		size = 16rFFFFFFFF
			ifFalse: [ | object |
				object := (description at: index) convert: readStream length: size using: converter.
				record at: index put: object ] ].
	^ record!

processParameterDescription: payload
	| count |
	count := payload p3uint16.
	^ Array new: count streamContents: [ :out |
			count timesRepeat: [ 
				out nextPut: (P3ParameterDescription new
					typeOid: payload p3uint32;
					yourself) ] ]!

processParameterStatus: payload	"Do not yet use the converter since it is not yet initialized"		| key value |		key := self converter asciiCStringFrom: payload.	value := self converter asciiCStringFrom: payload.			properties at: key put: value!

processRowDescription: payload
	| count |
	count := payload p3uint16.
	^ Array new: count streamContents: [ :out |
			count timesRepeat: [ 
				out nextPut: (P3RowFieldDescription new
					fieldName: (self converter encodedCStringFrom: payload);
					tableOid: payload p3uint32 ;
					attributeNumber: payload p3uint16;
					typeOid: payload p3uint32;
					typeSize: payload p3uint16;
					typeModifier: payload p3uint32;
					format: payload p3uint16;
					yourself) ] ]!

query: query	"Execute an SQL query against PostgreSQL. Return a P3Result object containing result(s), column descriptions and data.	Result(s) is a string (collection of strings for multiple embedded queries) indicating successful execution.	Descriptions is a collection of row field description objects, if any.	Data is a collection of rows with fully converted field values as objects, if any."	^ self critical: [		self withConnection: [			self ensureConnected.			properties at: #sql_source put: query.			self writeQueryMessage: query.			self runQueryResult ] ]!

queryEncoding	"An alias used by PharoDatabaseAccessor, kept for compatibility"		^ self serverEncoding!

readMessage	"During normal operations, an error is reported followed by a ready for query so that we can continue to use the connection"		^ self readMessageOnError: [ self assert: [self readMessage tag = $Z ]]!

readMessageCloseAfterError	"During authentication and startup errors result in the server closing the connection, do the same"		^ self readMessageOnError: [ self close ]!

readMessageOnError: block	message readFrom: connection.	message tag = $E 		ifTrue: [ | info |			info := self errorNoticeInfo: message readStream.			block cull: info.			self signal: P3Error using: info ].	message tag = $N 		ifTrue: [ | info |			info := self errorNoticeInfo: message readStream.			self signal: P3Notification using: info.			^ self readMessage ].	^ message!

reset	self clearSession.	properties removeAll.	converter := nil!

retryCount	"Return how many times a reconnection will be tried on a failed connection, the default being 10 times.	See also #retryDelay."		^ settings at: #retryCount ifAbsentPut: [ 10 ]!

retryCount: count	"Set how many times a reconnection will be tried on a failed connection, the default being 10 times.	See also #retryDelay:"		settings at: #retryCount put: count!

retryDelay	"Return the delay after which a reconnection will be tried on a failed connection, the default being 5 seconds.	See also #retryCount."		^ settings at: #retryDelay ifAbsentPut: [ 5 ]!

retryDelay: seconds	"Set the delay after which a reconnection will be tried on a failed connection, the default being 5 seconds.	See also #retryCount:"		settings at: #retryDelay put: 5!

runAuthentication
	[
	self readMessageCloseAfterError tag = $R
		ifTrue: [ | authenticationCode |
			authenticationCode := message readStream p3uint32.
			(self handleAuthentication: authenticationCode)
				ifTrue: [ ^ self ] ]
		ifFalse: [ 
			^ P3Error unexpectedMessageDuringAuthentication signal ] ] repeat!

runExtendedQueryResult: descriptions	"Read DataRow ($D) messages until either a CommandComplete ($C) or PortalSuspended ($s) message is received."	| rows result |	"Check for BindComplete message"	message tag = $2		ifFalse: [ ^ P3Error bindCompleteExpected signal ].	self readMessage.	rows := Array streamContents: [ :out |		[ 'Cs' includes: message tag ] whileFalse: [ 			self assert: [message tag = $D].			out nextPut: (self processDataRowUsing: descriptions).			self readMessage ] ].		result := P3Result 		descriptions: descriptions		data: rows 		results: (self converter asciiCStringFrom: message readStream).	result source: (properties at: #sql_source ifAbsent: nil).	self logResult: result.	 	^ result!

runExtendedQueryResults: fieldDescriptions	^self critical: [| queryStarted |		queryStarted := Time millisecondClockValue.		self readMessage.		Array streamContents: [ :out |			[				"each result will use the same start"				properties at: #query_started ifAbsentPut: [queryStarted].				out nextPut: (self runExtendedQueryResult: fieldDescriptions).				self readMessage tag = $Z ] whileFalse ] ]!

runQueryResult	| result |	result := P3Result new.	self readMessage. 	[ 		message tag = $T			ifTrue: [ result descriptions: (self processRowDescription: message readStream) ].		message tag = $C			ifFalse: [ 				result data: (Array streamContents: [ :out | 					[ self readMessage tag = $C ] whileFalse: [ 						self assert: [message tag = $D].						out nextPut: (self processDataRowUsing: result descriptions) ] ]) ].		result addResult: (self converter asciiCStringFrom: message readStream).		self readMessage tag = $S			ifTrue: [ self processParameterStatus: message readStream; readMessage ].		message tag = $Z ] whileFalse.	result source: (properties at: #sql_source ifAbsent: nil).	self logResult: result.	^ result!

runSASLSCRAMSHA256Authentication	| scram  |	scram := self scramSHA256.	self writeMessage: (self saslSCRAMSHA256FirstMessage: scram) tag: $p. "SASLInitialResponse"	self readMessageCloseAfterError tag = $R "AuthenticationSASLContinue"		ifFalse: [ P3Error unexpectedMessageDuringAuthentication signal ].	self assert: [((message readStream next: 4) reverse sdwordAtOffset: 0) = 11].	scram serverFirstMessage: message readStream upToEnd asString.	self writeMessage: scram clientFinalMessage asByteArray tag: $p. "SASLResponse"	self readMessageCloseAfterError tag = $R "AuthenticationSASLFinal"		ifFalse: [ P3Error unexpectedMessageDuringAuthentication signal ].	self assert: [((message readStream next: 4) reverse sdwordAtOffset: 0) = 12].	scram serverFinalMessage: message readStream upToEnd asString!

runStartup	session := (Random new next * 999999) asInteger. "Sometimes $K is not sent and we need a nonNil session"	[	self readMessageCloseAfterError tag = $Z		ifTrue: [ ^ self ].	message tag = $S		ifTrue: [ self processParameterStatus: message readStream ]		ifFalse: [  			message tag = $K				ifTrue: [ self processBackendKeyData: message readStream ]				ifFalse: [ ^ P3Error unexpectedMessageDuringStartup signal ] ] ] repeat!

saslSCRAMSHA256FirstMessage: scram	| saslMessage |	saslMessage := scram clientFirstMessage.	^ (self asCString: 'SCRAM-SHA-256')		, ((4 to: 1 by: -1) collect: [ :index | saslMessage size byteAt: index]) asByteArray 		, saslMessage asByteArray!

scramSHA256	self password ifNil: [ P3Error passwordRequired signal ].	^ P3SCRAM		storeAt: self url		ifAbsentPut: [ 			P3SCRAM new				sha256;				password: self password;				yourself ]!

serverEncoding	"Return the name of the encoder/decoder used by the server for this session/connection.	This is determined automatically from the client_encoding property of the server.	One way to set the default at the database level is with the SQL command	ALTER DATABASE <mydb> SET client_encoding TO 'UTF8' "		self ensureConnected.	^ nil!

serverVersion	"Return the version string of the PostgreSQL server"		self ensureConnected.	^ properties 		at: 'server_version' 		ifAbsent: [ (self query: 'SHOW server_version') firstFieldOfFirstRecord ]!

session	"Returns the current session identifier (backend process id) if connected"		self isConnected ifFalse: [ self clearSession ].	^ session!

setSource: sql	properties at: #sql_source put: sql!

setSSL	"Set a flag to make me use TLS/SSL when connecting to PostgrSQL.	The default is to use a plain unencrypted network connection."		settings at: #ssl put: true!

signal: exceptionClass using: info	| exception |	(exception := exceptionClass new) 		info: info.	self logError: exception.	exception signal!

sslRequestMessage	^ #[4 210 22 47] "1234 5678"!

startLogging

	isLogging := true!

startupMessage	^ ByteArray streamContents: [ :out |			out nextPutAll: #[ 0 3 0 0 ]. "Protocol major.minor 3.0"			out nextPutAll: (self asCString: 'user').			out nextPutAll: (self asCString: self user).			self database ifNotNil: [ 				out nextPutAll: (self asCString: 'database').				out nextPutAll: (self asCString: self database) ].			self startupOptions ifNotNil: [				out nextPutAll: (self asCString: 'options').				out nextPutAll: (self asCString: self startupOptions) ].			out nextPut: 0 ]!

startupOptions	^ settings at: #options ifAbsent: [ nil ]!

startupOptions: optionsString	settings at: #options put: optionsString!

statePrintString	^ String streamContents: [ :out | self printStateOn: out ]!

stopLogging

	isLogging := false!

timeout	"Return the timeout in seconds I (want to) use, the default being 10 seconds."		^ settings at: #timeout ifAbsentPut: [ 10 ]!

timeout: seconds	settings at: #timeout put: seconds!

upgradeToSSL
	| reply |
	self writeMessage: self sslRequestMessage.
	reply := connection next asCharacter.
	reply = $S
		ifTrue: [ connection := connection secureConnection]
		ifFalse: [ 
			P3Error postgreSQLServerDidNotHonorSSLConnectionRequest signal ]
!

url	"Return my connection URL"		^url!

url: stringOrUrl	"Set my connection settings from stringOrUrl according to the format	postgresql://username:password@localhost:5432/databasename?sslmode=require	with the minimum being psql://user@localhost , for a unix socket the format is	postgresql:///databasename?host=/path/to/psql.socket&user=username&password=password"	url := P3URL fromString: stringOrUrl.	self assert: [#(psql postgres postgresql) includes: url scheme].	url host		ifNil: [			url queryAt: #host ifPresent: [ :host | self host: host ].			url queryAt: #user ifPresent: [ :user | self user: user ].			url queryAt: #password ifPresent: [ :password | self password: password ] ]		ifNotNil: [			self				host: url host;				port: (url portIfAbsent: [ 5432 ]);				user: url username;				password: url password ].	self database: url firstPathSegment.	(url queryAt: #sslmode ifAbsent: [ #disable ]) = #require		ifTrue: [ self setSSL ].	url queryAt: #options ifPresent: [ :options | self startupOptions: options ]!

user	"Return the user of my database connection.	For the default, nil is used."	^ settings at: #user ifAbsent: [ nil ]!

user: string	"Set the user to use when connecting.	Set to nil or don't set to use the default."		settings at: #user put: string!

verbose: flag	"Enable logging to the Transcript when flag is true.	Disable logging to the Transcript when flag is false.	Note that P3 uses object logging, with which you can do much more than output plain strings."		flag		ifTrue: [ P3LogEvent logToTranscript ] 		ifFalse: [ P3LogEvent stopLoggingToTranscript ]!

withConnection: block
	"Execute block, code that will use my connection.
	Handle network errors with a retry/reconnection scheme"
	
	^ [ block value "first try" ] on: SocketError do: 
		[ :exc | 
		self close. "first immediate retry"
		self retryCount to: 1 by: -1 do: 
			[ :remaining | 
			[ exc return:  block value ]
				on: SocketError
				do: 
					[ :exc2 | 
					self close. "retry after wait"
					self logRetryConnection: remaining.
					self retryDelay seconds wait ] ].
		exc return: block value "final unprotected try" ]!

writeDescribeMessage: aName type: aChar	"Type $S to describe a prepared statement; or $P to describe a portal."		| msgBuilder |	msgBuilder := self newMessageBuilder.	msgBuilder		nextPutByte: aChar asInteger;		nextPutString: aName.	self writeMessageNoFlush: msgBuilder asBytes tag: $D!

writeMessage: payload	| size |	size := payload size + 4.	4 to: 1 by: -1 do: [ :index | connection nextPut: (size byteAt: index) ].	payload notEmpty 		ifTrue: [ connection nextPutAll: payload ].	connection flush!

writeMessage: payload tag: tag	connection nextPut: tag asInteger.	self writeMessage: payload!

writeMessageNoFlush: payload	| size |	size := payload size + 4.	4 to: 1 by: -1 do: [ :index | connection nextPut: (size byteAt: index) ].	connection nextPutAll: payload.!

writeMessageNoFlush: payload tag: tag	connection nextPut: tag asInteger.	self writeMessageNoFlush: payload!

writeParseMessage: queryString name: statementName types: paramDataTypes	| msgBuilder |	msgBuilder := self newMessageBuilder.	msgBuilder		nextPutString: statementName;		nextPutString: queryString;		nextPutInt16: paramDataTypes size.	paramDataTypes do: [ :each | msgBuilder nextPutInt32: each ].	self writeMessage: msgBuilder asBytes tag: $P 	!

writeQueryMessage: queryString	| size |	connection nextPut: $Q asInteger.	size := queryString size + 5.	4 to: 1 by: -1 do: [ :index | connection nextPut: (size byteAt: index) ].
	connection nextPutAll: queryString asByteArray.	connection nextPut: 0.	connection flush.	self logQuery: queryString!

writeSyncMessage	self writeMessage: #[] tag: $S. ! !

!P3Client categoriesForMethods!
asCString:!private! !
authenticationTypes!private / authentication!public! !
beThreadSafe!initialize/release!public! !
clearSession!private! !
clearSSL!private! !
clearTextPasswordMessage!private messages!public! !
close!initialize/release!public! !
compactUrl!accessing!public! !
connect!public! !
connectInternal!protocol!public! !
connection!accessing!public! !
connectSSL!public! !
converter!accessing!public! !
converter:!private! !
createPreparedStatementNamed:withParameters:andFields:!private! !
critical:!private! !
database!accessing!public! !
database:!initialize/release!public! !
ensureConnected!private! !
ensureOpen!private! !
errorNoticeInfo:!error handling!public! !
execute:!public! !
forgetPreparedStatementNamed:!private! !
format:!public! !
handleAuthentication:!private / authentication!public! !
handleAuthenticationCleartextPassword!private / authentication!public! !
handleAuthenticationGSS!private / authentication!public! !
handleAuthenticationKerberosV5!private / authentication!public! !
handleAuthenticationMD5Password!private / authentication!public! !
handleAuthenticationOk!private / authentication!public! !
handleAuthenticationSASL!private / authentication!public! !
handleAuthenticationSCMCredential!private / authentication!public! !
handleAuthenticationSSPI!private / authentication!public! !
host!accessing!public! !
host:!initialize/release!public! !
initialize!initialize/release!public! !
initializeConverter!private! !
isConnected!public!testing! !
isLogging!public!testing! !
isServerVersionAtLeastMajor:minor:!public!testing! !
isSSL!public!testing! !
isWorking!public!testing! !
listDatabases!convenience!public! !
listEnums!convenience!public! !
listSchemas!convenience!public! !
listTablesInSchema:!convenience!public! !
loadEnums!configuration!public! !
logBinding:inputValues:!private / logging!public! !
logConnected!private / logging!public! !
logDisconnected!private / logging!public! !
logError:!private / logging!public! !
logPreparedStatement:query:!private / logging!public! !
logQuery:!private / logging!public! !
logResult:!private / logging!public! !
logRetryConnection:!private / logging!public! !
md5PasswordMessage:!private messages!public! !
newLogEvent:!private / logging!public! !
newMessageBuilder!private! !
open!initialize/release!public! !
password!accessing!public! !
password:!initialize/release!public! !
port!accessing!public! !
port:!initialize/release!public! !
prepare:!public! !
prepare:named:!public! !
preparedStatementNamed:!accessing!public! !
printOn:!printing!public! !
printStateOn:!printing!public! !
processBackendKeyData:!private! !
processDataRowUsing:!private! !
processParameterDescription:!private! !
processParameterStatus:!private! !
processRowDescription:!private! !
query:!public! !
queryEncoding!accessing!public! !
readMessage!input/output!public! !
readMessageCloseAfterError!input/output!public! !
readMessageOnError:!input/output!public! !
reset!private! !
retryCount!accessing!public! !
retryCount:!initialize/release!public! !
retryDelay!accessing!public! !
retryDelay:!initialize/release!public! !
runAuthentication!protocol!public! !
runExtendedQueryResult:!protocol!public! !
runExtendedQueryResults:!protocol!public! !
runQueryResult!protocol!public! !
runSASLSCRAMSHA256Authentication!private / authentication!public! !
runStartup!protocol!public! !
saslSCRAMSHA256FirstMessage:!private messages!public! !
scramSHA256!private / authentication!public! !
serverEncoding!accessing!public! !
serverVersion!accessing!public! !
session!accessing!public! !
setSource:!private! !
setSSL!initialize/release!public! !
signal:using:!error handling!public! !
sslRequestMessage!private messages!public! !
startLogging!initialize/release!public! !
startupMessage!private messages!public! !
startupOptions!accessing!public! !
startupOptions:!accessing!public! !
statePrintString!printing!public! !
stopLogging!initialize/release!public! !
timeout!accessing!public! !
timeout:!initialize/release!public! !
upgradeToSSL!protocol!public! !
url!accessing!public! !
url:!initialize/release!public! !
user!accessing!public! !
user:!initialize/release!public! !
verbose:!accessing!public! !
withConnection:!private! !
writeDescribeMessage:type:!input/output!public! !
writeMessage:!input/output!public! !
writeMessage:tag:!input/output!public! !
writeMessageNoFlush:!input/output!public! !
writeMessageNoFlush:tag:!input/output!public! !
writeParseMessage:name:types:!input/output!public! !
writeQueryMessage:!input/output!public! !
writeSyncMessage!input/output!public! !
!

!P3Client class methodsFor!

new

	^super new initialize!

url: anUrl	^ self new url: anUrl ! !

!P3Client class categoriesForMethods!
new!instance creation!public! !
url:!instance creation!public! !
!

