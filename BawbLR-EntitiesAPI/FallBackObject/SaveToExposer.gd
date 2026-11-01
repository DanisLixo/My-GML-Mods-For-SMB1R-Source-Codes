extends Node

@export var properties: Array[String] = ["original_id", "original_info"]
const base64_charset := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

func get_string(original := {}) -> String:
	var string = ""
	for i in properties:
		string += ","
		if original[i] is String:
			string += original[i].replace(",", "&")
		elif original[i] == "":
			string += "!!"
		
	return string
