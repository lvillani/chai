install:
	xcodebuild

	killall Theine || true
	rm -rf /Applications/Theine.app
	cp -r build/Release/Theine.app /Applications

.PHONY: install
