Extension { #name : #FamixJavaClass }

{ #category : #'*PUGizmo' }
FamixJavaClass >> printOnGizmo: aStream [
	self isInterface ifTrue: [ aStream << 'interface "' ] ifFalse: [ aStream << 'class "' ]
]
