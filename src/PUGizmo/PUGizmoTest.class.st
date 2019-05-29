Class {
	#name : #PUGizmoTest,
	#superclass : #SpecTestCase,
	#instVars : [
		'plantUMLSource',
		'url'
	],
	#category : #PUGizmo
}

{ #category : #running }
PUGizmoTest >> classToTest [
	^PUGizmo 
]

{ #category : #setup }
PUGizmoTest >> setUp [
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
PUGizmoTest >> testChangeToImageButton [
	presenter text text: plantUMLSource.
	presenter changeToImageButton performAction.
	self assert: presenter imageURL text asString equals:url.
]

{ #category : #tests }
PUGizmoTest >> testChangeToTextButton [
	presenter imageURL text: url.
	presenter changeToTextButton performAction.
	self assert: presenter text text asString equals: plantUMLSource.
	
]

{ #category : #tests }
PUGizmoTest >> testManageButtons [
	self deny: presenter changeToImageButton isEnabled.
	self deny: presenter changeToTextButton isEnabled.
	presenter text text: plantUMLSource.
	self assert: presenter changeToImageButton isEnabled.
	presenter imageURL text: url.
	self assert: presenter changeToTextButton isEnabled
]
