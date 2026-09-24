"Filed out from Dolphin Smalltalk"!

Object subclass: #P3Result
	instanceVariableNames: 'results descriptions data source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

P3Result guid: (GUID fromString: '{1a8b1816-7e15-459f-a2f2-3eca7ce1e716}')!

P3Result comment: 'I am P3Result, I encapsulate the result from a PostgreSQL query.I hold 4 things:- results -  the command completion tags, a String (singular if there was only one query) or a collection of Strings (if there were multiple queries) in the form of ''SELECT 100''- descriptions - a collection of P3RowFieldDescription objects (one for each column, nil if there is no data)- data - a collection of records with each field value converted to objects, nil if there is no data- source - the SQL source string that generated me, nil if unavailableEven if there are multiple queries, there can only be one stream of records. Most of the time, results is singular.In the case of multiple queries, there will be multiple results (an array of results), one for each query. However, only the last record stream will be in the data and descriptions.'!

!P3Result categoriesForClass!P3-Core! !

!P3Result methodsFor!

addResult: subResult	results := results		ifNil: [ subResult ]		ifNotNil: [ results isString				ifTrue: [ Array with: results with: subResult ]				ifFalse: [ results copyWith: subResult ] ]!

columnNames	"Return the names of the columns of the data that I hold"		^ descriptions collect: #fieldName!

columns	"Return the P3RowFieldDescriptions of the columns of the data that I hold"	^ descriptions!

data	"Return the data that I represent, 	an Array containing equal sized Arrays for each record in the result"		^ data!

data: collection	data := collection!

descriptions	"Return the P3RowFieldDescriptions of the result that I represent.	There will be one such description for each column."		^ descriptions!

descriptions: collectionOfRowFieldDescriptions	descriptions := collectionOfRowFieldDescriptions!

firstColumnData	"Return a flat collection of the data in the first column that I hold"		^ data collect: [ :each | each first]!

firstFieldOfFirstRecord	"Return the value of the first field of the first record that I hold"		^ self firstRecord first!

firstRecord	"Return the first record of the result, which will be an Array"		^ self records first!

firstResult	"Return the SQL query execution result, or the first one if there are multiple results.	Among other things, the result indicates how many rows were returned or modified."		^ results isString ifTrue: [ results ] ifFalse: [ results first ]!

firstRowCount	"Return the row count for the first result that I hold.	This is the integer count of the the number of records returned or modified"		^ self rowCountFromCommandResultTag: self firstResult!

hasData	^ data notNil!

hasDescriptions	^ descriptions notNil!

hasResults	^ results notNil!

hasSource	^ source notNil!

lastResult	"Return the SQL query execution result, or the last one if there are multiple results.	Among other things, the result indicates how many rows were returned or modified."		^ results isString ifTrue: [ results ] ifFalse: [ results last ]!

numberOfColumns	"Return the number of columns that I hold.	Each record in my data will be of this size."		^ self hasDescriptions ifTrue: [ self descriptions size ] ifFalse: [ 0 ]!

numberOfRecords	"Return the actual number of records that are in the data that I hold.	In principle this equals #rowCount"		^ self hasData ifTrue: [ self data size ] ifFalse: [ 0 ]!

printInfoOn: stream	self hasResults		ifTrue: [ 			results isString				ifTrue: [ stream nextPutAll: results ]				ifFalse: [ 					results 						do: [ :each | stream nextPutAll: each ]						separatedBy: [ stream << ', ' ] ] ].	(self hasData and: [ self data notEmpty ])		ifTrue: [ 			stream				<< ', ';				print: self numberOfRecords;				<< ' record(s)';				<< ', ';				print: self numberOfColumns;				<< ' column(s)' ]!

printOn: stream	super printOn: stream.	stream nextPut: $(.	self printInfoOn: stream.	stream nextPut: $)!

records	"Return the records that I hold, also known as my data"		^ data!

recordsAsDictionaries	"Return the data that I hold as a collection where each record 	is represented by a Dictionary whose keys are the column names.	This more verbose representation can be more user friendly."		^ self records collect: [ :record |		| dictionary |		dictionary := Dictionary new.		self descriptions keysAndValuesDo: [ :index :description |			dictionary at: description fieldName asSymbol put: (record at: index) ].		dictionary ]!

result	"Return the result.	As this is the most common case, we assume a single result."		^ self firstResult!

results	"Return the SQL query execution results, possibly a collection.	Among other things, the results indicates how many rows were returned or modified."	^ results!

results: stringOrCollectionOfStrings	results := stringOrCollectionOfStrings!

rowCount	"Return the integer count of the number of records returned or modified.	If there is data, this equals #numberOfRecords"		^ self firstRowCount!

rowCountFromCommandResultTag: string
	| count stream |

	count := 0.
	stream := string readStream.
	[stream skipWhile: [ :char | char isDigit not]; atEnd] whileFalse: [count := Integer readFrom: stream].
	^count!

rows	"Return the rows that I hold, also known as my data"		^ data!

source	"Return the SQL source that generated me (if available)"		^ source!

source: sqlString	source := sqlString!

totalRowCount	"Return the total integer count of the number of record returned or modified in all results"	results ifNil: [ ^ 0 ].	^ results isString		ifTrue: [ 			self firstRowCount ]		ifFalse: [ 			results 				inject: 0 				into: [ :sum :next | sum + (self rowCountFromCommandResultTag: next) ] ]! !

!P3Result categoriesForMethods!
addResult:!private/accessing!public! !
columnNames!convenience!public! !
columns!convenience!public! !
data!accessing!public! !
data:!private/accessing!public! !
descriptions!accessing!public! !
descriptions:!private/accessing!public! !
firstColumnData!convenience!public! !
firstFieldOfFirstRecord!convenience!public! !
firstRecord!accessing!public! !
firstResult!accessing!public! !
firstRowCount!accessing!public! !
hasData!public!testing! !
hasDescriptions!public!testing! !
hasResults!public!testing! !
hasSource!public!testing! !
lastResult!accessing!public! !
numberOfColumns!accessing!public! !
numberOfRecords!accessing!public! !
printInfoOn:!printing!public! !
printOn:!printing!public! !
records!convenience!public! !
recordsAsDictionaries!convenience!public! !
result!accessing!public! !
results!accessing!public! !
results:!private/accessing!public! !
rowCount!accessing!public! !
rowCountFromCommandResultTag:!private! !
rows!convenience!public! !
source!accessing!public! !
source:!accessing!public! !
totalRowCount!accessing!public! !
!

!P3Result class methodsFor!

descriptions: descriptions data: aRowArray results: aString	^ self new		descriptions: descriptions;		data: aRowArray;		results: aString;		yourself! !

!P3Result class categoriesForMethods!
descriptions:data:results:!instance creation!public! !
!

