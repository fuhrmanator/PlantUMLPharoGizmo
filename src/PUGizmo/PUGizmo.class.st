"
""I represent the abstraction of using PlantUML inside Pharo...

Here's an example: ""

plantUMLSource := ('@startuml' , String cr ,
'skinparam style strictuml' , String cr ,
'skinparam backgroundcolor transparent' , String cr ,
'skinparam classbackgroundcolor Yellow/LightYellow' , String cr ,
'class Banana' , String cr ,
'note right #red: Ceci n''est pas\nune banane. ' , String cr ,
'@enduml').

codePart := plantUMLSource plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.

""Get the Source back from a URL""
recoveredSource := serverUrl plantUrlStringToPlantSourceString.

self assert: recoveredSource equals: plantUMLSource.

""Mind map""

plantUMLSource := Character cr join: #('@startmindmap' '* Debian' '** Ubuntu' '*** Linux Mint' '*** Kubuntu' '*** Lubuntu' '*** KDE Neon' '** LMDE' '** SolydXK' '** SteamOS' '** Raspbian with a very long name' '*** <s>Raspmbc</s> => OSMC' '*** <s>Raspyfi</s> => Volumio' '@endmindmap').

codePart := plantUMLSource plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.

"
Class {
	#name : #PUGizmo,
	#superclass : #ComposablePresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton'
	],
	#category : #PUGizmo
}

{ #category : #specs }
PUGizmo class >> defaultSpec [
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
PUGizmo class >> open [
	<example>
	self new 
		openWithSpec
]

{ #category : #api }
PUGizmo >> changeToImage [
	self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, text text asString plantDeflateAndEncode.
	
]

{ #category : #accessing }
PUGizmo >> changeToImageButton [ 
^changeToImageButton 

]

{ #category : #api }
PUGizmo >> changeToText [
	text text: imageURL text plantUrlStringToPlantSourceString
]

{ #category : #accessing }
PUGizmo >> changeToTextButton [
	^ changeToTextButton
]

{ #category : #accessing }
PUGizmo >> imageURL [
	^ imageURL
]

{ #category : #initialization }
PUGizmo >> initializePresenter [
	text whenTextChangedDo: [ self manageButtons ].
	imageURL whenTextChangedDo: [ self manageButtons ].
	imageURL acceptBlock: [ :url | self loadUML: url ].
	changeToImageButton action: [ self changeToImage ].
	changeToTextButton action: [ self changeToText ]
]

{ #category : #initialization }
PUGizmo >> initializeWidgets [
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
PUGizmo >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 75 @ 15 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'PUGizmo'
]

{ #category : #api }
PUGizmo >> loadUML: aServerUrl [
	aServerUrl
	ifEmpty:[ image image:nil ]
		ifNotEmpty: [ [ image image: (ZnEasy getPng: aServerUrl) ]
				ensure: [ imageURL text: aServerUrl ] ]
]

{ #category : #'button state' }
PUGizmo >> manageButtons [
	text text
		ifEmpty: [ changeToImageButton disable ];
		ifNotEmpty: [ changeToImageButton enable ].
		imageURL  text
		ifEmpty: [ changeToTextButton disable ];
		ifNotEmpty: [ changeToTextButton enable ]
]

{ #category : #accessing }
PUGizmo >> text [ ^text
]
