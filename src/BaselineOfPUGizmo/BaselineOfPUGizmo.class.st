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
		do: [ spec preLoadDoIt: #verifyMooseInstalled.
			spec
				package: 'PUGizmo';
				package: 'PUGizmo-Tests' with: [ spec requires: #('PUGizmo') ] ].
	spec
		for: #'pharo8.x'
		do: [ spec
				package: 'PUGizmo-GUISpec2'
				with: [ spec requires: #('PUGizmo') ] ].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'PUGizmo-GUISpec1'
				with: [ spec requires: #('PUGizmo') ] ]
]

{ #category : #accessing }
BaselineOfPUGizmo >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfPUGizmo >> verifyMooseInstalled [
	self class environment
		at: #MooseModel
		ifAbsent: [ UIManager default
				abort:
					'Moose must be present prior to loading PlantUML Gizmo. The baseline doesn''t load it because it''s big. We recommend loading it from the GitHub repo, or starting with a Moose image from Pharo Launcher. NOTE: A version of PlantUML Gizmo that does NOT require Moose exists. See the README in the main github repo.' ]
]
