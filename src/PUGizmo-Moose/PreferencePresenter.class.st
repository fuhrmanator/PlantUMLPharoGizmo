Class {
	#name : #PreferencePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'inputText'
	],
	#category : #'PUGizmo-Moose'
}

{ #category : #specs }
PreferencePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			'You can change colors and font of the drawing using the skinparam command.'
			withConstraints: [ :constraints | constraints height: self defaultFont height ];
		add: 'ex. skinparam backgroundColor transparent'
			withConstraints: [ :constraints | constraints height: self defaultFont height ];
		add: #inputText;
		yourself
]

{ #category : #example }
PreferencePresenter class >> open [ 
<example>
self new openDialogWithSpec 
]

{ #category : #initialization }
PreferencePresenter >> initializeWidgets [
	inputText := self newText autoAccept: true.
	self focusOrder add: inputText
]

{ #category : #initialization }
PreferencePresenter >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 42 @ 8 * (fontWidth @ rowHeight).
	aWindowPresenter title: self title
]

{ #category : #accessing }
PreferencePresenter >> preference [
	^ inputText text
]

{ #category : #accessing }
PreferencePresenter >> preference: aString [
	inputText text: aString
]

{ #category : #api }
PreferencePresenter >> title [ 
^'Preference'
]
