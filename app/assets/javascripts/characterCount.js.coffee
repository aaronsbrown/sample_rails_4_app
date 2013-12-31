class CharacterCount

	constructor: ->
		@el = $('#char-count')
		
		@input = $('#micropost_content')
		
		@input.keyup =>
			@updateCharCount()
		
		@input.change =>
			@updateCharCount()

	updateCharCount: (e) =>
		remaining = 140 - @input.val().length
		@el.text(remaining)

$ ->
	new CharacterCount
