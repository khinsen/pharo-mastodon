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
MdnMarkdownWriter >> visitStringNode: aStringNode [
	^ stream << aStringNode string
]
