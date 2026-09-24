"Filed out from Dolphin Smalltalk"!

TestCase subclass: #P3ClientTest
	instanceVariableNames: 'client'
	classVariableNames: 'Url'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3ClientTest guid: (GUID fromString: '{23c18174-4643-4f12-bb44-3563cb67ff80}')!

P3ClientTest comment: 'P3ClientTest holds unit tests for the P3 PSQL client.Configure by setting my class side''s connection URL.  P3ClientTest url: ''psql://sven:secret@localhost:5432/database''.The minimal being the following:  P3ClientTest url: ''psql://sven@localhost''.Benchmarks  P3ClientTest new setupBenchmark1.  P3ClientTest new runBenchmark1.  P3ClientTest new runBenchmark1Bench.  P3ClientTest new runAllTests.'!

!P3ClientTest categoriesForClass!P3-Tests! !

!P3ClientTest methodsFor!

benchmark1Size	^ 10000!

runAllTests	"Runs all tests on the same connection/session"		| testSelectors timeToRun |	testSelectors := self class selectors select: [ :each | 'test*' match: each ].	self setUp.	timeToRun := [ testSelectors do: [ :each | self perform: each ] ] timeToRun.	self tearDown.	^ timeToRun !

runBenchmark1	| result timeToRun |	result := nil.	self setUp.	timeToRun := [ result := client query: 'SELECT * FROM benchmark1' ] timeToRun.	self assert: result numberOfRecords equals: self benchmark1Size.	self tearDown.	^ timeToRun !

runBenchmark1Bench	| result timeToRun |	result := nil.	self setUp.	timeToRun := [ result := client query: 'SELECT * FROM benchmark1' ] benchFor: 5 seconds.	self assert: result numberOfRecords equals: self benchmark1Size.	self tearDown.	^ timeToRun !

setUp	super setUp.	client := P3Client new.	client url: self class url.	client connect!

setupBenchmark1	| timeToRun |	self setUp. 	timeToRun := [		client query: 'DROP TABLE IF EXISTS benchmark1'.		client query: 'CREATE TABLE benchmark1 (n_int INTEGER, n_float FLOAT, hex TEXT, roman TEXT, words TEXT)'.		1 to: self benchmark1Size do: [ :n |			| sql |			sql := 'INSERT INTO benchmark1 (n_int, n_float, hex, roman, words) VALUES (<1d>, <2d>, <3p>, <4p>, <5p>)' 				<< { n. Float pi * n. n printStringHex. n printStringRoman.  n asWords }.			client query: sql ] ] timeToRun.	self tearDown.	^ timeToRun  !

tearDown	client close.	super tearDown!

testArrayTypes	| result |	client execute: 'DROP TABLE IF EXISTS table_a'.	client execute: 'CREATE TABLE table_a (id INTEGER, name TEXT, text_a TEXT[], int_a INTEGER[])'.	client execute: 'INSERT INTO table_a (id, name, text_a, int_a) VALUES (1, ''foo'', ARRAY[''foo'',''bar''], ARRAY[1,2])'.	client execute: 'INSERT INTO table_a (id, name, text_a, int_a) VALUES (2, ''null'', ''{"NULL",NULL}'', ''{0,NULL}'')'.	client execute: 'INSERT INTO table_a (id, name, text_a, int_a) VALUES (3, ''zero'', ''{}'', ''{}'')'.	client execute: 'INSERT INTO table_a (id, name, text_a, int_a) VALUES (4, ''escape'', ARRAY[''a"b'',''c\d''], ''{1,2}'')'.	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 1'.	self assert: result firstRecord equals: #(1 'foo' #('foo' 'bar') #(1 2)).	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 2'.	self assert: result firstRecord equals: #(2 'null' #('NULL' nil) #(0 nil)).	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 3'.	self assert: result firstRecord equals: #(3 'zero' #() #()).	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 4'.	self assert: result firstRecord equals: #(4 'escape' #('a"b' 'c\d') #(1 2)).	client execute: 'DROP TABLE table_a'!

testBitStringConversion	| result |	result := client query: 'SELECT B''11001111'''.	self assert: result firstFieldOfFirstRecord equals: (P3FixedBitString bits: 2r11110011).	result := client query: 'SELECT B''11001111''::bit varying'.	self assert: result firstFieldOfFirstRecord equals: (P3BitString bits: 2r11110011).!

