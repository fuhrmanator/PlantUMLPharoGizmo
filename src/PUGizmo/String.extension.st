Extension { #name : #String }

{ #category : #'*PUGizmo' }
String >> _encode [
	"Ported from https://github.com/dougn/python-plantuml/blob/master/plantuml.py"

	| res i |
	res := ''.
	i := 0.
	[ i < self size ]
		whileTrue: [ i + 2 = self size
				ifTrue: [ res := res
						,
							(self
								_encode3bytes: (self at: i + 1) asInteger
								arg2: (self at: i + 2) asInteger
								arg3: 0) ]
				ifFalse: [ i + 1 = self size
						ifTrue: [ res := res
								,
									(self _encode3bytes: (self at: i + 1) asInteger arg2: 0 arg3: 0) ]
						ifFalse: [ res := res
								,
									(self
										_encode3bytes: (self at: i + 1) asInteger
										arg2: (self at: i + 2) asInteger
										arg3: (self at: i + 3) asInteger) ] ].
			i := i + 3 ].
	^ res
]

{ #category : #'*PUGizmo' }
String >> _encode3bytes: b1 arg2: b2 arg3: b3 [
	"Ported from https://github.com/dougn/python-plantuml/blob/master/plantuml.py"

	| res c1 c2 c3 c4 |
	c1 := b1 >> 2.	"c1 = b1 >> 2;"
	c2 := (b1 bitAnd: 16r3) << 4 bitOr: b2 >> 4.	"c2 = ((b1 & 0x3) << 4) | (b2 >> 4);"
	c3 := (b2 bitAnd: 16rF) << 2 bitOr: b3 >> 6.	"c3 = ((b2 & 0xF) << 2) | (b3 >> 6);"
	c4 := b3 bitAnd: 16r3F.	"c4 = b3 & 0x3F;"
	res := ''.	"res = '';"
	res := res , (self _encode6bit: (c1 bitAnd: 16r3F)).	"res += _encode6bit(c1 & 0x3F);"
	res := res , (self _encode6bit: (c2 bitAnd: 16r3F)).	"res += _encode6bit(c2 & 0x3F);"
	res := res , (self _encode6bit: (c3 bitAnd: 16r3F)).	"res += _encode6bit(c3 & 0x3F);"
	res := res , (self _encode6bit: (c4 bitAnd: 16r3F)).	"res += _encode6bit(c4 & 0x3F);"
	^ res	"return res;"
]

{ #category : #'*PUGizmo' }
String >> _encode6bit: bCopy [
	"Ported from https://github.com/dougn/python-plantuml/blob/master/plantuml.py"
	| b |
	b := bCopy.
	b < 10
		ifTrue: [ ^ (Character value: (48 + b)) asString ].
	b := b - 10.
	b < 26
		ifTrue: [ ^ (Character value: (65 + b)) asString ].
	b := b - 26.
	b < 26
		ifTrue: [ ^ (Character value: (97 + b)) asString ].
	b := b - 26.
	b = 0
		ifTrue: [ ^ '-' ].
	b = 1
		ifTrue: [ ^ '_' ].
	^ $? asString
]

{ #category : #'*PUGizmo' }
String >> pkzipped [
	"Use the ZLibWriteStream to get a DEFLATE function from PKTools"

	| zstream |
	^ String
		streamContents: [ :stream | 
			zstream := ZLibWriteStream on: stream.
			zstream nextPutAll: self.
			zstream close ]
]

{ #category : #'*PUGizmo' }
String >> plantDeflateAndEncode [
	"Ported from https://github.com/dougn/python-plantuml/blob/master/plantuml.py"

	| zlibbedStr compressedString |
	zlibbedStr := self pkzipped.
	compressedString := zlibbedStr copyFrom: 3 to: zlibbedStr size - 4.
	^ compressedString _encode
]
