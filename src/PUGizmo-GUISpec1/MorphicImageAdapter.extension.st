Extension { #name : #MorphicImageAdapter }

{ #category : #'*PUGizmo-GUISpec1' }
MorphicImageAdapter >> buildWidget [
		| alphaImage |
	alphaImage := AlphaImageMorph new.
	alphaImage model: self.
	alphaImage
		getImageSelector: #getImage;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		layout: (self model autoScale 
				ifTrue: [ #scaledAspect ]
				ifFalse: [ #center ]);
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		setBalloonText: self help;
		update: #getImage.
	self model
		whenAutoscaleChangeDo: [ widget
				layout:
					(self model autoScale
						ifTrue: [ #scaledAspect ]
						ifFalse: [ #center ]) ].
	^ alphaImage
]