testBooleanConversion	| result |	result := client query: 'SELECT b::boolean FROM (VALUES (true), (false), (NULL)) t(b)'.	self assert: result data equals: #((true) (false) (nil))!

testBoxConversion	| result |	result := client query: 'SELECT box ''(3,4),(1,2)'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Box upperRight: (P3Point x: 3 y: 4) lowerLeft: (P3Point x: 1 y: 2)).	result := client query: 'SELECT box ''(0,0),(0,0)'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3Box zero.	result := client query: 'SELECT box ''(1,1),(0,0)'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3Box unit!

testByteArrayConversion	| result bytes |		client execute: 'DROP TABLE IF EXISTS testBytea'.	client execute: 'CREATE TABLE testBytea (id int, bytes bytea)'.		bytes := #[ 0 1 2 3 4 254 255 ].		client execute: ('INSERT INTO testBytea (id, bytes) VALUES (100, <1p>)' << ( '\x', bytes hex )).	"Read the bytes back as a hex string"	result := client query: 'SELECT encode(bytes, ''hex'') FROM testBytea WHERE id = 100'.	self assert: result firstRecord first asLowercase equals: bytes hex asLowercase.	"Read the bytes back as binary data"		result := client query: 'SELECT bytes FROM testBytea WHERE id = 100'.	self assert: result firstRecord first equals: bytes.	client execute: 'DROP TABLE testBytea'!

testChronology	| result now timeNow |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id SERIAL PRIMARY KEY, name TEXT, timestamp_created TIMESTAMP, date_created DATE, time_created TIME)'.	client execute: 'INSERT INTO table1 (name, timestamp_created, date_created, time_created) VALUES (<1p>,<2p>,<3p>,<4p>);' << { 'Chronology'. DateAndTime now printString allButFirst. Date today printStringFormat: 'yyyy-MM-dd'. Time now printStringFormat: 'HH:mm:ss'}.	result := client query: 'SELECT id, name, timestamp_created, date_created, time_created FROM table1 WHERE id = 1'.	self assert: result firstRecord first equals: 1.	self assert: result firstRecord second equals: 'Chronology'.	now := DateAndTime now.	self assert: (now - result firstRecord third) abs < 30 seconds.	self assert: now asDate equals: result firstRecord fourth.
	timeNow := now asTime.	self assert: (timeNow asSeconds - result firstRecord fifth asSeconds) abs < 30.	client execute: ('INSERT INTO table1 (name, timestamp_created, date_created, time_created) VALUES (<1p>,<2p>,<3p>,<4p>)'		<< { 'Pharo'. now printString. now asDate printString. timeNow printString}).	result := client query: 'SELECT id, name, timestamp_created, date_created, time_created FROM table1 WHERE id = 2'.	self assert: result firstRecord first equals: 2.	self assert: result firstRecord second equals: 'Pharo'.	self assert: (now - result firstRecord third) abs < 30 seconds.	self assert: now asDate equals: result firstRecord fourth.	self assert: (timeNow asSeconds - result firstRecord fifth asSeconds) abs < 30.	client execute: 'DROP TABLE table1'!

testChronologyWithTimezone	| result now timeNow |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id SERIAL PRIMARY KEY, name TEXT, timestamp_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, date_created DATE DEFAULT CURRENT_DATE, time_created TIME WITH TIME ZONE DEFAULT CURRENT_TIME)'.	client execute: 'INSERT INTO table1 (name) VALUES (''Chronology'')'.	result := client query: 'SELECT id, name, timestamp_created, date_created, time_created FROM table1 WHERE id = 1'.	self assert: result firstRecord first equals: 1.	self assert: result firstRecord second equals: 'Chronology'.	now := DateAndTime now asUTC.	now := now offset: client utcOffset.	self assert: (now - result firstRecord third) abs < 30 seconds.	self assert: now asDate equals: result firstRecord fourth.
	timeNow := Time fromSeconds: now seconds.
	self assert: (timeNow asSeconds - result firstRecord fifth asSeconds) abs < 30.
	client execute: ('INSERT INTO table1 (name, timestamp_created, date_created, time_created) VALUES (<1p>,<2p>,<3p>,<4p>)'
		<< { 'Pharo'. now printString. now asDate printString. timeNow printString}).
	result := client query: 'SELECT id, name, timestamp_created, date_created, time_created FROM table1 WHERE id = 2'.
	self assert: result firstRecord first equals: 2.
	self assert: result firstRecord second equals: 'Pharo'.
	self assert: (now - result firstRecord third) abs < 30 seconds.
	self assert: now asDate equals: result firstRecord fourth.
	self assert: (timeNow asSeconds - result firstRecord fifth asSeconds) abs < 30.
	client execute: 'DROP TABLE table1'!

