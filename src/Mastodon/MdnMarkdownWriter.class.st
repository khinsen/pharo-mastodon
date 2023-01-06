Class {
	#name : #MdnMarkdownWriter,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'stream'
	],
	#category : #'Mastodon-Formatting'
}

{ #category : #'instance creation' }
MdnMarkdownWriter class >> onStream: aStream [
	^ self new
		stream: aStream;
		yourself
]

{ #category : #accessing }
MdnMarkdownWriter >> stream [
	^ stream
]

{ #category : #accessing }
MdnMarkdownWriter >> stream: anObject [
	stream := anObject
]

{ #category : #visiting }
MdnMarkdownWriter >> visitElement: anElement [
	| selector |
	selector := 'visitElementNamed', anElement localName, ':'.
	[
		self perform: selector asSymbol withArguments: { anElement }.
	] on: MessageNotUnderstood do: [ super visitElement: anElement ]
]

{ #category : #visiting }
MdnMarkdownWriter >> visitElementNameda: anElement [
	| url |
	url := anElement attributeAt: 'href'.
	stream << '['.
	super visitElement: anElement.
	stream << '](' << url << ')'
]

{ #category : #visiting }
MdnMarkdownWriter >> visitElementNamedb: anElement [
	stream << '**'.
	super visitElement: anElement.
	stream << '**'
]

{ #category : #visiting }
MdnMarkdownWriter >> visitElementNamedbr: anElement [
	stream cr
]

{ #category : #visiting }
MdnMarkdownWriter >> visitStringNode: aStringNode [
	^ stream << aStringNode string
]
