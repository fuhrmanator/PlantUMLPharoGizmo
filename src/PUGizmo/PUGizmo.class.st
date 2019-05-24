"
""I represent the abstraction of using PlantUML inside Pharo...

Here's an example: ""

codePart := ('@startuml' , String cr ,
'class Banana #yellow' , String cr ,
'@enduml') plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.


""Mind map""

codePart := ('@startmindmap' , String cr,
'* Debian' , String cr,
'** Ubuntu' , String cr,
'*** Linux Mint' , String cr,
'*** Kubuntu' , String cr,
'*** Lubuntu' , String cr,
'*** KDE Neon' , String cr,
'** LMDE' , String cr,
'** SolydXK' , String cr,
'** SteamOS' , String cr,
'** Raspbian with a very long name' , String cr,
'*** <s>Raspmbc</s> => OSMC' , String cr,
'*** <s>Raspyfi</s> => Volumio' , String cr,
'@endmindmap') plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.

"
Class {
	#name : #PUGizmo,
	#superclass : #Object,
	#category : #PUGizmo
}