testCircleConversion	| result |	(client isServerVersionAtLeastMajor: 9 minor: 4) ifFalse: [ ^ self skip ].	result := client query: 'SELECT circle ''<(1,2),100>'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Circle center: (P3Point x: 1 y: 2) radius: 100).	result := client query: 'SELECT circle ''<(0,0),1>'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3Circle unit.	result := client query: 'SELECT circle ''<(1.5,-1.5),20.5>'''.	self assert: (result firstFieldOfFirstRecord center x closeTo: 1.5).	self assert: (result firstFieldOfFirstRecord center y closeTo: -1.5).	self assert: (result firstFieldOfFirstRecord radius closeTo: 20.5).!

testConnection	self assert: client isConnected.	self assert: client isWorking.!

testConstraints	| statement constraints constraint |	client execute: 'DROP TABLE IF EXISTS orders'.	client execute: 'DROP TABLE IF EXISTS suppliers'.	client execute: 'CREATE TABLE suppliers (id INTEGER, name TEXT)'.	client execute: 'CREATE TABLE orders (id INTEGER, description TEXT, supplier_id INTEGER)'.	client execute: 'ALTER TABLE suppliers ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id)'.	client execute: 'ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id)'.	client execute: 'ALTER TABLE orders ADD CONSTRAINT orders_suppliers_fkey FOREIGN KEY (supplier_id) REFERENCES suppliers (id)'.	statement := client format: 'INSERT INTO suppliers (id, name) VALUES ($1, $2)'.	statement executeBatch: #((1 'Foo')(2 'Bar')).	statement := client format: 'INSERT INTO orders (id, description, supplier_id) VALUES ($1, $2, $3)'.	statement executeBatch: #((1 'AAA' 1)(2 'BBB' 1)(3 'CCC' 2)).		constraints := P3Constraint allForTable: 'suppliers' in: 'public' using: client.	constraint := constraints 		detect: [ :each | each constraintName = 'suppliers_pkey' ] 		ifNone: [ self fail ].	self assert: constraint isPrimaryKey.	self assert: constraint tableName equals: 'suppliers'.	self assert: constraint constraintColumns equals: #(id).	constraints := P3Constraint allForTable: 'orders' in: 'public' using: client.		constraint := constraints 		detect: [ :each | each constraintName = 'orders_pkey' ] 		ifNone: [ self fail ].	self assert: constraint isPrimaryKey.	self assert: constraint tableName equals: 'orders'.	self assert: constraint constraintColumns equals: #(id).	constraint := constraints 		detect: [ :each | each constraintName = 'orders_suppliers_fkey' ] 		ifNone: [ self fail ].	self assert: constraint isForeignKey.	self assert: constraint tableName equals: 'orders'.	self assert: constraint constraintColumns equals: #(supplier_id).	self assert: constraint foreignKeyTable equals: 'suppliers'.	self assert: constraint foreignKeyColumns equals: #(id).	constraints := P3Constraint referencingConstraintNamesForTable: 'suppliers' in: 'public' using: client.	self assert: constraints equals: #(('orders' 'orders_suppliers_fkey')).	client execute: 'DROP TABLE orders'.	client execute: 'DROP TABLE suppliers'!

testConvenienceMetaAccess	self deny: client listDatabases isEmpty.	self assert: (client listSchemas includes: 'public').	self assert: ((client listTablesInSchema: 'public') isKindOf: Collection).!

testCustomCompositeType	| result oid |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'DROP TYPE IF EXISTS money_with_currency'.	client execute: 'CREATE TYPE money_with_currency AS (currency_code CHAR(3), amount NUMERIC(20,8))'.	"Our custom composite type will result in a new type oid that must be mapped, here simply to a string, before it can be used."	oid := (client query: 'SELECT oid FROM pg_type WHERE typname = ''money_with_currency''') firstFieldOfFirstRecord.	client converter mapOid: oid type: #money_with_currency to: #convertStringFrom:length:description:.	client execute: 'CREATE TABLE table1 (id INTEGER, value money_with_currency)'.	client execute: 'INSERT INTO table1 (id, value) VALUES (1, ROW(''EUR'', 199.95))'.	client execute: 'INSERT INTO table1 (id, value) VALUES (2, ROW(''EUR'', 99.99))'.	result := client query: 'SELECT id, value FROM table1 WHERE id = 1'.	self assert: result firstRecord equals: #(1 '(EUR,199.95000000)').	result := client query: 'SELECT id, value FROM table1 WHERE id = 2'.	self assert: result firstRecord equals: #(2 '(EUR,99.99000000)').	client execute: 'DROP TABLE table1'.	client execute: 'DROP TYPE money_with_currency'!

