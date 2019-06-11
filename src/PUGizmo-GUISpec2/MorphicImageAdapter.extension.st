Extension { #name : #MorphicImageAdapter }

{ #category : #'*PUGizmo-GUISpec2' }
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
		
	self model whenImageChangeDo: [ 
		(self getImage) 
			ifNotNil: [ :x | alphaImage image: x ] 
			ifNil: [ alphaImage image: (Form extent: 1@1 depth: 32)] ].
		
		self model whenAutoscaleChangeDo: [ widget layout: (self model autoScale 
				ifTrue: [ #scaledAspect ]
				ifFalse: [ #center ]) ].
		
	^ alphaImage
]
