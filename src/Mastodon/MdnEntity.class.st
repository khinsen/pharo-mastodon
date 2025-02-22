"
I represent a mastodon entity. 
Entities are any kind of input/output that can traverse the mastodon api.
"
Class {
	#name : #MdnEntity,
	#superclass : #Object,
	#traits : 'TMdnRequest',
	#classTraits : 'TMdnRequest classTrait',
	#instVars : [
		'json'
	],
	#category : #'Mastodon-Core'
}

{ #category : #'instance creation' }
MdnEntity class >> json: aDictionary [
	^ self new json: aDictionary
]

{ #category : #inspecting }
MdnEntity >> gtActionWebBrowseFor: anAction [
	<gtAction>
	|  button |
	^ self url
		ifNil: [ anAction noAction ]
		ifNotNil: [ :url |
			anAction explicit stencil: [
			button := BrButton new.
			button
				aptitude: BrGlamorousButtonWithIconAptitude;
				action:  [ WebBrowser openOn: url ];
				icon: BrGlamorousIcons go asElement;
				label: 'Open in OS' translated ] ]
]

{ #category : #accessing }
MdnEntity >> gtItemsFor: aView [
	<gtView>
	^ aView forward
		title: 'Items';
		priority: 5;
		object: self json;
		view: #gtItemsFor:;
		yourself
]

{ #category : #accessing }
MdnEntity >> json [
	^ json
]

{ #category : #accessing }
MdnEntity >> json: anObject [
	json := anObject
]

{ #category : #accessing }
MdnEntity >> jsonAt: aString [
	^ self json at: aString
]

{ #category : #accessing }
MdnEntity >> jsonAt: aString ifAbsent: aBlock [
	^ self json 
		at: aString
		ifAbsent: aBlock
]

{ #category : #accessing }
MdnEntity >> jsonAt: aString ifAbsentPut: aBlock [
	^ self json 
		at: aString
		ifAbsentPut: aBlock
]

{ #category : #accessing }
MdnEntity >> jsonAt: aString put: anObject [
	^ self json 
		at: aString
		put: anObject
]

{ #category : #accessing }
MdnEntity >> url [
	^ self json at: #url ifAbsent: [ nil ]
]