testEmptyString	| result |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id INTEGER, string VARCHAR)'.	client execute: 'INSERT INTO table1 (id, string) VALUES (1, '''')'.	result := client query: 'SELECT id, string FROM table1 WHERE id = 1'.	self assert: result firstRecord equals: #(1 '').	client execute: 'INSERT INTO table1 (id, string) VALUES (2, NULL)'.	result := client query: 'SELECT id, string FROM table1 WHERE id = 2'.	self assert: result firstRecord equals: #(2 nil).	client execute: 'DROP TABLE table1'!

testEnum	| result |	result := client 		execute: 'DROP TABLE IF EXISTS table1;';		execute: 'DROP TYPE IF EXISTS mood';		execute: 'CREATE TYPE mood AS ENUM (''sad'', ''ok'', ''happy'');';		execute: 'CREATE TABLE table1 (name text, current_mood mood );';		execute: 'INSERT INTO table1 VALUES (''Moe'', ''happy'');'.					result := client loadEnums.		self assert: (result includes: #mood).			result := client query: 'SELECT * FROM table1 WHERE current_mood = ''happy'';'.			self assert: result firstRecord equals: #('Moe' #happy)		!

testError	self should: [ client query: 'SELECT * FROM abcdef' ] raise: P3Error!

testIntegerConversion	| result |	result := client query: 'SELECT i::integer FROM (VALUES (-1), (1), (NULL), (1234567890)) t(i)'.	self assert: result data equals: #((-1) (1) (nil) (1234567890))!

testIntegerVector	| result statement |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id INTEGER, v oidvector)'.	client execute:		'INSERT INTO table1 (id, v) VALUES (1, ''0 1 2 3 4 5 67890 1234567'')'.	result := client query: 'SELECT id, v FROM table1 WHERE id = 1'.	self		assert: result firstRecord		equals: #( 1 #( 0 1 2 3 4 5 67890 1234567 ) ).	"statement := client prepare:		             'INSERT INTO table1 (id, v) VALUES ($1, $2)'.	statement execute: { 			1.			#( 77 1974 1945 ) }.				result := client query: 'SELECT id, v FROM table1 WHERE id = 2'.	self assert: result firstRecord equals: { 			2.			#( 77 1974 1945 ) }."	client execute: 'DROP TABLE table1'!

testIntervalConversion	| result |	result := client query: 'SELECT INTERVAL ''1 years 1 mons 1 days 1 hours 1 minutes 1 seconds'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Interval years: 1 months: 1 days: 1 hours: 1 minutes: 1 seconds: 1).	result := client query: 'SELECT INTERVAL ''0 seconds'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Interval zero).	result := client query: 'SELECT INTERVAL ''1 years 2 mons 3 days 0 hours 0 minutes 0 seconds'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Interval years: 1 months: 2 days: 3 hours: 0 minutes: 0 seconds: 0).	result := client query: 'SELECT INTERVAL ''1 hours 2 minutes 3 seconds'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Interval years: 0 months: 0 days: 0 hours: 1 minutes: 2 seconds: 3).	result := client query: 'SELECT INTERVAL ''1 years 1 mons 1 days 1 hours 1 minutes 1 seconds ago'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Interval years: -1 months: -1 days: -1 hours: -1 minutes: 1 seconds: 1).!

testLineConversion	| result |	(client isServerVersionAtLeastMajor: 9 minor: 4) ifFalse: [ ^ self skip ].	result := client query: 'SELECT line''{1,2,3}'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Line a: 1 b: 2 c: 3).	result := client query: 'SELECT line''{0,1,0}'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3Line xAxis.	result := client query: 'SELECT line''{1,0,0}'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3Line yAxis.!

testLineSegmentConversion	| result |	result := client query: 'SELECT lseg ''(1,2),(3,4)'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3LineSegment start: (P3Point x: 1 y: 2) stop: (P3Point x: 3 y: 4)).	result := client query: 'SELECT lseg ''(0,0),(1,0)'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3LineSegment xAxisUnit.	result := client query: 'SELECT lseg ''(0,0),(0,1)'''.	self 		assert: result firstFieldOfFirstRecord 		equals: P3LineSegment yAxisUnit !

testMultipleCommandsInOneRequest	| result |	result := client query: 'SELECT 100'.	self assert: result firstFieldOfFirstRecord equals: 100.	self assert: result results equals: 'SELECT 1'.	self assert: result firstResult equals: 'SELECT 1'.	result := client query: 'SELECT 100; SELECT 200'.	self assert: result firstFieldOfFirstRecord equals: 200.	self assert: result results equals: #('SELECT 1' 'SELECT 1').	self assert: result lastResult equals: 'SELECT 1'.	result := client query: 'SELECT 10; SELECT 20; SELECT 30'.	self assert: result firstFieldOfFirstRecord equals: 30.	self assert: result results equals: #('SELECT 1' 'SELECT 1' 'SELECT 1').	self assert: result lastResult equals: 'SELECT 1'!

testMultiStatement	| result |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id INTEGER, name TEXT, enabled BOOLEAN)'.	result := client query: 'INSERT INTO table1 (id, name, enabled) VALUES (1, ''foo'', true); INSERT INTO table1 (id, name, enabled) VALUES (2, ''bar'', false)'.	self assert: result results equals: #('INSERT 0 1' 'INSERT 0 1').	self deny: result hasDescriptions.	self deny: result hasData.	result := client query: 'SELECT * from table1'.	self assert: result firstResult equals: 'SELECT 2'.	self assert: result firstRowCount equals: 2.	self assert: result data equals: #((1 'foo' true)(2 'bar' false)).	client execute: 'DROP TABLE table1'!

