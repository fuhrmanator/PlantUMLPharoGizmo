Class {
	#name : #PUGizmoSpec2,
	#superclass : #ComposablePresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton',
		'imageVerification'
	],
	#category : #'PUGizmo-GUISpec2'
}

{ #category : #specs }
PUGizmoSpec2 class >> defaultSpec [
	^ SpecPanedLayout
		newHorizontal
		position: 30 percent;
			add:
			(SpecBoxLayout newVertical
				add: #text;
				add: #changeToImageButton
					withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
		add:
			(SpecBoxLayout newVertical
				add: #imageURL
					withConstraints: [ :constraints | constraints height: self toolbarHeight ];
				add: #image;
				add: #changeToTextButton
					withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
		yourself
]

{ #category : #examples }
PUGizmoSpec2 class >> open [
	<example>
	self new 
		openWithSpec
]

{ #category : #accessing }
PUGizmoSpec2 >> changeToImageButton [ 
^changeToImageButton 

]

{ #category : #accessing }
PUGizmoSpec2 >> changeToTextButton [
	^ changeToTextButton
]

{ #category : #accessing }
PUGizmoSpec2 >> imageURL [
	^ imageURL
]

{ #category : #initialization }
PUGizmoSpec2 >> initializePresenter [
	text whenTextChangedDo: [ self manageButtons ].
	imageURL
		acceptBlock: [ :urlText | 
			self updateWidgets:(PUGizmo loadUML: urlText) ].
	changeToImageButton
		action: [ 
				self updateWidgets:(PUGizmo changeToImage: text text asString).
			 ].
	changeToTextButton
		action: [ text text: (PUGizmo changeToText: imageURL text) ]
]

{ #category : #initialization }
PUGizmoSpec2 >> initializeWidgets [

	imageVerification := false.
	text := self newText autoAccept: true.
	image := self newImage.
	imageURL := self newTextInput placeholder: 'URL'.
	changeToImageButton := self newButton disable
		label: 'Get the UML';
		icon: (self iconNamed: #glamorousRight).
	changeToTextButton := self newButton disable
		label: 'Get the Text';
		icon: (self iconNamed: #glamorousLeft).
	self focusOrder
		add: text;
		add: image;
		add: imageURL;
		add: changeToImageButton;
		add: changeToTextButton
]

{ #category : #initialization }
PUGizmoSpec2 >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 75 @ 15 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'PUGizmo'
]

{ #category : #'button state' }
PUGizmoSpec2 >> manageButtons [
	text text
		ifEmpty: [ changeToImageButton disable ];
		ifNotEmpty: [ changeToImageButton enable ].
imageVerification
		ifFalse: [ changeToTextButton disable ];
		ifTrue: [ changeToTextButton enable ]
]

{ #category : #accessing }
PUGizmoSpec2 >> text [ ^text
]

{ #category : #update }
PUGizmoSpec2 >> updateWidgets: aCollection [
	imageURL text: aCollection first.
	image image: aCollection second.
	image help: aCollection third.
	imageVerification := aCollection fourth.
	self manageButtons
]
