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
				package: 'PUGizmo-GUISpec2';
				package: 'PUGizmo-Extensions'
					with: [ spec requires: #('PUGizmo-GUISpec2') ] ].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'PUGizmo-GUISpec1';
				package: 'PUGizmo-Extensions'
					with: [ spec requires: #('PUGizmo-GUISpec1') ] ]
]

{ #category : #accessing }
BaselineOfPUGizmo >> projectClass [
	^ MetacelloCypressBaselineProject
]
