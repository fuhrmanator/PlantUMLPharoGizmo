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
	| source encodedUTF8 zlibString compressedString |

	source := '/mnt/c/tmp/plantuml_sample3.puml' asFileReference readStream upToEnd.
	zlibString := source convertToSystemString pkzipped.
	self assert: zlibString asHexNoRadical asSpacedForDiffString equals: '789c85935f4bc33014c5dffb292e7b5141d0aaf30f8cb13215069b3e58f1394d2f6b5c938ce45637c4ef6edac8d66da9e6a9b9f99d939b9c74648919aa641915224740b9a4354894191a1bf192590b1916ec43681303b3d04ba7e3e7d90cc9086e7b3018c0717aaa0d77ea13180ee12bfade935d34b2074582d6bdc0fa65b3fea22bc33151bcd026445db5a82953f38acd31c4f55b5cdebde9b56f6ac57149422b3883743309f1370dffaa164a7faaffbbb86df0c45acd05ebf2bc6ba0b1961215d51dfc7e86d8f8bc819f98fceb5471dc3a7d8a2bf2f7597bbf092a26ce3e77fda007820e3ead24b36418a74751e2d6633b0b4a7d90b3aa24b12c71577a580d5af89413a53435d73651ee79aa8e56fb1d7042ee71661585553ef931abe605ede4bf570a8afd33b84757362e88b6fca0e80da2a3020d82b060b54490da4dc825f3be198bd68846a8f2fa67fc0100343ef3' asUppercase asSpacedForDiffString.

	source := '/mnt/c/tmp/plantuml_sample1.puml' asFileReference readStream upToEnd.
	zlibString := source convertToSystemString pkzipped.
	self assert: zlibString asHexNoRadical asSpacedForDiffString equals: '789c8593df4bc33010c7dffb571c7b5141d0aaf3078cb13215069b3eace2a3a4e9b1c635c948aeba21feef668d6cdd966a9e7a97cff79b4bee3ab0c40c55b28c0a9123a05cd00a24ca0c8d8d78c9ac850c0bf621b4898159e8a4e3e1f364826404b71de8f5e0383dd5863bf509f4fbf0157defc92e6ad9832241ab4e60ffb2de9feaca704c142fb40951570d6accd4ac62330c71dd0697b71f7aed8b5a725c90d00ace20dd0421fea6e65fd45ce94ff57f15b7359e58abb9606d9e776f3535d452a2a27509bf9f21383eafe12726ffba561c37ae9fe292fc83aebd5f051523679fbb82d0034107dfae24b36418a74751e2d6631b05a5be9393aa24b12871577a980d5af836274a69aadf6da4dc7caa9652bb2d70426e3ab38ac22adffa21ab6605ed0cc05e2a28f673708f2e6d5c239af283a437888e0a3408c282d512416a1790ebccfb66cd1b2b1aa0cad77f63f4038ac23f5c' asUppercase asSpacedForDiffString.
	
	compressedString := zlibString copyFrom: 3 to: zlibString size -4.
	self assert: compressedString asHexNoRadical asSpacedForDiffString equals: '8593df4bc33010c7dffb571c7b5141d0aaf3078cb13215069b3eace2a3a4e9b1c635c948aeba21feef668d6cdd966a9e7a97cff79b4bee3ab0c40c55b28c0a9123a05cd00a24ca0c8d8d78c9ac850c0bf621b4898159e8a4e3e1f364826404b71de8f5e0383dd5863bf509f4fbf0157defc92e6ad9832241ab4e60ffb2de9feaca704c142fb40951570d6accd4ac62330c71dd0697b71f7aed8b5a725c90d00ace20dd0421fea6e65fd45ce94ff57f15b7359e58abb9606d9e776f3535d452a2a27509bf9f21383eafe12726ffba561c37ae9fe292fc83aebd5f051523679fbb82d0034107dfae24b36418a74751e2d6631b05a5be9393aa24b12871577a980d5af836274a69aadf6da4dc7caa9652bb2d70426e3ab38ac22adffa21ab6605ed0cc05e2a28f673708f2e6d5c239af283a437888e0a3408c282d512416a1790ebccfb66cd1b2b1aa0cad77f63f403' asUppercase asSpacedForDiffString.
	



	source := 'a->b'.
	encodedUTF8 := source convertToSystemString.
	self assert: encodedUTF8 asHexNoRadical asLowercase asSpacedForDiffString equals: '612d3e62' asSpacedForDiffString.
	
	zlibString := encodedUTF8  pkzipped.
	self assert: zlibString asHexNoRadical asLowercase asSpacedForDiffString equals: '789c4bd4b54b020002ed012f' asSpacedForDiffString.
	compressedString := zlibString copyFrom: 3 to: zlibString size -4.
	self assert: compressedString asHexNoRadical asLowercase asSpacedForDiffString equals: '4bd4b54b0200' asSpacedForDiffString.

	source := '/mnt/c/tmp/920f.txt' asFileReference readStream upToEnd.
	zlibString := source convertToSystemString pkzipped.
	compressedString := zlibString copyFrom: 3 to: zlibString size -4.
	self assert: compressedString asHexNoRadical asLowercase asSpacedForDiffString equals: '4b4b8302aeb451d6286b9435485800' asSpacedForDiffString.

	source := '/mnt/c/tmp/922f.txt' asFileReference readStream upToEnd.
	zlibString := source convertToSystemString pkzipped.
	compressedString := zlibString copyFrom: 3 to: zlibString size -4.
	self assert: compressedString asHexNoRadical asLowercase asSpacedForDiffString equals: '4b4b1b05a360140c3a0000' asSpacedForDiffString.

