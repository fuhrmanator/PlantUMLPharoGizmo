Extension { #name : #ImagePresenter }

{ #category : #'*PUGizmo-GUISpec1' }
ImagePresenter >> autoScale: aBoolean [
	autoScaleHolder value:aBoolean
]

{ #category : #'*PUGizmo-GUISpec1' }
ImagePresenter >> whenAutoscaleChangeDo: aBlockClosure [
	autoScaleHolder whenChangedDo: aBlockClosure
]
