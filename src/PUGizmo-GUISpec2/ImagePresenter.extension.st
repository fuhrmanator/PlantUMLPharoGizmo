Extension { #name : #ImagePresenter }

{ #category : #'*PUGizmo-GUISpec2' }
ImagePresenter >> autoScale: aBoolean [
	autoScale := aBoolean
]

{ #category : #'*PUGizmo-GUISpec2' }
ImagePresenter >> whenAutoscaleChangeDo: aBlockClosure [ 
	
	self property: #autoScale whenChangedDo: aBlockClosure 
]
