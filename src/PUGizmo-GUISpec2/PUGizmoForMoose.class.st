Class {
	#name : #PUGizmoForMoose,
	#superclass : #SpComposablePresenter,
	#instVars : [
		'modelList',
		'classList',
		'filter',
		'getTheDiagramButton',
		'diagram',
		'resizeCheckBox',
		'attributeCheckBox',
		'methodCheckBox',
		'inheritanceCheckBox',
		'aggregationCheckBox',
		'createCheckBox'
	],
	#category : #'PUGizmo-GUISpec2'
}

{ #category : #specs }
PUGizmoForMoose class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 60 percent;
		add:
			(SpBoxLayout newVertical
				add:
					(SpPanedLayout newHorizontal
						position: 30 percent;
						add: #modelList;
						add: #classList);
				add:
					(SpBoxLayout newVertical
						add: ' ';
						add:
							(SpBoxLayout newHorizontal
								add: 'Filter: [ :each | '
									withConstraints: [ :constraints | constraints width: 80 ];
								add: #filter;
								add: ' ]'
									withConstraints: [ :constraints | constraints width: 15 ]);
						add: ' ';
						add: #getTheDiagramButton
							withConstraints: [ :constraints | constraints height: self toolbarHeight ])
					withConstraints: [ :constraints | constraints height: 3 * self toolbarHeight ]);
		add:
			(SpBoxLayout newVertical
				add:
					(SpBoxLayout newHorizontal
						add: #attributeCheckBox;
						add: #methodCheckBox;
						add: #inheritanceCheckBox;
						add: #aggregationCheckBox;
						add: #createCheckBox)
					withConstraints: [ :constraints | constraints height: self toolbarHeight ];
				add: #diagram;
				add: #resizeCheckBox
					withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
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
	| pUMLSource serverUrl |
	pUMLSource := PUGizmo
		plantUMLSourceForMooseJavaClasses: classList items
		withRelationships:
			{attributeCheckBox state.
			methodCheckBox state.
			inheritanceCheckBox state.
			aggregationCheckBox state.
			createCheckBox  state}.

	"using a local server"
	serverUrl := 'http://localhost:8080/plantuml/img/'
		, pUMLSource asPlantUMLKey.
	"serverUrl := 'https://www.plantuml.com/plantuml/img/', key ."
	diagram image: (ZnEasy getPng: serverUrl asUrl)
]

{ #category : #initialization }
PUGizmoForMoose >> initialExtent [ 
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	^ 100 @ 20 * (fontWidth @ rowHeight)
]

{ #category : #initialization }
PUGizmoForMoose >> initializePresenter [
	modelList whenSelectionChangedDo: [ self updateClasses ].
	filter whenTextIsAcceptedDo: [ self updateClasses ].
	getTheDiagramButton action: [ self getTheDiagram ].
	resizeCheckBox
		whenChangedDo: [ :state | diagram autoScale: state not ].
	attributeCheckBox whenChangedDo: [ self getTheDiagram ].
	methodCheckBox whenChangedDo: [ self getTheDiagram ].
	inheritanceCheckBox whenChangedDo: [ self getTheDiagram ].
	aggregationCheckBox whenChangedDo: [ self getTheDiagram ].
	createCheckBox whenChangedDo: [ self getTheDiagram ].
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
		label: 'Get the Class diagram';
		icon: (self iconNamed: #glamorousGo).
	diagram := self newImage.
	resizeCheckBox := self newCheckBox
		label: 'Original size';
		state: true.
	attributeCheckBox := self newCheckBox label: 'Attributes'.
	methodCheckBox := self newCheckBox label: 'Methods'.
	inheritanceCheckBox := self newCheckBox label: 'Inheritance'.
	aggregationCheckBox := self newCheckBox label: 'Aggregation'.
	createCheckBox := self newCheckBox label: 'Create'.
	self focusOrder
		add: modelList;
		add: classList;
		add: filter;
		add: getTheDiagramButton;
		add: diagram;
		add: resizeCheckBox;
		add: attributeCheckBox;
		add: methodCheckBox;
		add: inheritanceCheckBox;
		add: aggregationCheckBox;
		add: createCheckBox
]

{ #category : #initialization }
PUGizmoForMoose >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 100 @ 20 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'Moose PlantUML Gizmo'
]

{ #category : #api }
PUGizmoForMoose >> title [ 
'Moose PlantUML Gizmo'.
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
	filteredItem
		ifEmpty: [ getTheDiagramButton disable ]
		ifNotEmpty: [ getTheDiagramButton enable ]
]