"921 chars"
	source := '/mnt/c/tmp/921f.txt' asFileReference readStream upToEnd.
	zlibString := source convertToSystemString pkzipped.
	compressedString := zlibString copyFrom: 3 to: zlibString size -4.
	self assert: compressedString asHexNoRadical asLowercase asSpacedForDiffString equals: '4b4b1b05a360140c360000' asSpacedForDiffString.


	self assert: source asPlantUMLKey equals: 'XPFVIyCm4CVV-rSSUr51qAhp1uonCXK6cpwiugEawR76DSb8hheX_kzcZMpTbcgUUfVFzvjBxZgmn0nLiemAaIEWND0A9CeCZOruoQo530ls8RI9WLdefEFXysI2P0It7UZru3WzrOOxzGdq-_0LVU_9BchPWo91gqvW_xBUd-hAS4mKBxG9KLSDQipKh68p377T1fUt7thjYrfoN93G2iuWtGGX_gRcNzHSwK_rVnMtDPvOgxbWRPvtRpKrr5AYedK9lvyXE3wluISc_xfM73Ukd-AI_8EklLy55IDddxk2q0D11z-k9BDa6AT7KUBMOni5fRwJaweaiIXnLtgO3LhuDYTAQQhVRQJSVAgMKhijS49kEhEAmYhV-Y6hPWNj3C1UAYZsSt2FBcrS8vhoWwGtY8uAD0Z2WjKIGMeNaElC-sRD6oiQeChNV-CF'.
	self assert: source asPlantUMLKey asPlantUMLSource equals: source.
	
	source := Character cr
		join:
			#('@startmindmap' '* Debian' '** Ubuntu' '*** Linux Mint' '*** Kubuntu' '*** Lubuntu' '*** KDE Neon' '** LMDE' '** SolydXK' '** SteamOS' '** Raspbian with a very long name' '*** <s>Raspmbc</s> => OSMC' '*** <s>Raspyfi</s> => Volumio' '@endmindmap').
	self assert: source asPlantUMLKey asPlantUMLSource equals: source.
	"Test with ever increasing string sizes"
	(900 to: 1000 by: 1)
		do: [ :size | 
			"(1 to: 100)
				do: [ :i |"
			source := String randomOfSize: size.
			self assert: source asPlantUMLKey asPlantUMLSource equals: source	"]" ]
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
