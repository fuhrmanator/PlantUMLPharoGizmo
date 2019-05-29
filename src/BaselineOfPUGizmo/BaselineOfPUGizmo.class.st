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
				].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'PUGizmo-GUISpec1';
				package: 'PUGizmo-Extensions'
			 ]
]

{ #category : #accessing }
BaselineOfPUGizmo >> projectClass [
	^ MetacelloCypressBaselineProject
]
