Extension { #name : #CharacterTest }

{ #category : #'*PUGizmo' }
CharacterTest >> test_decode6bit [

	self assert: $0 _decode6bit equals: 0.
	self assert: $9 _decode6bit equals: 9.
	self assert: $A _decode6bit equals: 10.
	self assert: $Z _decode6bit equals: 35.
	self assert: $a _decode6bit equals: 36.
	self assert: $z _decode6bit equals: 61.
	self assert: $- _decode6bit equals: 62.
	self assert: $_ _decode6bit equals: 63.
	
]
