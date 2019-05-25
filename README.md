# PlantUMLPharoGizmo
Pharo support for PlantUML.

### TODO: 

- make it work with Streams rather than Strings.
- support decode and inflate
- add a Spec GUI similar to PlantText.com

## Example

### Simple class diagram

```smalltalk
codePart := ('@startuml' , String cr ,
'class Banana #yellow' , String cr ,
'@enduml') plantDeflateAndEncode.
serverUrl := 'https://www.plantuml.com/plantuml/img/', codePart.
(ZnEasy getPng: serverUrl) asMorph openInWindow.
```

![Class diagram](https://www.plantuml.com/plantuml/img/SoWkIImgAStDuKtEIImkLd1Ap0D21UNAr9oS_79UXzIy5A0a0000)

### Mind map

```smalltalk
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
```

![Mind map](https://www.plantuml.com/plantuml/img/JOzD3e8m44PFq3lCkXilW8H4M06II3Hk1waw2PqIsggzlRJ6XDMyoPkVV8Lrk3XDF6gSXOHI3OGif8JpuDdvbIGqnFu3BR5BRUqtQiDrMS5HcRJTj6KLQs-cC5xhX4wXxlg89xHp_0DlSaz0UAabm6Ju0OnQfMEPpUEK7cxPpkQmpw7hsyDMXJlzrSLCNfCHXLfp_B9y0G00)
