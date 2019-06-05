Class {
	#name : #PUGizmoSpec1,
	#superclass : #ComposablePresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton'
	],
	#category : #'PUGizmo-GUISpec1'
}

{ #category : #specs }
PUGizmoSpec1 class >> defaultSpec [
	^ SpecRowLayout composed
		newColumn: [ :col | 
			col
				add: #text;
				add: #changeToImageButton height: self toolbarHeight ];
		newColumn: [ :col | 
			col
				add: #imageURL height: self toolbarHeight;
				add: #image;
				add: #changeToTextButton height: self toolbarHeight ];
		yourself
]

{ #category : #examples }
PUGizmoSpec1 class >> open [
	<example>
	self new 
		openWithSpec
]

{ #category : #api }
PUGizmoSpec1 >> changeToImage [
	self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, text text asString plantDeflateAndEncode.
	
]

{ #category : #accessing }
PUGizmoSpec1 >> changeToImageButton [ 
^changeToImageButton 

]

{ #category : #api }
PUGizmoSpec1 >> changeToText [
	text text: imageURL text plantUrlStringToPlantSourceString
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
	imageURL whenTextChanged: [ self manageButtons ].
	imageURL acceptBlock: [ :urlText | self loadUML: urlText ].
	changeToImageButton action: [ self changeToImage ].
	changeToTextButton action: [ self changeToText ]
]

{ #category : #initialization }
PUGizmoSpec1 >> initializeWidgets [
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

{ #category : #api }
PUGizmoSpec1 >> loadUML: aServerUrlText [
	aServerUrlText
		ifEmpty: [ image image: nil ]
		ifNotEmpty: [ | theUrl |
			theUrl := aServerUrlText asUrl.
			theUrl isValid
				ifTrue: [ [ image image: (ZnEasy getPng: theUrl).image autoScaleHolder value: false ]
					on: ZnHttpUnsuccessful do: [ :ex | image image: (ImageReadWriter formFromStream: ex response entity readStream). image autoScaleHolder value: true 
						"Also maybe show error message in text form"
						"self headers at: 'X-Plantuml-Diagram-Error'"
						"self headers at: 'X-Plantuml-Diagram-Error-Line'"
						 ]
						"ensure: [ imageURL text: aServerUrlText ]" ] ]
]

{ #category : #'button state' }
PUGizmoSpec1 >> manageButtons [
	text text
		ifEmpty: [ changeToImageButton disable ];
		ifNotEmpty: [ changeToImageButton enable ].
		imageURL  text
		ifEmpty: [ changeToTextButton disable ];
		ifNotEmpty: [ changeToTextButton enable ]
]

{ #category : #accessing }
PUGizmoSpec1 >> text [ ^text
]

{ #category : #api }
PUGizmoSpec1 >> title [ 
^'PUGizmo'
]
