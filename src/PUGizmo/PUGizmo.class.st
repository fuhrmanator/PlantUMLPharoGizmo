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
	#superclass : #Object,
	#category : #PUGizmo
}
