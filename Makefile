.PHONY: install
install:
	swift build -q -c release
	install .build/release/hexcode /usr/local/bin/hexcode

