Class {
	#name : #BaselineOfPUGizmo,
	#superclass : #BaselineOf,
	#category : #BaselineOfPUGizmo
}

{ #category : #baseline }
BaselineOfPUGizmo >> baseline: spec [
	<baseline>
	spec
		for: #'pharo8.x'
		do: [ spec
				package: 'PUGizmo';
				package: 'PUGizmo-GUISpec2' with: [ spec requires: #('PUGizmo') ] ].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'PUGizmo';
				package: 'PUGizmo-GUISpec1'  with: [ spec requires: #('PUGizmo') ]]
]

{ #category : #accessing }
BaselineOfPUGizmo >> projectClass [
	^ MetacelloCypressBaselineProject
]
