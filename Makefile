#-------------------------------------------------------------------------------
## This Makefile relies on "Pandoc", a command line tool to convert file
## formats.
##
## Pandoc can be found here: https://pandoc.org/installing.html
##

##
## All assets including the stylesheet must be declared in the template file
## using the $curdir$ variable to orient the file structure. For example: 
## 		<link rel="stylesheet" href="$curdir$/css/stylesheet.css">
## Is used to include the stylesheet.
##

##
## Any and all changes to the template.html file will require a full rebuild
##

##
## All file and folder names must contain no whitespaces!
##


#### Build Source Settings: ####

# Source path; markdown files location
src_path := md/

# The output build path
build_path := html/

# The template file to structure each web page
template_file := template/template.html

################################



##### DO NOT TOUCH SECTION: ####

# Styles for output
ANSI_DEFAULT := \033[0m
ANSI_BOLD := \033[1m
ANSI_FAINT := \033[2m

# Get the input files and remove their root directory (the source path)
input_files := $(patsubst \
				$(src_path)%, \
				%, \
				$(wildcard $(src_path)*.md) $(wildcard $(src_path)*/*.md))

# Get the output files by changing the extension of the inputs from .md to .html
output_files := $(patsubst %.md,%.html,$(input_files))

# Phony rule
.PHONY: create_build_path build rebuild clean

# Pattern rule to convert .md to .html, placing each output file into its
# corresponding subdirectory within the build directory
$(build_path)%.html : $(src_path)%.md
# Convert each markdown file to standalone html files with all resources
# embedded using a template
	@pandoc --from markdown+smart \
			--to html5 \
			--template $(template_file) \
			$< -o $@

# Output a message to let the user know which documents have been updated
	@echo -n "created $(dir $@)$(ANSI_BOLD)$(notdir $@)$(ANSI_DEFAULT) "
	@echo "from $(dir $<)$(ANSI_BOLD)$(notdir $<)$(ANSI_DEFAULT)"

# Basic build rule; will execute all components of the build procedure
build: create_build_path $(patsubst %,$(build_path)%, $(output_files))

# Basic rebuild rule; will remove current build and start from scratch
rebuild: clean build

# Create the build directory by copying the directory structure of the source
# directory
create_build_path:
	@rsync -a --include '*/' --exclude '*' $(src_path). $(build_path)

# Remove the build directory and all files and subdirectories contained within 
clean:
	@rm -rf $(build_path)
	@echo "removed build directory and all contents within"

################################