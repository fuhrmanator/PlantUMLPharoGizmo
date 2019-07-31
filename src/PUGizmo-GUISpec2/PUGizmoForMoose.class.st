Class {
	#name : #PUGizmoForMoose,
	#superclass : #SpPresenter,
	#instVars : [
		'modelList',
		'classTable',
		'selectionTable',
		'filter',
		'getTheDiagramButton',
		'preferenceButton',
		'diagram',
		'resizeCheckBox',
		'attributeCheckBox',
		'methodCheckBox',
		'inheritanceCheckBox',
		'aggregationCheckBox',
		'createCheckBox',
		'preferencePresenter',
		'preference',
		'pUMLSource',
		'copySourceButton',
		'items',
		'selectedClasses'
	],
	#category : #'PUGizmo-GUISpec2'
}

{ #category : #specs }
PUGizmoForMoose class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 60 percent;
		add:
			(SpPanedLayout newHorizontal
				position: 70 percent;
				add:
					(SpBoxLayout newVertical
						add:
							(SpPanedLayout newHorizontal
								position: 30 percent;
								add: #modelList;
								add: #classTable);
						add: ''
							withConstraints: [ :constraints | constraints height: 0 ];
						add:
							(SpBoxLayout newHorizontal
								add: 'Filter: [ :each | '
									withConstraints: [ :constraints | constraints width: 80 ];
								add: #filter;
								add: ' ]'
									withConstraints: [ :constraints | constraints width: 15 ])
							withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
				add:
					(SpBoxLayout newVertical
						add: #selectionTable;
						add: ''
							withConstraints: [ :constraints | constraints height: 0 ];
						add: #getTheDiagramButton
							withConstraints: [ :constraints | constraints height: self toolbarHeight ]));
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
				add: (SpScrollableLayout with: #diagram); "Might work in the future"
				add:
					(SpBoxLayout newHorizontal
						add: #resizeCheckBox;
						add: #preferenceButton;
						add: #copySourceButton)
					withConstraints: [ :constraints | constraints height: self toolbarHeight ]);
		yourself
]

{ #category : #examples }
PUGizmoForMoose class >> open [
	<example>
	<mooseTool: #'PlantUML Gizmo'>
	self new openWithSpec
]

{ #category : #action }
PUGizmoForMoose >> buildBlockFrom: aString [
[ ^self class compiler evaluate: '[ :each | ' , aString , ']' ]
		on: SyntaxErrorNotification
		do: [ ^ [  ] ].

]

{ #category : #menu }
PUGizmoForMoose >> classListMenu [
	^ self newMenu
		addGroup: [ :aGroup | 
			aGroup
				addItem: [ :anItem | 
					anItem
						name: 'Select';
						action: [ self selectClasses ] ] ]
]

{ #category : #accessing }
PUGizmoForMoose >> classTable [
	"For the test"

	^ classTable
]

{ #category : #action }
PUGizmoForMoose >> copyUMLCode [
	Clipboard clipboardText: pUMLSource.
	self inform: 'Copy'
]

{ #category : #accessing }
PUGizmoForMoose >> filter [
	"For the test"

	^ filter
]

{ #category : #initialization }
PUGizmoForMoose >> initialExtent [ 
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	^ 100 @ 20 * (fontWidth @ rowHeight)
]

{ #category : #initialization }
PUGizmoForMoose >> initialize [
	pUMLSource := ''.
	selectedClasses := OrderedCollection new.
	preference := 'set namespaceSeparator ::' , String cr
		, 'hide empty members' , String cr , 'scale 1' , String cr
		, 'left to right direction' , String cr.
	preferencePresenter := PreferencePresenter new.
	super initialize
]

{ #category : #initialization }
PUGizmoForMoose >> initializePresenter [
	modelList whenSelectionChangedDo: [ 	selectedClasses removeAll.self updateClasses ].
	filter whenTextIsAcceptedDo: [ self updateClasses ].
	getTheDiagramButton action: [ self setDiagram ].
	preferenceButton action: [ self managePreferenceDialog ].
	copySourceButton action: [ self copyUMLCode ].
	resizeCheckBox
		whenChangedDo: [ :state | diagram autoScale: state not ].
	attributeCheckBox whenChangedDo: [ self updateDiagram ].
	methodCheckBox whenChangedDo: [ self updateDiagram ].
	inheritanceCheckBox whenChangedDo: [ self updateDiagram ].
	aggregationCheckBox whenChangedDo: [ self updateDiagram ].
	createCheckBox whenChangedDo: [ self updateDiagram ]
]

{ #category : #initialization }
PUGizmoForMoose >> initializeTables [
	classTable := self newTable
		beMultipleSelection;
		contextMenu: self classListMenu;
		sortingBlock: [ :a :b | a fullPrintString < b fullPrintString ].
	classTable
		addColumn:
			((SpCheckBoxTableColumn
				evaluated: [ :class | selectedClasses includes: class ])
				onActivation: [ :class | 
					selectedClasses add: class.
					self updateSelections ];
				onDesactivation: [ :class | 
					selectedClasses remove: class.
					self updateSelections ];
				width: 20;
				yourself);
		addColumn:
			((SpImageTableColumn evaluated: #mooseIcon)
				width: 20;
				yourself);
		addColumn: (SpStringTableColumn evaluated: #fullPrintString).
	selectionTable := self newTable
		beMultipleSelection;
		contextMenu: self selectionListMenu.
	selectionTable
		addColumn:
			((SpCheckBoxTableColumn
				evaluated: [ :class | selectedClasses includes: class ])
				onDesactivation: [ :class | 
					selectedClasses remove: class.
					self updateSelections ];
				width: 20;
				yourself);
		addColumn:
			((SpImageTableColumn evaluated: #mooseIcon)
				width: 20;
				yourself);
		addColumn: (SpStringTableColumn evaluated: #name)
]

{ #category : #initialization }
PUGizmoForMoose >> initializeWidgets [
	self initializeTables.
	modelList := self newList.
	modelList
		items: MooseModel root allModels;
		displayBlock: [ :item | item name ];
		icons: [ :item | item mooseIcon ];
		sortingBlock: [ :a :b | a name < b name ].
	filter := self newTextInput placeholder: 'each isStub'.
	getTheDiagramButton := self newButton disable
		label: 'Get the diagram';
		icon: (self iconNamed: #glamorousGo).
	preferenceButton := self newButton disable label: 'Preference'.
	copySourceButton := self newButton disable
		label: 'Copy current UML code'.
	diagram := self newImage.
	resizeCheckBox := self newCheckBox disable
		label: 'Original size';
		state: true.
	attributeCheckBox := self newCheckBox disable label: 'Attributes'.
	methodCheckBox := self newCheckBox disable label: 'Methods'.
	inheritanceCheckBox := self newCheckBox disable label: 'Inheritance'.
	aggregationCheckBox := self newCheckBox disable label: 'Aggregation'.
	createCheckBox := self newCheckBox disable label: 'Create'.
	self focusOrder
		add: modelList;
		add: classTable;
		add: selectionTable;
		add: filter
]

{ #category : #initialization }
PUGizmoForMoose >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 110 @ 20 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
]

{ #category : #action }
PUGizmoForMoose >> managePreferenceDialog [
	preferencePresenter preference: preference.
	preferencePresenter openDialogWithSpec
		okAction: [ preference := preferencePresenter preference asString.
			self updateDiagram.
			preferencePresenter window close ]
]

{ #category : #accessing }
PUGizmoForMoose >> modelList [
	"For the test"
	^ modelList
]

{ #category : #action }
PUGizmoForMoose >> selectClasses [
	selectedClasses addAllFirstUnlessAlreadyPresent: classTable selection selectedItems.
	self updateSelections.
]

{ #category : #menu }
PUGizmoForMoose >> selectionListMenu [
	^ self newMenu
		addGroup: [ :aGroup | 
			aGroup
				addItem: [ :anItem | 
					anItem
						name: 'Unselect';
						action: [ self unselectClasses ] ] ]
]

{ #category : #accessing }
PUGizmoForMoose >> selectionTable [
	"For the test"

	^ selectionTable
]

{ #category : #action }
PUGizmoForMoose >> setDiagram [
	items := selectedClasses..
	attributeCheckBox enable.
	methodCheckBox enable.
	inheritanceCheckBox enable.
	aggregationCheckBox enable.
	createCheckBox enable.
	resizeCheckBox enable.
	preferenceButton enable.
	copySourceButton enable.
	self updateDiagram.
	getTheDiagramButton disable
]

{ #category : #api }
PUGizmoForMoose >> title [
	^'Moose PlantUML Gizmo'
]

{ #category : #action }
PUGizmoForMoose >> unselectClasses [
	selectionTable selection selectedItems
		do: [ :each | selectedClasses remove: each ] .self updateSelections
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
				do: [
					filteredItem := {} ] ].
	classTable items: filteredItem.
	filteredItem
		ifEmpty: [ getTheDiagramButton disable ]
		ifNotEmpty: [ getTheDiagramButton enable ].
	self updateSelections
]

{ #category : #action }
PUGizmoForMoose >> updateDiagram [

	| serverUrl |
	pUMLSource := PUGizmo
		plantUMLSourceForMooseJavaClasses: items
		withPreference: preference
		withRelationships:
			{attributeCheckBox state.
			methodCheckBox state.
			inheritanceCheckBox state.
			aggregationCheckBox state.
			createCheckBox state}.

	"using a local server"
	serverUrl := 'http://localhost:8080/plantuml/img/'
		, pUMLSource asPlantUMLKey.
	"serverUrl := 'https://www.plantuml.com/plantuml/img/', key ."
	diagram image: (ZnEasy getPng: serverUrl asUrl)
]

{ #category : #action }
PUGizmoForMoose >> updateSelections [
	selectionTable items: selectedClasses.
	classTable items: classTable items.
	
	selectedClasses ifEmpty: [ getTheDiagramButton disable]ifNotEmpty:[ getTheDiagramButton enable]
]
