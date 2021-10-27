Class {
	#name : #PUGizmoSpec2,
	#superclass : #SpPresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton',
		'imageVerification',
		'sourceList',
		'resizeCheckBox'
	],
	#category : #'PUGizmo-GUISpec2'
}

{ #category : #specs }
PUGizmoSpec2 class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 30 percent;
		add:
			(SpBoxLayout newVertical
				add: #sourceList
					withConstraints: [ :constraints | constraints height: self toolbarHeight ];
				add: #text;
				add: #changeToImageButton
					withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
		add:
			(SpBoxLayout newVertical
				add: #imageURL
					withConstraints: [ :constraints | constraints height: self toolbarHeight ];
				add: #image;
				add: #resizeCheckBox
					withConstraints: [ :constraints | constraints height: self toolbarHeight ];
				add: #changeToTextButton
					withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
		yourself
]

{ #category : #example }
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
PUGizmoSpec2 >> image [
^image
]

{ #category : #accessing }
PUGizmoSpec2 >> imageURL [
	^ imageURL
]

{ #category : #initialization }
PUGizmoSpec2 >> initialExtent [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	^ 75 @ 20 * (fontWidth @ rowHeight)
]

{ #category : #initialization }
PUGizmoSpec2 >> initialize [
	super initialize.
	imageVerification := false.
	sourceList
		items: {('---Select a sample---' -> nil)} , PUGizmo sourceSamples;
		display: [ :item | item key ].
	text text: 'Bob->Alice : hello'.
	resizeCheckBox state: true.
	changeToImageButton performAction
]

{ #category : #initialization }
PUGizmoSpec2 >> initializePresenter [
	sourceList
		whenSelectedItemChangedDo: [ :item | self selectSample: item ].
	text whenTextChangedDo: [ self manageButtons ].
	imageURL
		acceptBlock: [ :urlText | self updateWidgets: (PUGizmo loadUML: urlText) ].
	resizeCheckBox whenChangedDo: [ :state | image autoScale: state not ].
	changeToImageButton
		action: [ self updateWidgets: (PUGizmo changeToImage: text text asString) ].
	changeToTextButton
		action: [ text text: (PUGizmo changeToText: imageURL text) ]
]

{ #category : #initialization }
PUGizmoSpec2 >> initializeWidgets [
	sourceList := self newDropList.
	text := self newText autoAccept: true.
	image := self newImage.
	imageURL := self newTextInput placeholder: 'URL'.
	resizeCheckBox := self newCheckBox label: 'Original size'.
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
	aWindowPresenter initialExtent: 75 @ 20 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
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
PUGizmoSpec2 >> resizeCheckBox [
^resizeCheckBox
]

{ #category : #update }
PUGizmoSpec2 >> selectSample: anItem [
	anItem value
		ifNil: [ text text: ''.
			imageURL accept: '' ]
		ifNotNil:[.
	self
		updateWidgets:
			(PUGizmo
				loadUML: 'https://www.plantuml.com/plantuml/img/' , anItem value).
	changeToTextButton performAction].
]

{ #category : #accessing }
PUGizmoSpec2 >> text [ ^text
]

{ #category : #api }
PUGizmoSpec2 >> title [ 
^'PUGizmo'
]

{ #category : #update }
PUGizmoSpec2 >> updateWidgets: aCollection [
	| helpMessage |
	helpMessage := aCollection third.
	imageURL text: aCollection first.
	image image: aCollection second.
	helpMessage = ''
		ifTrue: [ image help: nil ]
		ifFalse: [ image help: helpMessage ].
	imageVerification := aCollection fourth.
	self manageButtons
]
