Class {
	#name : #PUGizmo,
	#superclass : #Object,
	#category : #PUGizmo
}

{ #category : #api }
PUGizmo class >> changeToImage: source [
	^self
		loadUML:
			'https://www.plantuml.com/plantuml/img/'
				, source asPlantUMLKey
]

{ #category : #api }
PUGizmo class >> changeToText: aURL [
	^aURL  plantUrlStringToPlantSourceString
]

{ #category : #'as yet unclassified' }
PUGizmo class >> constructorsForMooseClass: mClass [
	"Find the constructors for a class"
	^ mClass methods select: [ :m | m isConstructor]

]

{ #category : #'as yet unclassified' }
PUGizmo class >> creatorsForMooseClass: mClass [
	"Find the creators for a class"

	| constructors creators |
	constructors := self constructorsForMooseClass: mClass.
	creators := constructors
		collect:
			[ :method | method incomingInvocations collect: [ :ii | ii sender parentType ] ].
	^ creators flattened
]

{ #category : #api }
PUGizmo class >> loadUML: aServerUrlText [
	| message image verification |
	image := nil.
	message := ''.
	verification := false.
	aServerUrlText
		ifNotEmpty: [ [ [ [ image := ZnEasy getPng: aServerUrlText.
			verification := true ]
				on: ZnHttpUnsuccessful
				do: [ :ex | 
					| errorMessage lineNumber |
					errorMessage := ex response headers
						at: 'X-Plantuml-Diagram-Error'.
					lineNumber := ex response headers
						at: 'X-Plantuml-Diagram-Error-Line'.
					message := 'Error: ' , errorMessage , ' on line '
						, lineNumber asString.
					image := message asMorph imageForm ] ]
				on: ConnectionTimedOut
				do: [ :ex | 
					message := '[Connection Timed Out] Please check your connection.'.
					image := message asMorph imageForm ] ]
				on: Error
				do: [ :ex | 
					message := '[This is not a usable URL]'.
					image := message asMorph imageForm ] ].
	^ {aServerUrlText.
	image.
	message.
	verification}
]

{ #category : #examples }
PUGizmo class >> open [
	<example>
	"Run the right version of the GUI"
	SystemVersion current major > 7 ifTrue: [ PUGizmoSpec2 open ] ifFalse: [ PUGizmoSpec1 open ]
]

{ #category : #api }
PUGizmo class >> plantUMLSourceForMooseJavaClasses: classes withRelationships: aCollection [
	"A utility method with Moose. e.g.:
	| classes pUMLSource commaFlag |
	classes := (MooseModel root first allClasses reject:#isStub) 
		select: [:c | c mooseName beginsWith: 'headfirst::designpatterns::factory::pizzaaf'].
	pUMLSource := PUGizmo plantUMLSourceForMooseJavaClasses: classes.
	key := pUMLSource asPlantUMLKey.
	serverUrl := 'http://localhost:8080/plantuml/img/', key .
	imageMorph := (ZnEasy getPng: serverUrl asUrl) asAlphaImageMorph .
	imageMorph layout: #scaledAspect.
	w := imageMorph openInWindow.
	w center; fitInWorld.	
	"

	"aCollection = {attributes . methods. inheritance . aggregation . create}"

	^ String
		new: 400
		streamContents: [ :stream | 
			self startUMLWithStream: stream.
			classes
				doWithIndex: [ :class :i | 
					self printNameWithClass: class withStream: stream.
					stream
						<< '{';
						cr.
					aCollection first
						ifTrue: [ self printAttributesWithClass: class withStream: stream ].
					aCollection second
						ifTrue: [ self printMethodsWithClass: class withStream: stream ].
					stream
						<< '}';
						cr ].

			"inheritance relations"
			aCollection third
				ifTrue: [ classes
						do: [ :class | self printInheritanceWithClass: class withStream: stream ] ].
			aCollection fourth
				ifTrue: [ classes
						do: [ :class | self printAggregationWithClass: class withStream: stream ] ].

			"creates relations"
			aCollection fifth
				ifTrue: [ classes
						do: [ :class | self printCreateWithClass: class withStream: stream ] ].

			"The end"
			stream
				<< '@enduml';
				cr ]
]

{ #category : #printing }
PUGizmo class >> printAggregationWithClass: aClass withStream: aStream [
	| aggregates |
	aggregates := aClass attributes collect: #declaredType.
	aggregates
		do: [ :agg | 
			aStream
				<< '"';
				<< agg mooseName;
				<< '"'.
			aStream << ' --o '.
			aStream
				<< '"';
				<< aClass mooseName;
				<< '"';
				cr ]
]

{ #category : #printing }
PUGizmo class >> printAttributesWithClass: aClass withStream: aStream [
	aClass attributes do:[ :attribute|
		
		aStream << attribute name;cr
		
	
		
		]
]

{ #category : #printing }
PUGizmo class >> printCreateWithClass: aClass withStream: aStream [
	| creators |
	creators := PUGizmo creatorsForMooseClass: aClass.
	creators
		do: [ :creator | 
			aStream
				<< '"';
				<< creator mooseName;
				<< '"'.
			aStream << ' ..> '.
			aStream
				<< '"';
				<< aClass mooseName;
				<< '"'.
			aStream
				<< ' : "<<creates>>" ';
				cr ].

]

{ #category : #printing }
PUGizmo class >> printInheritanceWithClass: aClass withStream: aStream [
						aClass superclassHierarchy
						do: [ :superClass  | 
							aStream
								<< '"';
								<< superClass mooseName;
								<< '"'.
							aStream << ' --|> '.
							aStream
								<< '"';
								<< aClass mooseName;
								<< '"';cr ] .
]

{ #category : #printing }
PUGizmo class >> printMethodsWithClass: aClass withStream: aStream [
	aClass methods
		do: [ :method | 
			aStream
				<< method name;
				<< '()' ;cr ]
]

{ #category : #printing }
PUGizmo class >> printNameWithClass: aClass withStream: aStream [
	aClass isInterface
		ifTrue: [ aStream << 'interface "' ]
		ifFalse: [ aStream << 'class "' ].
	aStream
		<< aClass mooseName;
		<< '"';cr
]

{ #category : #source }
PUGizmo class >> sourceSamples [
	^ {('Basic Use cases'
		->
			'oqbDAr4eoLSeoapFA558oInAJIx9pC_ZiWefIan9BR9IqDLLq73CIyofB4wDoGlABCxMH9KBACfC1iguf2RcQ7AXgLJGqxDJq0XBp2c5gL2mKh2noSnBpYbDIRMpuqBHJKWr0000').
	('Conceptual classes'
		->
			'FOon2iCm34HtVuNmMCYGDKEXI_z3ZKKjQjb1KeOGykzrQEXoxuPtPn-k2oeAc6-5UYhFlae9cHE1aEUMBCm5pU1P-9qTzW2GqAd3MKxKLLwalHoN-M1TclxKYjqvmZMEjmW3n37-dUdy9HkymVqB').
	('Software classes'
		->
			'NOx12i8m44Jl-nLBJth95vI2YA07Jtv0sQPR3AP9wUv14V_THcs9lGt3pBnnGNdio3Bke_TirSM0PUbckwhm2NKDJOoUAI2rxUQ0l0LZ3BnWoU5f4gHn_2zdWGlhQfZlog6LZ0pP2LCjczdAcOOL8Jd6SwTJeRZnGug40cf4HxAAkv_uycTxmhj-yDnpKFaKh2SHF99SKtB-bhNV').
	('Sequence diagram'
		->
			'ROv12i9034NtEKKkC1v0HD0Bk9QkuZJOq3HJPbB5splJBXHn4_Zl_nz-6SLcoZHXyPTolLcYBvD25uvuJZVSevWuK7Hva7DZq7YrJogHQs1WrVH9h1WWPcxguWDdsAAXbbPTIyPF04iraUK-E5pJWf4CIKl2UV7LAvWC2pyuauAASTa1Mu_D-_gvxKmZzFopeZk4yDUkx0q0').
	('Activity diagram'
		->
			'NOwn3i8m34JtV8N7P8GHXlu4Fs0L1wmaJcIxG_-UL21LOhcJxjv9PuLbe683yxtILENLjrQ3EQg7m1bYswhpqBwIMTSbWRz98EvaAG3ahcKQmEs1LYxtNmJuGfQpk1u5oVFBKpM2A3tzBKzuefpdYpu-').
	('State diagram'
		->
			'HOun3iCW34LtJk6vKjGzGwMEEKEQmG5Ih123m2JAxGjLgYuU_lEpVrw98oRS8ClfRPs9j9JDg_4sGVU0mTIq1s8InK4iUBi8XEK7XWe8VHLHhFg6rNfgeRtXmYw45UuGFPvWsgO4jYyUT_Ha89SvwqIpJPEwfFzJX_pkIhokrhnrwY6x8YOS_040').
	('OOA/D Use cases'
		->
			'VLB1QiCm3BtdAqHExQ65CTYf5CPWws3hGdFDHQHgOXhBGLR6kh5_d-sk9NHb5wFdf_SaFwn6Eu82HGrsC7Y26kFXMEb3OMkm4RGLJnvDCmZ1tVmMTk8ilA1Ov6dMqKv17OXfsjWlLAjndFczuHw35hmUmWYlOceTR3TYUgpts52P6g8mmrgTmCFWrLcI4qJVcZDwHGwQ4yeBF5XYhVX-qDQ9-SGulkAIvDtKb0FwCCTdqHwv2OFonI9fbykALnie3rx9fhvMncth4C0JCHHlPGvV6PpNWjaC9eMucho74ZkQHlAuv5NkT-Nhkh7f2daRHcz81s5_QVkN7Hl_huqrF7EyFjUH24-6YwNYTKpiEp3ib68owvi003ibOLIA850fQjWvIMJuDBOVGaT4FgKAAUY0YRV9Aml6C9z7lrQEnGy0').
	('Domain model'
		->
			'NP2_JiD03CRtF8NL2P0IKJOoTAbKWTIXAYkBctDRgxcxSdP04KBY8NX2dWGdeN-Niy_-VVOdoux37XDw46rhiZTnfOslioqx0a-wZKw63_czjbRoAqgIAQln2qpAM8EB7Zc0Zuxgt-yVX7UMfglRD8u1K_iQRcQyQHB1O_40wnGzp35v3BTPLQC8l61DCkT0pqeUFZE0jmQ3hMcphpEaxpXKig3iwTXSOEifQDz77vkW9vt6D0ZHkKGYbWNijPTRH_T5CHv1ddYprHn6blVr4fPKnUGa5-Fpk8R9jN9S57UcTF4Z3CBUR0dJ6DHEGowt-qoo0RuYEtjb5whTWHiiTzqZs2zOqeP5ATdafzW8oR-J0JtpVGPESQzsU9V7S46V71nkLrh6Bb-rCFa3').
	('System Sequence Diagram'
		->
			'LOxBQiCm44Nt-eeXAnlilfR1UDDG29GIyBBjOf0dyH1BSZLZKlzznw4FkX58zznx96UE4sOC8BgCP6TchtCOdRBQlUjsS4mP41fk3pbv4e4EHsfkkGNn535pUel54v_cJ71_T_C0nvm2F6CE64k7Ngs_sJwY34nv0oZWdJcLFKyOrR9k4QLmZSJvkXNOGi0plT1bTRanfGbUGp816oZl3hufYafvRs_56knt5NpCjicwbCOqTRr2FOdFF2cdM84cnT5Hx65TTRyx_MegIlTJkd9mOHr0yPF-_Uk0Ip1pWI7DKVywVi1u8kXdgY2J9tD-0G00').
	('Use-case realization with GRASP'
		->
			'TL9VIoD137-VJn5yEi4AlXmYKZWAWj0xHC-tliHfkXkSpIwJh7M__MMcrgt2lGoPJFBxauc-iWoOiGErAP6VcQEDNGh6vlSdz0Db2zOIn3ubYiQzGCo49TZ87JTZ9hYwllm92_Wr36bYQU3vzxhsFQ0PPL5ucM2LaHjOO-vGWhCQHnvG3Cvk7gbXzS8pG8KSf3U2H3k3VWSPRWxTJjddZHJOLI-MYvmCOR4i5Hs-qX_Q5y41NUGREiG7KkQc_OGwKXqya09kfDgSERw9AwzLc8P3ZmTviLYgenqICwE6BVsNNiC9oKKTRfXb250ts0JXTD0_T8njuSO0QzTz3lkMFRFdb0BG6ucDcD84RP-seKBgceNkZRe0B6eeaJIG3ws8-MOjiTLItKX1l_tIlwoc4nzTUwHkE_7i-_EZ0lnjMO7UAOvLk0uKUSUnhWdu4tT3Ol9Dwk75RU_PMfQFlNAPUOm-b3AbageVSbG_Yp-PhVu3').
	('Adapter class structure'
		->
			'PKux3i8m3DrzYgTECD0JL9KgPZOkO5938v8sIjoX0kvEr0z2wcBPx-lqj7tWo1v99oTvHcjqz8uwsmh41vtWnTya9bAhMTAq75GY6SSfeJWxAxqMu0H3ji_CdOtWol4XYghwGNMD5-aCNqIxeJqSwREcB9cI1G0l-qvJhCLpLRCPPyi-5MMzla0DoZ6KxxzxE6s5z0K0').
	('Adapter example class structure'
		->
			'dP112i9034NtSuhWocuyWHIAY0WYeYU8qwY3pNJ8f69Hx-wqg1j5q4q8_oN_XyIZym456QAs5QKgpch3bJcuae0uQ0jCl2M9HfscaQB4e2Gmd9wHGn9sKZCiK1XzPfnFR8UMO5vOMpTUdTy_LyRZ5yvpk9XGHrsJ9NV2RKN3YL3fT8KjazUifnjCUbSoSpEsmXXXi2bMRzO3m0WTU0nrxTy1Co7KPIrw8F6VesRBuXdLjRz7cVx2KHD6r_pJgqnl-uNV0G00').
	('Adapter example call sequence'
		->
			'NKynRiCm3Dpv2i9JCjGFoD32MuS2DUfyW90PHuX5gH8TsBylxGQ8aONWyUvuPBbvIPGfOD5bPAlPEvt22EhLSDDJKivO-7TYSOmyKqX67Bue1v8Zc5kzyub4iJhzyE2B6IgaWlc5_DYcyMNQDMtZN9n4lGoFl4r8yFQE6KyOwCOjBO55WPpwEodRyep6H-Fhklu7P235eXsDV2XMZayzWSkyDbjYjzYLeGA9woe_N1NZnVo0s7qtBSQxFMtWytnkWQN7LGYqXkpzbZVFC_IyYzc137y0').
	('Observer class structure'
		->
			'HOiv3i90303xVOML2WhoWcWR7a11I-COHrdOIxQ3505_9q89DDFCZDv3hYYOG6sEl502sPIY6yELWLEr6HAddaKTHLI5yzJVc0oU3isGnjtUlLTrwfNbmG9T5xAn34Zi_LBcOc6Ol-MsbyClN-_cM3896r_oPXf01IgE2hHJRL_-_tm0').
	('Observer sequence'
		->
			'TSox3eCm30NGFLyHiJDqPUZIgLC7rYuX670R9yWnGVnzquT4GUrYoJxNDzxHZuODwIYBWpmPhKpar80jQA1H5ar03N1KEIXeSJHUT56TWXSEpW4NsaHjTrnFpGsil8osbX3cGtNrboO2fyz_KiOA9YEGgsnv95rfEnZVGotvk2efAeyfgm-2tR92KkaD32sRUGVFlXxaxBlmtTN2xoNzNJOngnu0').
	('Reactor classes'
		->
			'JP0nZy8m38Nt_0ehKnawtCfmonK9bbjOaL183OqkSQhOvQXG__ibj9owH8g_z-ndyu-ZtYGJW6NqcD_ah0p1gywr21Xw6I5Wk61YPIuP6okWTtSaWRsXrcFIO1XsUtYgvrinGVTYPop2IiOUDsjwGpdFYcgZ9cMzOGRz5Sac53pHg_-9_WVWGv3QCcNHpkHjF8vaknGf3baoMniCWnVNUtmi2O-x9aTaz6XbFVL0JfmH5maQnxqHsosEGp6i5-7iItXpB9YM_AdgIYt4Ewuhayfc_Q6X_WJzhSjvjijDyY7ph_PubGpdHJAClyIgPAo7VbsdAExga4l3kisg38ji2mCZ_m40').
	('Reactor sequence'
		->
			'LP1DQiGm38NtFeMOLGRQ760MtRI5zWw1e2WY8yPHWgrEcTjN-UaGRupzUE_fa_DDTCQ48sHxHFOp2TdF68Eh9YGpgi68eeLm8eonGxfT6dsVb18RD_fvPxL6lr3xoEa4c86wClUjOe8capRw8Nb6e-jkbRwmRYqv89dSqNY3y4dBtRtB4rxV_0eNKFujXSI3PEFKNZUOwX_u1NYXREqnypcurnFKUM9WsytLETHr3Uisi4gY0unJp-1wEMTBj6jdzk2JrWbxBjctOVjUdiqScQmgA8vzrP7qMUK_UYZsLmX_')}
]

{ #category : #printing }
PUGizmo class >> startUMLWithStream: aStream [
	aStream
		<< '@startuml';
		cr.
	"Automatic package generation using Moose names"
	aStream
		<< 'set namespaceSeparator ::';
		cr.
	"Don't show UML attributes/methods if they're empty"
	aStream
		<< 'hide empty members';
		cr.
	"Scale down the diagram"
	aStream
		<< 'scale 1';
		cr.
	"Tends to generate a diagram that is longer rather than wider"
	aStream
		<< 'left to right direction';
		cr.
]
