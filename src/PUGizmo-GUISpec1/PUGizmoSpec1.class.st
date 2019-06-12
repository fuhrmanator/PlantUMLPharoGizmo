Class {
	#name : #PUGizmoSpec1,
	#superclass : #ComposablePresenter,
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
	#category : #'PUGizmo-GUISpec1'
}

{ #category : #specs }
PUGizmoSpec1 class >> defaultSpec [
	^ SpecRowLayout composed
		newColumn: [ :col | 
			col
				add: #sourceList height: self toolbarHeight;
				add: #text;
				add: #changeToImageButton height: self toolbarHeight ]
			left: 0
			right: 0.7;
		newColumn: [ :col | 
			col
				add: #imageURL height: 40;
				add: #image;
				add: #resizeCheckBox height: self toolbarHeight;
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
	^ 75 @ 20 * (fontWidth @ rowHeight)
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
PUGizmoSpec1 >> initialize [
	super initialize.
	imageVerification := false.
	sourceList
		items: {('---Select a sample---' -> nil)} , PUGizmo sourceSamples;
		displayBlock: [ :item | item key ].
	text text: 'Bob->Alice : hello'.
	resizeCheckBox state: true .changeToImageButton performAction
]

{ #category : #initialization }
PUGizmoSpec1 >> initializePresenter [
	sourceList
		whenSelectedItemChanged: [ :item | self selectSample: item ].
	text whenTextChanged: [ self manageButtons ].
	imageURL
		acceptBlock: [ :urlText | self updateWidgets: (PUGizmo loadUML: urlText) ].
	resizeCheckBox whenChangedDo: [ :state | image autoScale: state not ].
	changeToImageButton
		action: [ self updateWidgets: (PUGizmo changeToImage: text text asString) ].
	changeToTextButton
		action: [ text text: (PUGizmo changeToText: imageURL text) ].
]

{ #category : #initialization }
PUGizmoSpec1 >> initializeWidgets [
	sourceList := self newDropList.
	text := self newText autoAccept: true.
	image := self newImage switchAutoscale.
	imageURL := self newTextInput ghostText: 'URL'.
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
PUGizmoSpec1 >> resizeCheckBox [
^resizeCheckBox
]

{ #category : #update }
PUGizmoSpec1 >> selectSample: anItem [
	anItem value
		ifNil: [ text text: ''.
			imageURL accept: ''.
			]
		ifNotNil: [ self
				updateWidgets:
					(PUGizmo
						loadUML: 'https://www.plantuml.com/plantuml/img/' , anItem value).
			changeToTextButton performAction ]
]

{ #category : #accessing }
PUGizmoSpec1 >> sourceList [
^sourceList
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
	| helpMessage |
	helpMessage := aCollection third.
	imageURL text: aCollection first.
	aCollection second
		ifNil: [ image image: (self iconNamed: #'blank-10') ]
		ifNotNil: [ image image: aCollection second ].
	helpMessage = ''
		ifTrue: [ image help ]
		ifFalse: [ image help: helpMessage ].
	imageVerification := aCollection fourth.
	self manageButtons
]
