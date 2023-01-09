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

{ #category : #accessing }
MdnStatus >> contentAsMarkdown [
	^ String streamContents: [ :s |
		self parsedContent acceptNodeVisitor: (MdnMarkdownWriter onStream: s ).
		s cr.
		self mediaAttachments do: [ :each |
			s cr.
			each markdownOn: s] ]
]

{ #category : #'accessing api' }
MdnStatus >> createdAt [
	"The time the status was created"
	^ DateAndTime fromString: (self jsonAt: 'created_at')
]

{ #category : #'accessing api' }
MdnStatus >> displayedContent [
	| spoiler content |
	spoiler := self spoilerText.
	content := self content.
	spoiler ifNotEmpty: [
		^ '<b>Spoiler:</b> ', spoiler asXMLString, '<br/><br/>', content ].
	content ifNotEmpty: [ ^ content ].
	^ self reblog
		ifNil: [ '' ]
		ifNotNil: [ :r |
			String streamContents: [ :s |
				s << '<p><a href="' << self account url << '">'
					<< ((self account displayName ifEmpty: [ self account acct ]) asXMLString printString)
					<< '</a> boosted toot by '
					<< '<a href="' << r account url << '">'
					<< ((r account displayName ifEmpty: [ r account acct ]) asXMLString printString)
					<< '</a>:</p>'
					<< Character cr
					<< '<br/>'
					<< Character cr
					<< r displayedContent ] ].
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
MdnStatus >> gtContentFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		disableAsync;
		stencil: [
			(LeTextSnippet new string: self contentAsMarkdown)
				asPreviewElement ];
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
MdnStatus >> originAccount [
	^ self reblog
		ifNil: [ self account ]
		ifNotNil: [  :r | r account ]
]

{ #category : #accessing }
MdnStatus >> parsedContent [
	"Quick hack!"
	^ XMLDOMParser parse:
		'<body>',
			(self displayedContent copyReplaceAll: '<br>' with: '<br/>'),
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
	^ (self jsonAt: 'url')
		ifNil: [ self reblog ifNotNil: [ :r | r url ] ]
]

{ #category : #'accessing api' }
MdnStatus >> visibility [
	"One of: public, unlisted, private, direct"
	^ MdnVisibility fromString: (self jsonAt: 'visibility')
]
