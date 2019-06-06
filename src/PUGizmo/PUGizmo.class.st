Class {
	#name : #PUGizmo,
	#superclass : #Object,
	#category : #PUGizmo
}

{ #category : #examples }
PUGizmo class >> open [
	<example>
	"Run the right version of the GUI"
	SystemVersion current major > 7 ifTrue: [ PUGizmoSpec2 open ] ifFalse: [ PUGizmoSpec1 open ]
]
