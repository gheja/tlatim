extends Control

func set_text(s: String):
	$Foreground/RichTextLabel.bbcode_text = "[center]" + s.replace(" ", "  ") + "[/center]"
