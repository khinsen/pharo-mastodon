Class {
	#name : #MdnTimelineList,
	#superclass : #MdnTimeline,
	#instVars : [
		'list'
	],
	#category : #'Mastodon-Core'
}

{ #category : #'api timelines' }
MdnTimelineList class >> login: aLogin list: aList [
	^ self new
		login: aLogin;
		list: aList;
		yourself
]

{ #category : #accessing }
MdnTimelineList >> list [
	^ list
]

{ #category : #accessing }
MdnTimelineList >> list: aList [
	list := aList
]

{ #category : #printing }
MdnTimelineList >> printOn: stream [ 
	super printOn: stream.
	stream << '(' << self list title << ')'
]

{ #category : #accessing }
MdnTimelineList >> url [
	^ self server urlApiTimelines / 'list' / self list id
]
