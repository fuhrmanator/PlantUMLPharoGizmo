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
	#name : #PUGizmoSpec2,
	#superclass : #ComposablePresenter,
	#instVars : [
		'text',
		'image',
		'imageURL',
		'changeToImageButton',
		'changeToTextButton'
	],
	#category : #'PUGizmo-GUISpec2'
}

{ #category : #specs }
PUGizmoSpec2 class >> defaultSpec [
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
PUGizmoSpec2 class >> open [
	<example>
	self new 
		openWithSpec
]

{ #category : #api }
PUGizmoSpec2 >> changeToImage [
	self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, text text asString plantDeflateAndEncode.
	
]

{ #category : #accessing }
PUGizmoSpec2 >> changeToImageButton [ 
^changeToImageButton 

]

{ #category : #api }
PUGizmoSpec2 >> changeToText [
	text text: imageURL text plantUrlStringToPlantSourceString
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
	imageURL whenTextChangedDo: [ self manageButtons ].
	imageURL acceptBlock: [ :url | self loadUML: url ].
	changeToImageButton action: [ self changeToImage ].
	changeToTextButton action: [ self changeToText ]
]

{ #category : #initialization }
PUGizmoSpec2 >> initializeWidgets [
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

{ #category : #api }
PUGizmoSpec2 >> loadUML: aServerUrl [
	aServerUrl
		ifEmpty: [ image image: nil ]
		ifNotEmpty: [ [ image image: (ZnEasy getPng: aServerUrl) ]
				ensure: [ imageURL text: aServerUrl ] ]
]

{ #category : #'button state' }
PUGizmoSpec2 >> manageButtons [
	text text
		ifEmpty: [ changeToImageButton disable ];
		ifNotEmpty: [ changeToImageButton enable ].
		imageURL  text
		ifEmpty: [ changeToTextButton disable ];
		ifNotEmpty: [ changeToTextButton enable ]
]

{ #category : #accessing }
PUGizmoSpec2 >> text [ ^text
]
