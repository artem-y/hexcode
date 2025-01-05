.PHONY: install
install:
	@INSTALLATION_PATH=$(if $(filter install, $(MAKECMDGOALS)), $(word 2, $(MAKECMDGOALS)), $(which hexcode)) ; \
	if [ -z "$${INSTALLATION_PATH}" ]; then \
		INSTALLATION_PATH=/usr/local/bin/hexcode ; \
	fi && \
	swift build -q -c release && \
	install .build/release/hexcode "$${INSTALLATION_PATH}" && \
	echo "Installed at $${INSTALLATION_PATH}" 
