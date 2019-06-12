Class {
	#name : #PUGizmoSpec1Test,
	#superclass : #SpecTestCase,
	#instVars : [
		'plantUMLSource',
		'url'
	],
	#category : #'PUGizmo-GUISpec1'
}

{ #category : #running }
PUGizmoSpec1Test >> classToTest [
	^ PUGizmoSpec1
]

{ #category : #setup }
PUGizmoSpec1Test >> setUp [
	super setUp.
	plantUMLSource := '@startuml' , String cr
		, 'skinparam style strictuml' , String cr
		, 'skinparam backgroundcolor transparent' , String cr
		, 'skinparam classbackgroundcolor Yellow/LightYellow' , String cr
		, 'class Banana' , String cr
		, 'note right #red: Ceci n''est pas\nune banane. ' , String cr
		, '@enduml'.
	url:='https://www.plantuml.com/plantuml/img/NOv12i9034LFC7S8kEXEzwwARhs0u2REX3eqpPGaWtXxeswaVFW4teEVqHpL-yB9vYehAYvW_cAArfetv8vvdhHrARbnKt15iK0a_cTbHhEjUYNczZnSwlJmtvs-7fnG8acQ4-Y7mawf7E5CkO8CP0uhsaswKEo7Itj88qc9rzu0'
]

{ #category : #tests }
PUGizmoSpec1Test >> testChangeToImageButton [
	testedInstance text text: plantUMLSource.
	testedInstance changeToImageButton performAction.
	self assert: testedInstance imageURL text asString equals:url.
]

{ #category : #tests }
PUGizmoSpec1Test >> testChangeToTextButton [
	testedInstance imageURL accept: url.
	testedInstance changeToTextButton performAction.
	self assert: testedInstance text text asString equals: plantUMLSource.
	
]

{ #category : #tests }
PUGizmoSpec1Test >> testManageButtons [
	self deny: testedInstance changeToImageButton enabled.
	self deny: testedInstance changeToTextButton enabled.
	testedInstance text text: plantUMLSource.
	self assert: testedInstance changeToImageButton enabled.
	testedInstance imageURL accept: url.
	self assert: testedInstance changeToTextButton enabled
]

{ #category : #tests }
PUGizmoSpec1Test >> testResizeCheckBox [
	testedInstance resizeCheckBox state: true.
	self deny: testedInstance image autoScale .
	testedInstance resizeCheckBox state: false.
		self assert: testedInstance image autoScale.
]
