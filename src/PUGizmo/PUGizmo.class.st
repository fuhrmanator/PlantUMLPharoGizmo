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
