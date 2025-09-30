################################# Dependencies #################################
##                                                                            ##
## This Makefile relies on the following tools in order to function:          ##
##     pandoc:         https://pandoc.org/installing.html                     ##
##     rsync:     (Automatically comes with most distributions)               ##
##                                                                            ##
## Installed both using:                                                      ##
##                        make install_all_dependencies                       ##
##                                                                            ##
################################### Template ###################################
##                                                                            ##
## The template/template.html file dictates the structure for all webpages.   ##
##     $title$:            The title of each webpage;                         ##
##                  Set in the title section of each md file                  ##
##     $curdir$:  Orients path to be that of the template file                ##
##     $body$:     The body of each page; written in Markdown                 ##
##                                                                            ##
## Any and all changes to the template.html file will require a full rebuild! ##
##                                                                            ##
################################### IMPORTANT ##################################
##                                                                            ##
## All file and folder names must contain no whitespaces!                     ##
##                                                                            ##
############################ Build Source Settings  ############################

# Source path; markdown files location
src_path := md/

# Paths for all assets
asset_paths := assets/ css/

# The output build path
build_path := website/

# The template file to structure each web page
template_file := template/template.html

# Script path; for python files
script_path := py/

# The deployment zip file name
deploy_name := website.zip

############################# DO NOT TOUCH SECTION  ############################

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
.PHONY: install_all_dependencies \
		copy_all_assets_to_build_directory \
		create_build_directory \
		list \
		build \
		rebuild \
		clean \
		list

# Pattern rule to convert .md to .html, placing each output file into its
# corresponding subdirectory within the build directory
$(build_path)%.html : $(src_path)%.md
# Process all escape sequences in markdown files
	@python3 $(script_path)course_catalog_regex.py $<

# Convert each markdown file to standalone html files using a template
	@pandoc --from markdown+smart \
			--to html5 \
			--template $(template_file) \
			--variable=localdir:$(shell echo "$(dir $@)" \
			| sed 's:$(build_path):./:' \
			| sed 's:/\w*:\/..:g' \
			| sed 's:\/..$$::') \
			$< -o $@
# The variable flag is set, using regex to convert absolute path to local path

# Output a message to let the user know which documents have been updated
	@echo -n "created $(dir $@)$(ANSI_BOLD)$(notdir $@)$(ANSI_DEFAULT) "
	@echo "from $(dir $<)$(ANSI_BOLD)$(notdir $<)$(ANSI_DEFAULT)"

# Basic build rule; will execute all components of the build procedure
build: create_build_directory \
	   copy_all_assets_to_build_directory \
	   $(patsubst %,$(build_path)%, \
	   $(output_files))

# Basic rebuild rule; will remove current build and start from scratch
rebuild: clean build

# Create the build directory by copying the directory structure of the source
# directory
create_build_directory:
	@rsync -a --include '*/' --exclude '*' $(src_path). $(build_path)

# Copy all specified asset directories to the build directory
copy_all_assets_to_build_directory:
	@cp $(asset_paths) -r $(build_path)
	@echo "copied all assets to build directory"

# Remove the build directory and all files and subdirectories contained within 
clean:
	@rm -rf $(build_path)
	@echo "removed build directory and all contents within"

# Install all the tools required to use this Makefile
install_all_dependencies:
	apt install pandoc
	apt install rsync

# List all available options with the Makefile
list:
	@echo "\
$(ANSI_BOLD)build$(ANSI_DEFAULT)\
:\n\t\
build any out-of-date markdown files into their corresponding html pages"

	@echo "\
$(ANSI_BOLD)rebuild$(ANSI_DEFAULT)\
:\n\t\
rebuild every file of the entire website"

	@echo "\
$(ANSI_BOLD)create_build_directory$(ANSI_DEFAULT)\
:\n\t\
create the build directory, copying the file structure of the md directory"

	@echo "\
$(ANSI_BOLD)copy_all_assets_to_build_directory$(ANSI_DEFAULT)\
:\n\t\
copy all specified asset directories to the build directory"

	@echo "\
$(ANSI_BOLD)clean$(ANSI_DEFAULT)\
:\n\t\
remove the build directory and all files and subdirectories contained within"

	@echo "\
$(ANSI_BOLD)install_all_dependencies$(ANSI_DEFAULT)\
:\n\t\
install all the tools required to use the current Makefile"

	@echo "\
$(ANSI_BOLD)list$(ANSI_DEFAULT)\
:\n\t\
List all options available with the current Makefile"


################################################################################
