# PlantUMLPharoGizmo
Pharo support for PlantUML.

> Note: The GUI part of this project was initially done in Spec 2, which works best in Pharo 8. However, the baseline will load a GUI that works with Pharo 7. 

[![Demo video of prototype](http://img.youtube.com/vi/fHCcYSa6VhU/0.jpg?1)](https://www.youtube.com/watch?v=fHCcYSa6VhU "Demo of PlantUML Gizmo prototype in Pharo with Spec GUI")

### TODO: 

- drop-down menu of example diagrams

## Loading

```Smalltalk
Metacello new
  repository: 'github://fuhrmanator/PlantUMLPharoGizmo/src';
  baseline: 'PUGizmo';
  load.
```

## Example

### Class diagrams using a Moose Java model

One reason I wanted to get PlantUML working in Pharo was to use it with Moose. There's a utility method to generate PlantUML source for a Java model in Moose. **Prerequisite:** I generated an MSE file for the sample project [FactoryVariants](https://github.com/fuhrmanator/FactoryVariants) and loaded it in Moose.

```Smalltalk
| classes pUMLSource commaFlag |
classes := (MooseModel root first allClasses reject:#isStub) 
  select: [:c | c mooseName beginsWith: 'headfirst::designpatterns::factory::pizzaaf'].
pUMLSource := PUGizmo plantUMLSourceForMooseJavaClasses: classes.
key := pUMLSource asPlantUMLKey.
"using a local server"
serverUrl := 'http://localhost:8080/plantuml/img/', key .
imageMorph := (ZnEasy getPng: serverUrl asUrl) asAlphaImageMorph .
imageMorph layout: #scaledAspect.
w := imageMorph openInWindow.
w center; fitInWorld.
```

![Class diagram](https://www.plantuml.com/plantuml/svg/pLTDJ-Cm4BtdLrZz1rnzGfHbjGUW8jLAUvnrfhQ5lpHs4FJNh-iKk73fP2LpIvJCpFFulJVsTIv0PVPko5X408yvWS8H4n2KI4BAmTW91VfKteH7_nSf3rc1Gt4rE3mKKQ8WgqqHaoLKnSOms52G3ZMHs1Y4wM0f5oadp5Q71AL-35dA-aCjyIPbiiSZm47AtwYrnRmPb8ESBmpUkTdlew-mHvWLReJroQ77KBAuA54BPwzXQn0pyfPmHvZDre7FVFGjd5NzXzR9GIZyskVzOrM_1xAXikw_R1u7m09-TthT27mj6AOBQxTOLks5DEjhSqcxmvIGOh0ytZwTMWSXdhdFvswBPq4OKsMFCkkvozPzaorJzl68ePlkjyOgqB4nQApVS0q5Mm8MZ8S_lH6CpYgSFhN0tekF53mddBEX67qV7tvwxq2VydjZmvRcN6xZh5V8kOMp4DmuKC-FphxW2ZMkQS5Fe4h4VawsT9v7tLWV29s3ZgDW6QEyq7VXzXl5o_bdjP7_2ffmihNnTyj_AzpiotmyX7L8zJbXjSWzLb-XgcnUVyyJwdkszZ7KcrStprRFVKrx1rJlhX1wsyvoUk6Vmx_crt1TfNAwfVy3)

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

![Class diagram](https://www.plantuml.com/plantuml/svg/NOv12i9034LFC7S8kEXEzwwARhs0u2REX3eqpPGaWtXxeswaVFW4teEVqHpL-yB9vYehAYvW_cAArfetv8vvdhHrARbnKt15iK0a_cTbHhEjUYNczZnSwlJmtvs-7fnG8acQ4-Y7mawf7E5CkO8CP0uhsaswKEo7Itj88qc9rzu0)

### Mind map

```smalltalk
plantUMLSource := Character cr join: #('@startmindmap' '* Debian' '** Ubuntu' '*** Linux Mint' '*** Kubuntu' '*** Lubuntu' '*** KDE Neon' '** LMDE' '** SolydXK' '** SteamOS' '** Raspbian with a very long name' '*** <s>Raspmbc</s> => OSMC' '*** <s>Raspyfi</s> => Volumio' '@endmindmap').

codePart := plantUMLSource plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.
```

![Mind map](https://www.plantuml.com/plantuml/svg/JOzD3e8m44PFq3lCkXilW8H4M06II3Hk1waw2PqIsggzlRJ6XDMyoPkVV8Lrk3XDF6gSXOHI3OGif8JpuDdvbIGqnFu3BR5BRUqtQiDrMS5HcRJTj6KLQs-cC5xhX4wXxlg89xHp_0DlSaz0UAabm6Ju0OnQfMEPpUEK7cxPpkQmpw7hsyDMXJlzrSLCNfCHXLfp_B9y0G00)