testNonAsciiStrings	| result |
	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id INTEGER, string VARCHAR)'.	client execute: 'INSERT INTO table1 (id, string) VALUES (1, ''Les élèves Français'')'.	result := client query: 'SELECT id, string FROM table1 WHERE id = 1'.	self assert: result firstRecord equals: #(1 'Les élèves Français').	client execute: 'INSERT INTO table1 (id, string) VALUES (2, ''100 €'')'.	result := client query: 'SELECT id, string FROM table1 WHERE id = 2'.	self assert: result firstRecord equals: #(2 '100 €').	client execute: 'DROP TABLE table1'!

testNotification	| raised |	raised := false.	[ client query: 'SET client_min_messages TO notice; DROP TABLE IF EXISTS abcdef' ] 		on: P3Notification 		do: [ :notification | 			raised := true.			self 				assert: ('*abcdef*' match: notification description )				description: ('<1s> does not contain abcdef' << notification description).			notification resume ].	self assert: raised description: 'no notification triggered'!

testPathConversion	| result |	result := client query: 'SELECT path ''((1,2),(3,4),(5,6))'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Path points: { P3Point x: 1 y: 2. P3Point x: 3 y: 4. P3Point x: 5 y: 6 }).	self assert: result firstFieldOfFirstRecord isClosed.	result := client query: 'SELECT path ''[(1,2),(3,4),(5,6)]'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Path openPoints: { P3Point x: 1 y: 2. P3Point x: 3 y: 4. P3Point x: 5 y: 6 }).	self assert: result firstFieldOfFirstRecord isOpen.!

testPointConversion	| result |	result := client query: 'SELECT point (1,2)'.	self assert: result firstFieldOfFirstRecord equals: (P3Point x: 1 y: 2).	result := client query: 'SELECT point (0,0)'.	self assert: result firstFieldOfFirstRecord equals: P3Point zero.	result := client query: 'SELECT point (1,1)'.	self assert: result firstFieldOfFirstRecord equals: P3Point unit.	result := client query: 'SELECT point (1.3,-1.5)'.	self assert: (result firstFieldOfFirstRecord x closeTo: 1.3).	self assert: (result firstFieldOfFirstRecord y closeTo: -1.5).!

testPolygonConversion	| result |	result := client query: 'SELECT polygon ''((1,2),(3,4),(5,6))'''.	self 		assert: result firstFieldOfFirstRecord 		equals: (P3Polygon points: { P3Point x: 1 y: 2. P3Point x: 3 y: 4. P3Point x: 5 y: 6 })!

