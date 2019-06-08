Class {
	#name : #PUGizmo,
	#superclass : #Object,
	#category : #PUGizmo
}

{ #category : #api }
PUGizmo class >> changeToImage: aString [
	^self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, aString plantDeflateAndEncode
]

{ #category : #api }
PUGizmo class >> changeToText: aURL [
	^aURL  plantUrlStringToPlantSourceString
]

{ #category : #api }
PUGizmo class >> loadUML: aServerUrlText [
	| image verification |
	image := nil.
	verification := false.
	aServerUrlText
		ifNotEmpty: [ [ [ [ image := ZnEasy getPng: aServerUrlText.
			verification := true ]
				on: ZnHttpUnsuccessful
				do: [ :ex | 
					image := 'Error: ' asMorph imageForm.
					image := ('[', (ex response headers at: 'X-Plantuml-Diagram-Error'), '] on the line', (ex response headers at: 'X-Plantuml-Diagram-Error-Line')) asMorph imageForm ] ]
				on: ConnectionTimedOut
				do: [ :ex | 
					image := '[Connection Timed Out] Please check your connection.'
						asMorph imageForm ] ]
				on: Error
				do: [ :ex | image := '[This is not a usable URL]' asMorph imageForm ] ].
	^ {aServerUrlText.
	image.
	verification}
]

{ #category : #examples }
PUGizmo class >> open [
	<example>
	"Run the right version of the GUI"
	SystemVersion current major > 7 ifTrue: [ PUGizmoSpec2 open ] ifFalse: [ PUGizmoSpec1 open ]
]
