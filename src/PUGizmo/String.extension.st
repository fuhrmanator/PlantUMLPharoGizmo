Extension { #name : #String }

{ #category : #'*PUGizmo' }
String >> _decode64 [
	"Taken from PlantUML Gizmo code (in Javascript)"
	| i c1 c2 c3 c4 ss |
	i := 0.
	ss := WriteStream on: (String new).
	[ i < self size ]
		whileTrue: [
			c1 := (self at: i+1) _decode6bit. "var c1 = decode6bit(data.substring(i,i+1));"
			c2 := (self at: i+2) _decode6bit. "var c2 = decode6bit(data.substring(i+1,i+2));"
			c3 := (self at: i+3) _decode6bit. "var c3 = decode6bit(data.substring(i+2,i+3));"
			c4 := (self at: i+4) _decode6bit. "var c4 = decode6bit(data.substring(i+3,i+4));"
			ss nextPutAll: (Character value: ((c1 << 2) | (c2 >> 4))) asString. "ss += String.fromCharCode((c1 << 2) | (c2 >> 4));"
			ss nextPutAll: (Character value: (((c2 & 16r0F) << 4) | (c3 >> 2))) asString. "ss += String.fromCharCode(((c2 & 0x0F) << 4) | (c3 >> 2));"
			ss nextPutAll: (Character value: (((c3 & 16r3) << 6) | c4)) asString. "ss += String.fromCharCode(((c3 & 0x3) << 6) | c4);"
			i := i + 4 ].
	^ ss contents
"function decode64(data) {
	 var pos = 0;
	 var ss = "";
	 for (var i=0; i<data.length; i+=4) {
			var c1 = decode6bit(data.substring(i,i+1));
			var c2 = decode6bit(data.substring(i+1,i+2));
			var c3 = decode6bit(data.substring(i+2,i+3));
			var c4 = decode6bit(data.substring(i+3,i+4));
			ss += String.fromCharCode((c1 << 2) | (c2 >> 4));
			ss += String.fromCharCode(((c2 & 0x0F) << 4) | (c3 >> 2));
			ss += String.fromCharCode(((c3 & 0x3) << 6) | c4);
	 }
    ss = escape(zip_inflate(ss));
	 return decodeURIComponent(ss);
}

"
]

{ #category : #'*PUGizmo' }
String >> _decodeURIComponent [
	"Like javascript's encodeURIComponent function"

	^ ZnResourceMetaUtils decodePercent: self
]

{ #category : #'*PUGizmo' }
String >> _encode [
	"Ported from https://github.com/dougn/python-plantuml/blob/master/plantuml.py"

	| res i |
	res := WriteStream on: (String new).
	i := 0.
	[ i < self size ]
		whileTrue: [ i + 2 = self size
				ifTrue: [ res nextPutAll:
							(self
								_encode3bytes: (self at: i + 1) asInteger
								arg2: (self at: i + 2) asInteger
								arg3: 0) ]
				ifFalse: [ i + 1 = self size
						ifTrue: [ res nextPutAll:
									(self _encode3bytes: (self at: i + 1) asInteger arg2: 0 arg3: 0) ]
						ifFalse: [ res nextPutAll:
									(self
										_encode3bytes: (self at: i + 1) asInteger
										arg2: (self at: i + 2) asInteger
										arg3: (self at: i + 3) asInteger) ] ].
			i := i + 3 ].
		res close.
	^ res contents
]

{ #category : #'*PUGizmo' }
String >> _encode3bytes: b1 arg2: b2 arg3: b3 [
	"Ported from https://github.com/dougn/python-plantuml/blob/master/plantuml.py"

	| res c1 c2 c3 c4 |
	c1 := b1 >> 2.	"c1 = b1 >> 2;"
	c2 := (b1 bitAnd: 16r3) << 4 bitOr: b2 >> 4.	"c2 = ((b1 & 0x3) << 4) | (b2 >> 4);"
	c3 := (b2 bitAnd: 16rF) << 2 bitOr: b3 >> 6.	"c3 = ((b2 & 0xF) << 2) | (b3 >> 6);"
	c4 := b3 bitAnd: 16r3F.	"c4 = b3 & 0x3F;"
	res := WriteStream on: (String new).	"res = '';"
	res nextPutAll: (self _encode6bit: (c1 bitAnd: 16r3F)).	"res += _encode6bit(c1 & 0x3F);"
	res nextPutAll: (self _encode6bit: (c2 bitAnd: 16r3F)).	"res += _encode6bit(c2 & 0x3F);"
	res nextPutAll: (self _encode6bit: (c3 bitAnd: 16r3F)).	"res += _encode6bit(c3 & 0x3F);"
	res nextPutAll: (self _encode6bit: (c4 bitAnd: 16r3F)).	"res += _encode6bit(c4 & 0x3F);"
	^ res contents	"return res;"
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
String >> _escape [
	"Like javascript's escape (encodeURI) function"

	^ ZnResourceMetaUtils
		encodePercent: self
		safeSet: #rfc3986SafeSet
		encoder: ZnCharacterEncoder utf8
]

{ #category : #'*PUGizmo' }
String >> _magicCodeFromURL [
	^ (self copyWithRegex: 'http.+/' matchesIgnoringCaseReplacedWith: '')
		copyWithRegex: '(.png|.jpg)'
		matchesIgnoringCaseReplacedWith: ''
]

{ #category : #'*PUGizmo' }
String >> asPlantUMLKey [
	^self plantDeflateAndEncode
]

{ #category : #'*PUGizmo' }
String >> asPlantUMLSource [
	^self plantUrlStringToPlantSourceString.
]

{ #category : #'*PUGizmo' }
String >> copyWithRegex: rxString matchesIgnoringCaseReplacedWith: aString [

	^rxString asRegexIgnoringCase 
		copy: self replacingMatchesWith: aString
]

{ #category : #'*PUGizmo' }
String >> pkunzipped [
	"Use the ZLibReadStream to get a DEFLATE function from PKTools"

	"| magic1 magic2 |
	magic1 := (self at: 1) asInteger.
	magic2 := (self at: 2) asInteger.
	(magic1 = 16r1F and: [ magic2 = 16r8B ])
		ifFalse: [ ^ self ]."
	^ (ZipReadStream on: self) upToEnd
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
	zlibbedStr := self convertToSystemString pkzipped.
	"Remove the compression type and CRC (to save space?)"
	compressedString := zlibbedStr copyFrom: 3 to: zlibbedStr size - 4.
	^ compressedString _encode
	"^ zlibbedStr"
]

{ #category : #'*PUGizmo' }
String >> plantUrlStringToPlantSourceString [
	"Taken from PlantUML Gizmo code (in Javascript)"
	"get only the magic code part"
	| magicCode decoded escaped inflated |
	magicCode := self _magicCodeFromURL.
	decoded := magicCode _decode64.
	inflated := decoded pkunzipped.
	escaped := inflated _escape.
	^ escaped _decodeURIComponent convertFromSystemString
]