testQueryCatalog	| result |	result := client query: 'SELECT schemaname,tablename FROM pg_catalog.pg_tables'.	"there are two columns"	self assert: result numberOfColumns equals: 2.	"this was a select"	self assert: ($ split: result firstResult) first equals: 'SELECT'.	"the select returned a count for the number of dataRows"	self assert: result rowCount equals: result numberOfRecords.	"each dataRow has two fields"	self assert: (result data allSatisfy: [ :each | each size = 2])!

testSession	| session |		session := client session. "from #setUp"		self assert: client session notNil.		client execute: 'SELECT NOW();'.		self assert: session equals: client session.		client close.		self assert: client session isNil.		client connect.		self deny: session = client session.		client clearSession.		self 		deny: client isConnected;		assert: client session isNil.						!

testSimpleTable	| result |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id INTEGER, name TEXT, enabled BOOLEAN)'.	client execute: 'INSERT INTO table1 (id, name, enabled) VALUES (1, ''foo'', true)'.	client execute: 'INSERT INTO table1 (id, name, enabled) VALUES (2, ''bar'', false)'.	client execute: 'INSERT INTO table1 (id, name, enabled) VALUES (NULL, NULL, NULL)'.	result := client query: 'SELECT id, name, enabled FROM table1 WHERE id = 1'.	self assert: result firstRecord equals: #(1 'foo' true).	result := client query: 'SELECT id, name, enabled FROM table1 WHERE id = 2'.	self assert: result firstRecord equals: #(2 'bar' false).	result := client query: 'SELECT id, name, enabled FROM table1 WHERE id IS NULL'.	self assert: result firstRecord equals: #(nil nil nil).	client execute: 'DELETE FROM table1 WHERE id IS NULL'.	client execute: 'UPDATE table1 SET name = ''xxx'' WHERE id = 2'.	result := client query: 'SELECT id, name, enabled FROM table1 WHERE id = 2'.	self assert: result firstRecord equals: #(2 'xxx' false).	client execute: 'DROP TABLE table1'!

testSqlFunction	| x y result |	client execute: 'DROP FUNCTION IF EXISTS my_add(x INTEGER, y INTEGER)'.	client execute: 'CREATE FUNCTION my_add(x INTEGER, y INTEGER) RETURNS INTEGER AS $$ SELECT x + y $$ LANGUAGE SQL'.	x := (Random new next * 99) asInteger.	y := (Random new next * 99) asInteger.	result := client query: ('SELECT my_add(<1d>,<2d>) AS answer' << { x. y }).	self assert: result firstFieldOfFirstRecord equals: x + y.	client execute: 'DROP FUNCTION my_add(x INTEGER, y INTEGER)'.!

testStringEscaping	| result string |	client execute: 'DROP TABLE IF EXISTS table1'.	client execute: 'CREATE TABLE table1 (id INTEGER, string VARCHAR)'.	string := 'An SQL string with a single quote '' and a double quote ".'.	"We can use #printString as Pharo strings are similar to SQL string"	client execute: ('INSERT INTO table1 (id, string) VALUES (<1d>, <2p>)' << {1. string }).	result := client query: 'SELECT id, string FROM table1 WHERE id = 1'.	self assert: result firstRecord equals: { 1. string }.	client execute: 'DROP TABLE table1'!

testUuid	| result uuid num |		client execute: 'DROP TABLE IF EXISTS testUUID'.	client execute: 'CREATE TABLE testUUID (id UUID, num INTEGER)'.		uuid := GUID new.	num := (Random new next * 1234) asInteger.		client execute: ('INSERT INTO testUUID (id, num) VALUES (''<1d>'', <2d>)' << { uuid. num }).	result := client query: ('SELECT * FROM testUUID WHERE id = ''<1d>''' << uuid).		self assert: result firstRecord equals: { uuid. num }.		client execute: 'DROP TABLE testUUID'!

