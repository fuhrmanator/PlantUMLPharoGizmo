Class {
	#name : #BaselineOfPUGizmo,
	#superclass : #BaselineOf,
	#category : #BaselineOfPUGizmo
}

{ #category : #baseline }
BaselineOfPUGizmo >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'PUGizmo'
				with: [ spec repository: 'github://fuhrmanator/PUGizmo' ] ]
]

{ #category : #accessing }
BaselineOfPUGizmo >> projectClass [
	^ MetacelloCypressBaselineProject
]
