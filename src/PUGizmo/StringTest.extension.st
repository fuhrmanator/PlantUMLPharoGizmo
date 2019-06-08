Extension { #name : #StringTest }

{ #category : #'*PUGizmo' }
StringTest >> sourceFromLocalhost: key [
	"Use a localhost PlantUML server to get back the source from a key (to test key's validity)"
	| response content re |
	response := ZnClient new
		url: 'http://localhost:8080/plantuml/uml/' , key;
		get;
		response.
	content := response contents.
	re := '[\w\W]*<textarea id="text" name="text" cols="120" rows="10">(.*)</textarea>'
		asRegexIgnoringCase.
	re matchesPrefix: content.
	^ (re subexpression: 2) asUnescapedHTMLString
]

{ #category : #'*PUGizmo' }
StringTest >> testAsUnescapedHTMLString [
	self
		assert:
			'class behavior1 as &#034;TLCOMMetrics&#034; &lt;&lt; (T,orchid) &gt;&gt;'
				asUnescapedHTMLString
		equals: 'class behavior1 as "TLCOMMetrics" << (T,orchid) >>'.
	self
		assert:
			'&#039; this is a comment'
				asUnescapedHTMLString
		equals: ''' this is a comment'.		
]

{ #category : #'*PUGizmo' }
StringTest >> testPkzippedPkunzipped [
	| zippedString |
	"PlantUML ignores the header and CRC"
	zippedString := 'Here is some text' pkzipped.
	self assert: (zippedString copyFrom: 3 to: zippedString size -4) pkunzipped equals: 'Here is some text'.
]

{ #category : #'*PUGizmo' }
StringTest >> testPlantDeflateAndEncode [

	self assert: 'A->B:Âllo?' plantDeflateAndEncode equals: 'SzIrSx8wt9IJasyF0000'.
]

{ #category : #'*PUGizmo' }
StringTest >> testPlantTextMindMap [
	| source |

	source := Character cr
		join:
			#('@startmindmap' '* Debian' '** Ubuntu' '*** Linux Mint' '*** Kubuntu' '*** Lubuntu' '*** KDE Neon' '** LMDE' '** SolydXK' '** SteamOS' '** Raspbian with a very long name' '*** <s>Raspmbc</s> => OSMC' '*** <s>Raspyfi</s> => Volumio' '@endmindmap').
	self assert: source asPlantUMLKey asPlantUMLSource equals: source.

]

{ #category : #'*PUGizmo' }
StringTest >> testPlantTextPlantUMLLocalhost [
	| source recoveredSource |
	source := '/mnt/c/tmp/plantuml_sample1.puml' asFileReference readStream upToEnd.
	"Use the plantuml/uml endpoint to get the source back from the key"
	recoveredSource := self sourceFromLocalhost: source asPlantUMLKey.
	self assert: source asCRfromLF equals: recoveredSource asCRfromLF
]

{ #category : #'*PUGizmo' }
StringTest >> testPlantTextPlantUMLLocalhostRandom [
	| source recoveredSource |
	source := '@startuml' , String cr , (String randomOfSize: 410)
		, String cr , (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr
		, (String randomOfSize: 410) , String cr , '@enduml'.
	"Use the plantuml/uml endpoint to get the source back from the key"
	recoveredSource := self sourceFromLocalhost: source asPlantUMLKey.
	self assert: source equals: recoveredSource asCRfromLF
]

{ #category : #'*PUGizmo' }
StringTest >> testPlantTextSimpleSource [
	| source encodedUTF8 zlibString compressedString |

	source := 'a->b'.
	self assert: source asPlantUMLKey equals: 'IzIrIm80'.
	encodedUTF8 := source convertToSystemString.
	self assert: encodedUTF8 asHexNoRadical2 asLowercase  asSpacedForDiffString equals: '612d3e62' asSpacedForDiffString.	
	zlibString := encodedUTF8  pkzipped.
	self assert: zlibString asHexNoRadical2 asLowercase asSpacedForDiffString equals: '789c4bd4b54b020002ed012f' asSpacedForDiffString.
	compressedString := zlibString copyFrom: 3 to: zlibString size -4.
	self assert: compressedString asHexNoRadical2 asLowercase asSpacedForDiffString equals: '4bd4b54b0200' asSpacedForDiffString.

]

{ #category : #'*PUGizmo' }
StringTest >> testPlantTextVaryingSizesOfRandomText [
	| source |

	"Test with ever increasing string sizes"
	(900 to: 1000 by: 1)
		do: [ :size | 
			source := String randomOfSize: size.
			self assert: source asPlantUMLKey asPlantUMLSource equals: source ]
]

{ #category : #'*PUGizmo' }
StringTest >> testPlantUrlStringToPlantSourceString [

	self assert: 'https://www.plantuml.com/plantuml/img/SzIrSx8wt9IJasyF0000' plantUrlStringToPlantSourceString  equals: 'A->B:Âllo?'.
]

{ #category : #'*PUGizmo' }
StringTest >> test_magicCodeFromURL [
	self
		assert: 'https://www.bblah.com/HereIsTheMagic.png' _magicCodeFromURL
		equals: 'HereIsTheMagic'.
	self
		assert: 'http://www.bblah.com/HereIsTheMagic.jpg' _magicCodeFromURL
		equals: 'HereIsTheMagic'.
	self
		assert: 'http://www.bblah.com/HereIsTheMagic.JPG' _magicCodeFromURL
		equals: 'HereIsTheMagic'
]
