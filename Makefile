# When some environment variables can meaningfully be set to an empty string,
# then allow for that by using '=' instead of ':='
# @see https://stackoverflow.com/a/33594470/712334 for code style and Packer support
# @see https://www.gnu.org/software/make/manual/html_node/Shell-Function.html

prefix := /usr/local
bin := archuro

install :
		cp -f bin/$(bin) $(prefix)/bin/$(bin)

uninstall :
		rm -f $(prefix)/bin/$(bin)

.PHONY: install uninstall

		