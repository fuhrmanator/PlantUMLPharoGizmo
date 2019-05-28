# PlantUMLPharoGizmo
Pharo support for PlantUML.

[![Demo video of prototype](http://img.youtube.com/vi/fHCcYSa6VhU/0.jpg?1)](https://www.youtube.com/watch?v=fHCcYSa6VhU "Demo of PlantUML Gizmo prototype in Pharo with Spec GUI")

### TODO: 

- add a Spec GUI similar to PlantText.com

## Example

### Simple class diagram

```smalltalk
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

"Get the Source back from a URL"
recoveredSource := serverUrl plantUrlStringToPlantSourceString.

self assert: recoveredSource equals: plantUMLSource.
```

![Class diagram](https://www.plantuml.com/plantuml/img/NOv12i9034LFC7S8kEXEzwwARhs0u2REX3eqpPGaWtXxeswaVFW4teEVqHpL-yB9vYehAYvW_cAArfetv8vvdhHrARbnKt15iK0a_cTbHhEjUYNczZnSwlJmtvs-7fnG8acQ4-Y7mawf7E5CkO8CP0uhsaswKEo7Itj88qc9rzu0)

### Mind map

```smalltalk
plantUMLSource := Character cr join: #('@startmindmap' '* Debian' '** Ubuntu' '*** Linux Mint' '*** Kubuntu' '*** Lubuntu' '*** KDE Neon' '** LMDE' '** SolydXK' '** SteamOS' '** Raspbian with a very long name' '*** <s>Raspmbc</s> => OSMC' '*** <s>Raspyfi</s> => Volumio' '@endmindmap').

codePart := plantUMLSource plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.
```

![Mind map](https://www.plantuml.com/plantuml/img/JOzD3e8m44PFq3lCkXilW8H4M06II3Hk1waw2PqIsggzlRJ6XDMyoPkVV8Lrk3XDF6gSXOHI3OGif8JpuDdvbIGqnFu3BR5BRUqtQiDrMS5HcRJTj6KLQs-cC5xhX4wXxlg89xHp_0DlSaz0UAabm6Ju0OnQfMEPpUEK7cxPpkQmpw7hsyDMXJlzrSLCNfCHXLfp_B9y0G00)
