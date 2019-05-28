Class {
	#name : #PharoUMLBuilder,
	#superclass : #ComposablePresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton'
	],
	#category : #'PUGizmo-GUI'
}

{ #category : #specs }
PharoUMLBuilder class >> defaultSpec [
	^ SpecPanedLayout newHorizontal
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
PharoUMLBuilder class >> open [
	<example>
	self new 
		openWithSpec
]

{ #category : #api }
PharoUMLBuilder >> changeToImage [
	self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, text text asString plantDeflateAndEncode.
	
]

{ #category : #accessing }
PharoUMLBuilder >> changeToImageButton [ 
^changeToImageButton 

]

{ #category : #api }
PharoUMLBuilder >> changeToText [
	text text: imageURL text plantUrlStringToPlantSourceString
]

{ #category : #accessing }
PharoUMLBuilder >> changeToTextButton [
	^ changeToTextButton
]

{ #category : #accessing }
PharoUMLBuilder >> imageURL [
	^ imageURL
]

{ #category : #initialization }
PharoUMLBuilder >> initializePresenter [
	imageURL acceptBlock: [ :url | self loadUML: url ].
	changeToImageButton action: [ self changeToImage ].
	changeToTextButton action: [ self changeToText ]
]

{ #category : #initialization }
PharoUMLBuilder >> initializeWidgets [
	text := self newText autoAccept: true.
	image := self newImage.
	imageURL := self newTextInput placeholder: 'URL'.
	changeToImageButton := self newButton
		label: 'Get the UML';
		icon: (self iconNamed: #glamorousRight).
	changeToTextButton := self newButton
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
PharoUMLBuilder >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 75 @ 15 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'Pharo UML Builder'
]

{ #category : #api }
PharoUMLBuilder >> loadUML: aServerUrl [
	aServerUrl
		ifNotEmpty: [ [ image image: (ZnEasy getPng: aServerUrl) ]
				ensure: [imageURL text: aServerUrl ] ]
]

{ #category : #accessing }
PharoUMLBuilder >> text [ ^text
]
