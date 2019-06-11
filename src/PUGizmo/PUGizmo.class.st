Class {
	#name : #PUGizmo,
	#superclass : #Object,
	#category : #PUGizmo
}

{ #category : #api }
PUGizmo class >> changeToImage: source [
	^self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, source asPlantUMLKey
]

{ #category : #api }
PUGizmo class >> changeToText: aURL [
	^aURL  plantUrlStringToPlantSourceString
]

{ #category : #api }
PUGizmo class >> loadUML: aServerUrlText [
	| message image verification |
	image := nil.
	message := ''.
	verification := false.
	aServerUrlText
		ifNotEmpty: [ [ [ [ 
			image := ZnEasy getPng: aServerUrlText.
			verification := true ]
				on: ZnHttpUnsuccessful
				do: [ :ex | 
					| errorMessage lineNumber |
					errorMessage := ex response headers
						at: 'X-Plantuml-Diagram-Error'.
					lineNumber := ex response headers
						at: 'X-Plantuml-Diagram-Error-Line'.
					message := 'Error: ' , errorMessage , ' on line '
						, lineNumber asString.
					image := message asMorph imageForm ] ]
				on: ConnectionTimedOut
				do: [ :ex | 
					message := '[Connection Timed Out] Please check your connection.'.
					image := message asMorph imageForm ] ]
				on: Error
				do: [ :ex | 
					message := '[This is not a usable URL]'.
					image := message asMorph imageForm ] ].
	^ {aServerUrlText.
	image.
	message.
	verification}
]

{ #category : #examples }
PUGizmo class >> open [
	<example>
	"Run the right version of the GUI"
	SystemVersion current major > 7 ifTrue: [ PUGizmoSpec2 open ] ifFalse: [ PUGizmoSpec1 open ]
]

{ #category : #api }
PUGizmo class >> plantUMLSourceForMooseJavaClasses: classes [
	"A utility method with Moose. e.g.:
	| classes pUMLSource commaFlag |
	classes := (MooseModel root first allClasses reject:#isStub) 
		select: [:c | c mooseName beginsWith: 'headfirst::designpatterns::factory::pizzaaf'].
	pUMLSource := PUGizmo plantUMLSourceForMooseJavaClasses: classes.
	key := pUMLSource asPlantUMLKey.
	serverUrl := 'http://localhost:8080/plantuml/img/', key .
	imageMorph := (ZnEasy getPng: serverUrl asUrl) asAlphaImageMorph .
	imageMorph layout: #scaledAspect.
	w := imageMorph openInWindow.
	w center; fitInWorld.	
	"
	^ String
		new: 400
		streamContents: [ :stream | 
			| commaFlag |
			stream
				<< '@startuml';
				cr.
			"Automatic package generation using Moose names"
			stream
				<< 'set namespaceSeparator ::';
				cr.
			"Don't show UML attributes/methods if they're empty"
			stream
				<< 'hide empty members';
				cr.
			"Scale down the diagram"
			stream
				<< 'scale 1';
				cr.
			"Tends to generate a diagram that is longer rather than wider"
			stream
				<< 'left to right direction';
				cr.
			classes
				doWithIndex: [ :c :i | 
					| implemented extended |
					c isInterface
						ifTrue: [ stream << 'interface "' ]
						ifFalse: [ stream << 'class "' ].
					stream
						<< c mooseName;
						<< '"'.	"; << ' as entity'; << i asString"
					extended := OrderedCollection new.
					implemented := OrderedCollection new.
					(c withSuperclassHierarchy reject: #isStub)
						do: [ :sc | 
							sc isInterface
								ifTrue: [ implemented add: sc ]
								ifFalse: [ extended add: sc ] ].
					"Moose includes the class itself in the hierarchy"
					extended remove: c ifAbsent: [  ].
					commaFlag := false.
					extended isNotEmpty
						ifTrue: [ stream << ' extends '.
							extended
								do: [ :e | 
									commaFlag
										ifTrue: [ stream << ', ' ].
									stream << e mooseName.
									commaFlag := true ] ].
					"Moose includes the class itself in the hierarchy"
					implemented remove: c ifAbsent: [  ].
					commaFlag := false.
					implemented isNotEmpty
						ifTrue: [ stream << ' implements '.
							implemented
								do: [ :imp | 
									commaFlag
										ifTrue: [ stream << ', ' ].
									stream << imp mooseName.
									commaFlag := true ] ].
					stream cr ].
			stream
				<< '@enduml';
				cr ]
]