testValuesArray1	| statement result |	client execute: 'DROP TABLE IF EXISTS table_a'.	client execute: 'CREATE TABLE table_a (id INTEGER, name TEXT, text_a TEXT[], int_a INTEGER[])'.	statement := client format: 'INSERT INTO table_a (id, name, text_a, int_a) VALUES ($1, $2, $3, $4)'.	statement execute: { 1. 'foo'. #('foo' 'bar'). #(1 2) }.	statement execute: { 2. 'null'. #('NULL' nil). #(0 nil) }.	statement execute: { 3. 'zero'. #(). #() }.	statement execute: { 4. 'escape'. #('a"b' 'c\d'). #(1 2) }.	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 1'.	self assert: result firstRecord equals: #(1 'foo' #('foo' 'bar') #(1 2)).	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 2'.	self assert: result firstRecord equals: #(2 'null' #('NULL' nil) #(0 nil)).	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 3'.	self assert: result firstRecord equals: #(3 'zero' #() #()).	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 4'.	self assert: result firstRecord equals: #(4 'escape' #('a"b' 'c\d') #(1 2)).	client execute: 'DROP TABLE table_a'!

testValuesArray2	| statement result |	client execute: 'DROP TABLE IF EXISTS table_a'.	client execute: 'CREATE TABLE table_a (id INTEGER, name TEXT, text_a TEXT[], int_a INTEGER[])'.	statement := client prepare: 'INSERT INTO table_a (id, name, text_a, int_a) VALUES ($1, $2, $3, $4)'.	statement execute: { 1. 'foo'. #('foo' 'bar'). #(1 2) }.	"statement execute: { 2. 'null'. P3ValuesArray withAll: #('NULL' nil). P3ValuesArray withAll: #(0 nil) }."	statement execute: { 3. 'zero'. #(). #() }.	"statement execute: { 4. 'escape'. P3ValuesArray withAll: #('a""""b' 'c\d'). P3ValuesArray withAll: #(1 2) }."	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 1'.	self assert: result firstRecord equals: #(1 'foo' #('foo' 'bar') #(1 2)).	"result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 2'.	self assert: result firstRecord equals: #(2 'null' #('NULL' nil) #(0 nil))."	result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 3'.	self assert: result firstRecord equals: #(3 'zero' #() #()).	"result := client query: 'SELECT id, name, text_a, int_a FROM table_a WHERE id = 4'.	self assert: result firstRecord equals: #(4 'escape' #('a""b' 'c\d') #(1 2))."	client execute: 'DROP TABLE table_a'! !

!P3ClientTest categoriesForMethods!
benchmark1Size!benchmarking!public! !
runAllTests!benchmarking!public! !
runBenchmark1!benchmarking!public! !
runBenchmark1Bench!benchmarking!public! !
setUp!public!running! !
setupBenchmark1!benchmarking!public! !
tearDown!public!running! !
testArrayTypes!public!tests! !
testBitStringConversion!public!tests! !
testBooleanConversion!public!tests! !
testBoxConversion!public!tests! !
testByteArrayConversion!public!tests! !
testChronology!public!tests! !
testChronologyWithTimezone!public!tests! !
testCircleConversion!public!tests! !
testConnection!public!tests! !
testConstraints!public!tests! !
testConvenienceMetaAccess!public!tests! !
testCustomCompositeType!public!tests! !
testEmptyString!public!tests! !
testEnum!public!tests! !
testError!public!tests! !
testIntegerConversion!public!tests! !
testIntegerVector!public!tests! !
testIntervalConversion!public!tests! !
testLineConversion!public!tests! !
testLineSegmentConversion!public!tests! !
testMultipleCommandsInOneRequest!public!tests! !
testMultiStatement!public!tests! !
testNonAsciiStrings!public!tests! !
testNotification!public!tests! !
testPathConversion!public!tests! !
testPointConversion!public!tests! !
testPolygonConversion!public!tests! !
testQueryCatalog!public!tests! !
testSession!public!tests! !
testSimpleTable!public!tests! !
testSqlFunction!public!tests! !
testStringEscaping!public!tests! !
testUuid!public!tests! !
testValuesArray1!public!tests! !
testValuesArray2!public!tests! !
!

!P3ClientTest class methodsFor!

url	"Return the default connection URL to use for P3 clients in the unit tests.	Note that the coded default here corresponds to the GitHub Action CI's postgresql service:	user postgres with password postgres, host postgres, port 5432 and databasse postgres. 	You should set an appropriate connection string yourself, see #url:"		^ Url ifNil: [ Url := 'psql://postgres:postgres@postgres:5432/postgres' ]!

url: stringOrUrl	"Set the connection URL to be used for P3 Clients in the unit tests.	The general syntax is psql://sven:secret@localhost:5432/database	The minimal form is psql://user@localhost (a user, blank password, localhost)"		Url := stringOrUrl asUrl! !

!P3ClientTest class categoriesForMethods!
url!accessing!public! !
url:!accessing!public! !
!

