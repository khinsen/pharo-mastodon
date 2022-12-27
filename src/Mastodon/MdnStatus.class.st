"
I represent a mastodon status.

https://docs.joinmastodon.org/entities/Status/
"
Class {
	#name : #MdnStatus,
	#superclass : #MdnEntity,
	#instVars : [
		'login'
	],
	#category : #'Mastodon-Core'
}

{ #category : #'instance creation' }
MdnStatus class >> login: aLogin json: aJson [
	^ self new 
		login: aLogin;
		json: aJson;
		yourself
]

{ #category : #'accessing api' }
MdnStatus >> account [
	"The Account which posted the status"
	^ MdnAccount login: self login json: (self jsonAt: 'account')
]

{ #category : #accessing }
MdnStatus >> accountName [
	^ self account acct
]

{ #category : #'accessing api' }
MdnStatus >> application [
	"Application from which the status was posted"
	^ MdnApplication json: (self jsonAt: 'application')
]

{ #category : #accessing }
MdnStatus >> applicationName [
	^ (self jsonAt: 'application') at: 'name'
]

{ #category : #'accessing api' }
MdnStatus >> content [
	"Body of the status; this will contain HTML (remote HTML already sanitized)"
	^ self jsonAt: 'content'
]

{ #category : #'accessing api' }
MdnStatus >> contentOrReblogContent [
	| content |
	content := self jsonAt: 'content'.
	content ifNotEmpty: [ ^ content ].
	^ self reblog
		ifNil: [ '' ]
		ifNotNil: [ :r |
			String streamContents: [ :s |
				s << '<p>' << self account displayName << ' boosted:</p>'
					<< Character cr
					<< r contentOrReblogContent ] ].
]

{ #category : #'accessing api' }
MdnStatus >> createdAt [
	"The time the status was created"
	^ DateAndTime fromString: (self jsonAt: 'created_at')
]

{ #category : #'accessing api' }
MdnStatus >> emojis [
	"An array of Emoji"
	^ (self jsonAt: 'emojis') collect: [ :each | MdnEmoji json: each ]
]

{ #category : #'accessing api' }
MdnStatus >> favourited [
	"Whether the authenticated user has favourited the status"
	^ self jsonAt: 'favourited'
]

{ #category : #'accessing api' }
MdnStatus >> favouritesCount [
	"The number of favourites for the status"
	^ self jsonAt: 'favourites_count'
]

{ #category : #accessing }
MdnStatus >> gtActionWebBrowseFor: anAction [
	<gtAction>
	|  button |
	^ self urlOrReblogUrl
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
MdnStatus >> gtContentFor: aView [
	<gtView>
	| content |
	content := self contentOrReblogContent.
	content ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Content';
		priority: 1;
		object: content;
		view: #gtStringFor:;
		yourself
]

{ #category : #gtinspector }
MdnStatus >> gtDisplayString [
	^ self account acct, ' at ', self createdAt asLocalStringYMDHM
]

{ #category : #gtinspector }
MdnStatus >> gtInspectorStatusIn: composite [
	<gtInspectorPresentationOrder: 0>  
	 
	composite text
		title: self gtDisplayString;
		display: self content
]

{ #category : #'accessing api' }
MdnStatus >> id [
	"The ID of the status"
	^ self jsonAt: 'id'
]

{ #category : #'accessing api' }
MdnStatus >> inReplyToAccountId [
	"null or the ID of the account it replies to"
	^ self jsonAt: 'in_reply_to_account_id'
]

{ #category : #'accessing api' }
MdnStatus >> inReplyToId [
	"null or the ID of the status it replies to"
	^ self jsonAt: 'in_reply_to_id'
]

{ #category : #'accessing api' }
MdnStatus >> language [
	"The detected language for the status, if detected"
	^ self jsonAt: 'language'
]

{ #category : #accessing }
MdnStatus >> login [
	^ login
]

{ #category : #accessing }
MdnStatus >> login: anObject [
	login := anObject
]

{ #category : #'accessing api' }
MdnStatus >> mediaAttachments [
	"An array of Attachments"
	^ (self jsonAt: 'media_attachments') collect: [ :each | MdnAttachment json: each ]
]

{ #category : #'accessing api' }
MdnStatus >> mentions [
	"An array of Mentions"
	^ (self jsonAt: 'mentions') collect: [ :each | MdnMention json: each ]
]

{ #category : #'accessing api' }
MdnStatus >> muted [
	"Whether the authenticated user has muted the conversation this status from"
	^ self jsonAt: 'muted'
]

{ #category : #accessing }
MdnStatus >> parsedContentOrReblogContent [
	"Quick hack!"
	^ XMLDOMParser parse:
		'<body>',
			(self contentOrReblogContent copyReplaceAll: '<br>' with: '<br/>'),
			'</body>'
]

{ #category : #printing }
MdnStatus >> printOn: stream [
	super printOn: stream.
	stream << '(' << self createdAt asString << ':' << self content
]

{ #category : #'accessing api' }
MdnStatus >> reblog [
	"null or the reblogged Status"
	^ (self jsonAt: 'reblog') 
		ifNotNil: [ :aJson | MdnStatus login: self login json: aJson ] 
]

{ #category : #'accessing api' }
MdnStatus >> reblogged [
	"Whether the authenticated user has reblogged the status"
	^ self jsonAt: 'reblogged'
]

{ #category : #'accessing api' }
MdnStatus >> reblogsCount [
	"The number of reblogs for the status"
	^ self jsonAt: 'reblogs_count'
]

{ #category : #'accessing api' }
MdnStatus >> sensitive [
	"Whether media attachments should be hidden by default"
	^ self jsonAt: 'sensitive'
]

{ #category : #'accessing api' }
MdnStatus >> spoilerText [
	"If not empty, warning text that should be displayed before the actual content"
	^ self jsonAt: 'spoiler_text'
]

{ #category : #'accessing api' }
MdnStatus >> tags [
	"An array of Tags"
	^ (self jsonAt: 'tags') collect: [ :each | MdnTag json: each ]
]

{ #category : #'accessing api' }
MdnStatus >> uri [
	"A Fediverse-unique resource ID"
	^ self jsonAt: 'uri'
]

{ #category : #'accessing api' }
MdnStatus >> url [
	"URL to the status page (can be remote)"
	^ self jsonAt: 'url'
]

{ #category : #'accessing api' }
MdnStatus >> urlOrReblogUrl [
	^ self url ifNil: [ self reblog ifNotNil: [ :r | r url ] ]
]

{ #category : #'accessing api' }
MdnStatus >> visibility [
	"One of: public, unlisted, private, direct"
	^ MdnVisibility fromString: (self jsonAt: 'visibility')
]
