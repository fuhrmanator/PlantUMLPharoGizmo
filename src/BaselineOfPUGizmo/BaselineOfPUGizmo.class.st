Class {
	#name : #BaselineOfPUGizmo,
	#superclass : #BaselineOf,
	#category : #BaselineOfPUGizmo
}

{ #category : #baseline }
BaselineOfPUGizmo >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'PUGizmo';
			package: 'PUGizmo-Tests' with: [ spec requires: #( 'PUGizmo' ) ] ].
	spec for: #'pharo9.x' do: [ 
		spec
			package: 'PUGizmo-GUISpec2'
			with: [ spec requires: #( 'PUGizmo' ) ] ].
	spec for: #'pharo7.x' do: [ 
		spec
			package: 'PUGizmo-GUISpec1'
			with: [ spec requires: #( 'PUGizmo' ) ] ]
]

{ #category : #accessing }
BaselineOfPUGizmo >> projectClass [
	^ MetacelloCypressBaselineProject
]
