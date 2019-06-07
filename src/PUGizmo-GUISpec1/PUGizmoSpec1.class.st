Class {
	#name : #PUGizmoSpec1,
	#superclass : #ComposablePresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton',
		'imageVerification'
	],
	#category : #'PUGizmo-GUISpec1'
}

{ #category : #specs }
PUGizmoSpec1 class >> defaultSpec [
	^ SpecRowLayout composed
		newColumn: [ :col | 
			col
				add: #text;
				add: #changeToImageButton height: self toolbarHeight ]
			left: 0
			right: 0.7;
		newColumn: [ :col | 
			col
				add: #imageURL height: self toolbarHeight;
				add: #image;
				add: #changeToTextButton height: self toolbarHeight ]
			left: 0.3
			right: 0;
		yourself
]

{ #category : #examples }
PUGizmoSpec1 class >> open [
	<example>
	self new 
		openWithSpec
]

{ #category : #accessing }
PUGizmoSpec1 >> changeToImageButton [ 
^changeToImageButton 

]

{ #category : #accessing }
PUGizmoSpec1 >> changeToTextButton [
	^ changeToTextButton
]

{ #category : #api }
PUGizmoSpec1 >> extent [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	^ 75 @ 15 * (fontWidth @ rowHeight).
]

{ #category : #accessing }
PUGizmoSpec1 >> image [
	^ image
]

{ #category : #accessing }
PUGizmoSpec1 >> imageURL [
	^ imageURL
]

{ #category : #initialization }
PUGizmoSpec1 >> initializePresenter [
	text whenTextChanged: [ self manageButtons ].
	imageURL
		acceptBlock: [ :urlText | self updateWidgets: (PUGizmo loadUML: urlText) ].
	changeToImageButton
		action: [ self updateWidgets: (PUGizmo changeToImage: text text asString) ].
	changeToTextButton
		action: [ text text: (PUGizmo changeToText: imageURL text) ]
]

{ #category : #initialization }
PUGizmoSpec1 >> initializeWidgets [
	imageVerification := false.
	text := self newText autoAccept: true.
	image := self newImage.
	imageURL := self newTextInput ghostText: 'URL'.
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

{ #category : #'button state' }
PUGizmoSpec1 >> manageButtons [
	text text
		ifEmpty: [ changeToImageButton disable ];
		ifNotEmpty: [ changeToImageButton enable ].
	imageVerification
		ifFalse: [ changeToTextButton disable ];
		ifTrue: [ changeToTextButton enable ]
]

{ #category : #accessing }
PUGizmoSpec1 >> text [ ^text
]

{ #category : #api }
PUGizmoSpec1 >> title [ 
^'PUGizmo'
]

{ #category : #update }
PUGizmoSpec1 >> updateWidgets: aCollection [
	imageURL text: aCollection first.
	image image: aCollection second.
	imageVerification := aCollection third.
	self manageButtons
]
