"
I represent a login (a connection) into a mastodon instance. 
"
Class {
	#name : #MdnLogin,
	#superclass : #MdnEntity,
	#instVars : [
		'server',
		'account'
	],
	#category : #'Mastodon-Core'
}

{ #category : #'accessing api' }
MdnLogin >> accessToken [
	^ self jsonAt: 'access_token'
]

{ #category : #accessing }
MdnLogin >> account [
	^ account ifNil: [ account := self verifyCredentials ]
]

{ #category : #accessing }
MdnLogin >> application [
	^ self server application
]

{ #category : #accessing }
MdnLogin >> bookmarks [
	^ (self
		get: self server urlApiBookmarks
		with: [ :request | 
			request authorizationBearer: self accessToken ])
		collect: [ :each | 
			MdnStatus login: self json: each ]
]

{ #category : #'accessing api' }
MdnLogin >> createdAt [
	^ DateAndTime fromUnixTime: (self jsonAt: 'created_at')
]

{ #category : #inspecting }
MdnLogin >> gtBookmarksFor: aView [
	<gtView>
	^ aView list
		title: 'Bookmarks';
		priority: 2;
		items: [ self bookmarks ];
		yourself
]

{ #category : #inspecting }
MdnLogin >> gtHomeTimelineFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Timeline';
		priority: 0;
		items: [ self timelineHome next ];
		column: 'Time' text: #createdAt;
		column: 'Author' text: [ :each | each originAccount displayName ];
		column: 'Account' text: [ :each | each originAccount acct ];
		yourself
]

{ #category : #inspecting }
MdnLogin >> gtListsFor: aView [
	<gtView>
	^ aView list
		title: 'Lists';
		priority: 1;
		items: [ self lists ];
		itemText: #title;
		yourself
]

{ #category : #accessing }
MdnLogin >> lists [
	^ (self
		get: self server urlApiLists
		with: [ :request | 
			request authorizationBearer: self accessToken ])
		collect: [ :each | 
			MdnList login: self json: each ]
]

{ #category : #api }
MdnLogin >> postStatus: aStringOrPostStatus [
	^ aStringOrPostStatus asMastodonPostStatus
		login: self;
		post
]

{ #category : #'accessing api' }
MdnLogin >> refreshToken [
	^ self jsonAt: 'refresh_token'
]

{ #category : #'accessing api' }
MdnLogin >> refreshToken: aString [
	^ self jsonAt: 'refresh_token' put: aString
]

{ #category : #'accessing api' }
MdnLogin >> scope [
	^ self jsonAt: 'scope'
]

{ #category : #accessing }
MdnLogin >> server [
	^ server
]

{ #category : #accessing }
MdnLogin >> server: anObject [
	server := anObject
]

{ #category : #'api timelines' }
MdnLogin >> timelineHashtag: aString [
	^ MdnTimelineHashtag login: self hashtag: aString
]

{ #category : #'api timelines' }
MdnLogin >> timelineHome [
	^ MdnTimelineHome login: self
]

{ #category : #'api timelines' }
MdnLogin >> timelinePublic [
	^ MdnTimelinePublic login: self
]

{ #category : #'accessing api' }
MdnLogin >> tokenType [
	^ self jsonAt: 'token_type'
]

{ #category : #api }
MdnLogin >> verifyCredentials [
	^ MdnAccount 
		login: self
		json: (self 
			get: (self server urlApiAccounts / 'verify_credentials')
			with: [ :request | request authorizationBearer: self accessToken ])
]
