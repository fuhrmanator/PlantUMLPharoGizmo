# PlantUMLPharoGizmo
Pharo support for PlantUML.

> Note: The GUI part of this project was initially done in Spec 2, which works best in Pharo 8. However, the baseline will load a GUI that works with Pharo 7. 

> Note 2: Many people have requested support for PlantUML **without Moose**, so I made a fork. I only tested it in Pharo 9 (PRs are welcome to make it work in Pharo 8):

> Note 3: Have a look at https://github.com/kasperosterbye/PlantUMLBridge for a simpler version of the support in this tool.

[![Demo video of prototype](http://img.youtube.com/vi/fHCcYSa6VhU/0.jpg?1)](https://www.youtube.com/watch?v=fHCcYSa6VhU "Demo of PlantUML Gizmo prototype in Pharo with Spec GUI")

## Loading (requires Moose)

```Smalltalk
Metacello new
  repository: 'github://fuhrmanator/PlantUMLPharoGizmo/src';
  baseline: 'PUGizmo';
  load.
```

## Loading (without Moose, requires Pharo 9)

```Smalltalk
Metacello new
  repository: 'github://fuhrmanator/PlantUMLPharoGizmo:pharo9/src';
  baseline: 'PUGizmo';
  load.
```

## Example

### Class diagrams using a Moose Java model

One reason to get PlantUML working in Pharo was to use it with Moose, and there is now a Moose browser. **Prerequisite:** A generated MSE file for the sample project [FactoryVariants](https://github.com/fuhrmanator/FactoryVariants) was already loaded in Moose.

![Screenshot of Moose browser](https://user-images.githubusercontent.com/7606540/60876935-217c2680-a23d-11e9-8a3d-5f17149ed15a.png) 

Here's the SVG of the diagram shown in the screenshot above, rendered from the PlantUML source that you can copy from the browser and render at PlantUML.com:

![Class diagram](https://www.plantuml.com/plantuml/svg/pLPDQyCm3BtxLvZkiXrIsDMKKkWex38A6RkhYPgAndQGrR5sst-VqzAlTAS4skQGM8hpthFr53mA0YmhMwg0eXrO31Lac6853E9P6wCMbAD6MybQMxGpvA121YNgPrNYNBHupLGiHEV4c0bvfyAIN8rWzGooPS5-vVAnBoEUCBX8mUZaP5RaN4A1pSaFa-sbiX92qBq5GZud3c9CZe6A-B48iWl6p26BQjV6LBJPG4oC5uW1ftNKKz_g97nyKh-j44kmHxnzq1PjYbM5x1qT8CyphN7tSE9JON951CfM4kypM69y35uT2K596-HXZ0kKjrZsEAguhdezclclJlnfpE5sJOSeuddEaRilxXs3l31zRWaia6kBbfAjofqd9hjtDU9bjjv1Hf1kzld0eg2Z8K_2BMAB8kl1Jv9qw8ehKHxRvZg4pSww3kjPURlQK2U9RzzsdTdx_M5xMscZUuF1hc72SDZJjz1pyDmzg6aOigEanZ-mXPoZLMujvR_jlOE2dVRofPuHkhm-CFq1)

#### Programmatic usage

There's a utility method to generate PlantUML source for a Java model (see [this example](https://fuhrmanator.github.io/2019/07/29/AnalyzingJavaWithMoose.html)) in Moose. 

```Smalltalk
| classes pUMLSource key serverUrl imageMorph w |
classes := (MooseModel root first allClasses reject:#isStub) 
  select: [:c | c mooseName beginsWith: 'headfirst::designpatterns::factory::pizzaaf'].
pUMLSource := PUGizmo plantUMLSourceForMooseClasses: classes.

key := pUMLSource plantDeflateAndEncode.
serverUrl := 'http://www.plantuml.com/plantuml/png/', key .
imageMorph := (ZnEasy getPng: serverUrl asUrl) asAlphaImageMorph .
imageMorph layout: #scaledAspect.
w := imageMorph openInWindow.
w center; fitInWorld.
```

![Class diagram](https://www.plantuml.com/plantuml/svg/pLTDJ-Cm4BtdLrZz1rnzGfHbjGUW8jLAUvnrfhQ5lpHs4FJNh-iKk73fP2LpIvJCpFFulJVsTIv0PVPko5X408yvWS8H4n2KI4BAmTW91VfKteH7_nSf3rc1Gt4rE3mKKQ8WgqqHaoLKnSOms52G3ZMHs1Y4wM0f5oadp5Q71AL-35dA-aCjyIPbiiSZm47AtwYrnRmPb8ESBmpUkTdlew-mHvWLReJroQ77KBAuA54BPwzXQn0pyfPmHvZDre7FVFGjd5NzXzR9GIZyskVzOrM_1xAXikw_R1u7m09-TthT27mj6AOBQxTOLks5DEjhSqcxmvIGOh0ytZwTMWSXdhdFvswBPq4OKsMFCkkvozPzaorJzl68ePlkjyOgqB4nQApVS0q5Mm8MZ8S_lH6CpYgSFhN0tekF53mddBEX67qV7tvwxq2VydjZmvRcN6xZh5V8kOMp4DmuKC-FphxW2ZMkQS5Fe4h4VawsT9v7tLWV29s3ZgDW6QEyq7VXzXl5o_bdjP7_2ffmihNnTyj_AzpiotmyX7L8zJbXjSWzLb-XgcnUVyyJwdkszZ7KcrStprRFVKrx1rJlhX1wsyvoUk6Vmx_crt1TfNAwfVy3)

### Simple class diagram

```smalltalk
plantUMLSource := '@startuml
skinparam style strictuml
skinparam backgroundcolor transparent
skinparam classbackgroundcolor Yellow/LightYellow
class Banana
note right #red: Ceci n''est pas\nune banane. 
@enduml'.

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
plantUMLSource := '@startmindmap
* Debian
** Ubuntu
*** Linux Mint
*** Kubuntu
*** Lubuntu
*** KDE Neon
** LMDE
** SolydXK
** SteamOS
** Raspbian with a very long name
*** <s>Raspmbc</s> => OSMC
*** <s>Raspyfi</s> => Volumio
@endmindmap'.

codePart := plantUMLSource plantDeflateAndEncode.

serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.
```

![Mind map](https://www.plantuml.com/plantuml/svg/JOzD3e8m44PFq3lCkXilW8H4M06II3Hk1waw2PqIsggzlRJ6XDMyoPkVV8Lrk3XDF6gSXOHI3OGif8JpuDdvbIGqnFu3BR5BRUqtQiDrMS5HcRJTj6KLQs-cC5xhX4wXxlg89xHp_0DlSaz0UAabm6Ju0OnQfMEPpUEK7cxPpkQmpw7hsyDMXJlzrSLCNfCHXLfp_B9y0G00)
