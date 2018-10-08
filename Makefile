install:
	xcodebuild | xcpretty

	killall Chai || true
	rm -rf /Applications/Chai.app
	cp -r build/Release/Chai.app /Applications

.PHONY: install
