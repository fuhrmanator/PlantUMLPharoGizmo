Class {
	#name : #PUGizmoForMoose,
	#superclass : #ComposablePresenter,
	#instVars : [
		'modelList',
		'classList',
		'filter',
		'getTheDiagramButton'
	],
	#category : #'PUGizmo-GUISpec2'
}

{ #category : #specs }
PUGizmoForMoose class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add:
			(SpecPanedLayout newHorizontal position: 30 percent;
				add: #modelList;
				add: #classList);
		add:
			(SpecBoxLayout newVertical
				add: ' ';
				add:
					(SpecBoxLayout newHorizontal
						add: 'Filter: [ :each | '
							withConstraints: [ :constraints | constraints width: 80 ];
						add: #filter;
						add: ' ]'
							withConstraints: [ :constraints | constraints width: 15 ]);
				add: ' ';
				add: #getTheDiagramButton
					withConstraints: [ :constraints | constraints height: self toolbarHeight ])
			withConstraints: [ :constraints | constraints height: 3 * self toolbarHeight ];
		yourself
]

{ #category : #examples }
PUGizmoForMoose class >> open [
	<example>
	self new openWithSpec
]

{ #category : #action }
PUGizmoForMoose >> buildBlockFrom: aString [
	^self class compiler evaluate: '[ :each | ' , aString , ']'
]

{ #category : #action }
PUGizmoForMoose >> getTheDiagram [
	| pUMLSource serverUrl imageMorph |
	pUMLSource := PUGizmo
		plantUMLSourceForMooseJavaClasses: classList items.

	"using a local server"
	serverUrl := 'http://localhost:8080/plantuml/img/' , pUMLSource asPlantUMLKey.
	"serverUrl := 'https://www.plantuml.com/plantuml/img/', key ."
	imageMorph := (ZnEasy getPng: serverUrl asUrl) asAlphaImageMorph.
	imageMorph layout: #scaledAspect.
	imageMorph openInWindow; center;
		fitInWorld
]

{ #category : #initialization }
PUGizmoForMoose >> initializePresenter [
	modelList whenSelectionChangedDo: [ self updateClasses ].
	filter whenTextIsAcceptedDo: [ self updateClasses ].
	getTheDiagramButton action: [ self getTheDiagram ]
]

{ #category : #initialization }
PUGizmoForMoose >> initializeWidgets [
	modelList := self newList.
	modelList
		items: MooseModel root allModels;
		displayBlock: [ :item | item name ];
		icons: [ :item | item mooseIcon ];
		sortingBlock: [ :a :b | a name < b name ].
	classList := self newList.
	classList icons: [ :item | item mooseIcon ].
	filter := self newTextInput placeholder: 'each isStub'.
	getTheDiagramButton := self newButton disable 
		label: 'Get the Class diagrams';
		icon: (self iconNamed: #glamorousGo).
	self focusOrder
		add: modelList;
		add: classList;
		add: filter;
		add: getTheDiagramButton
]

{ #category : #initialization }
PUGizmoForMoose >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 50 @ 15 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'Moose PUGizmo'
]

{ #category : #action }
PUGizmoForMoose >> updateClasses [
	| filterText filterBlock filteredItem |
	filterText := filter text.
	filterText
		ifEmpty: [ filteredItem := modelList selection selectedItem allClasses ]
		ifNotEmpty: [ filterBlock := self buildBlockFrom: filterText.
			[ filteredItem := modelList selection selectedItem allClasses
				select: filterBlock ]
				on: Error
				do: [ filteredItem := {} ] ].
	classList items: filteredItem.
	filteredItem ifEmpty: [ getTheDiagramButton disable  ] ifNotEmpty: [  getTheDiagramButton enable ]
]
