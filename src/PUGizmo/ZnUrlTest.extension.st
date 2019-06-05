Extension { #name : #ZnUrlTest }

{ #category : #'*PUGizmo' }
ZnUrlTest >> testIsValid [
	self assert: 'https://blahblah.com/ywerwerwwery73483748' asUrl isValid.
	self assert: 'https://blahblah.com/' asUrl isValid.
	self deny: 'kwerjhasdfasdf' asUrl isValid
]
