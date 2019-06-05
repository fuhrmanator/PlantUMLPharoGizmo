Extension { #name : #ZnUrl }

{ #category : #'*PUGizmo' }
ZnUrl >> isValid [
	"This is not very precise - but it's better than nothing"
	^ '^(http|https)\:\/\/.+\..+$' asRegex matches: self asString
]

{ #category : #'*PUGizmo' }
ZnUrl >> isValidViaPerl [
	"Use LibC's perl to run a regex to validate the URL. The validation comes from https://github.com/segmentio/is-url/blob/master/index.js"
	| result outputFile command |
	outputFile := '/tmp/isValidURL_output.txt'.
	"The ugliness of running a perl command in a Bourne shell: one must escape $ and \, but within a regex, they must be double-escaped."
	command := 'perl -e "\$b=\"^(?:\\\w+:)?\\\/\\\/([^\\\s\\\.]+\\\.\\\S{2}|localhost[\\\:?\\\d]*)\\\S*\\\$\";" -e "\$a=\"' , self asString, '\";" -e "if (\$a=~/\$b/) {print ''true''} else {print ''false''};"'.
	
	result := LibC runCommand: command , ' > ' , outputFile.
	self assert: result = 0. 
	^ outputFile asFileReference contents lines first = 'true'.
]
