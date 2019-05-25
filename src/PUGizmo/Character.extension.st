Extension { #name : #Character }

{ #category : #'*PUGizmo' }
Character >> _decode6bit [
	"Ported from PlantUML Gizmo's Javascript"

	(self between: $0 and: $9)
		ifTrue: [ ^ self asInteger - 48 ].
	(self between: $A and: $Z)
		ifTrue: [ ^ self asInteger - 65 + 10 ].
	(self between: $a and: $z)
		ifTrue: [ ^ self asInteger - 97 + 36 ].
	self = $-
		ifTrue: [ ^ 62 ].
	self = $_
		ifTrue: [ ^ 63 ].
	^ 0

	"function decode6bit(c) {
		if (c>='0' && c<='9') return c.charCodeAt(0)-48;
		if (c>='A' && c<='Z') return c.charCodeAt(0)-65+10;
		if (c>='a' && c<='z') return c.charCodeAt(0)-97+36;
		if (c=='-') return 62;
		if (c=='_') return 63;
		return 0;
	}"
]
