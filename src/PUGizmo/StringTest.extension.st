Extension { #name : #StringTest }

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
StringTest >> testPlantTextRoundTrip [
	| source |
	source := (Character cr join: #('@startmindmap' '* Debian' '** Ubuntu' '*** Linux Mint' '*** Kubuntu' '*** Lubuntu' '*** KDE Neon' '** LMDE' '** SolydXK' '** SteamOS' '** Raspbian with a very long name' '*** <s>Raspmbc</s> => OSMC' '*** <s>Raspyfi</s> => Volumio' '@endmindmap')).
	self assert: source plantDeflateAndEncode plantUrlStringToPlantSourceString equals: source.
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
