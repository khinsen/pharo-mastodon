Class {
	#name : #MdnList,
	#superclass : #MdnEntity,
	#instVars : [
		'login'
	],
	#category : #'Mastodon-Core'
}

{ #category : #'instance creation' }
MdnList class >> login: aLogin json: aJson [
	^ self new 
		login: aLogin;
		json: aJson;
		yourself
]

{ #category : #accessing }
MdnList >> accounts [
	^ (self
		get: (self url / 'accounts')
		with: [ :request | 
			request authorizationBearer: self login accessToken ])
		collect: [ :each | 
			MdnAccount login: self json: each ]
]

{ #category : #inspecting }
MdnList >> gtAccountsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Accounts';
		priority: 1;
		items: [ self accounts ];
		column: 'Name' text: #displayName;
		column: 'Account' text: #acct;
		yourself
]

{ #category : #inspecting }
MdnList >> gtTootsFor: aView [
	<gtView>
	^ aView forward
		title: 'Toots';
		priority: 2;
		object: [ self timeline ];
		view: #gtTootsFor:;
		yourself
]

{ #category : #accessing }
MdnList >> id [
	^ self json at: #id
]

{ #category : #accessing }
MdnList >> login [
	^ login
]

{ #category : #accessing }
MdnList >> login: anObject [
	login := anObject
]

{ #category : #printing }
MdnList >> printOn: stream [ 
	super printOn: stream.
	stream << '(' << self title << ')'
]

{ #category : #accessing }
MdnList >> repliesPolicy [
	^ self json at: #'replies_policy'
]

{ #category : #'api timelines' }
MdnList >> timeline [
	^ MdnTimelineList login: self login list: self
]

{ #category : #accessing }
MdnList >> title [
	^ self json at: #title
]

{ #category : #accessing }
MdnList >> url [
	^ self login server urlApiLists / self id
]
