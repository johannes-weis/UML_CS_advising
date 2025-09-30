# COMP.4510 => [COMP.4510](https://www.uml.edu/catalog/courses/COMP/4510){target="_blank"}

import re
import fileinput
import sys

regex=r"\\[A-Z]{2,4}\.\d{4}L?"

def toCatalog(str):
	"""
	Convert a string containing a course in the format SUBJ.#### to a Markdown
	link to the official university catalog page for that course.
	
	:param      str:  The input string
	:type       str:  String
	
	:returns:   A string containg a hyperlink to the offical university catalog
	            page for the input.
	:rtype:     String
	"""

	# If the input string is formatted incorrectly than return the string
	if (re.search(regex, str) == None):
		return str

	# Get the substring which is the subject of the course
	subj = re.search(r"[A-Z]{2,4}", str).group()
	# Get the substring which is the number of the course
	num = re.search(r"\d{4}L?", str).group()

	# Return the hyperlink made from the input information
	return f"[{subj}.{num}](https://www.uml.edu/catalog/courses/{subj}/{num}){{target=\"_blank\"}}"

def lineCatalog(line):
	# Get the text surrounding every match
	outside = re.split(regex, line)

	# Get the text inside every match
	inside = re.findall(regex, line)

	# Reset the line string
	line = str()

	# Recombine the strings, editing each match
	i = 0
	for match in inside:
		line += outside[i]
		line += toCatalog(match)
		i += 1
	line += outside[i]

	# Return the line (edited)
	return line

def main():
	# For each file passed to the script
	for file in sys.argv[1:]:
		# Get each line of the current file
		for line in fileinput.FileInput(files=(file), inplace=1):
			# Run the regex over the 
			print(lineCatalog(line), end='')
		fileinput.close()

if __name__ == '__main__':
	main()