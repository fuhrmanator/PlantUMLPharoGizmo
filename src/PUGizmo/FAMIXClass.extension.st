Extension { #name : #FAMIXClass }

{ #category : #'*PUGizmo' }
FAMIXClass >> printOnGizmo: aStream [
	self isInterface
		ifTrue: [ aStream << 'interface "' ]
		ifFalse: [ aStream << 'class "' ].
]
