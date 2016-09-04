LOCALE=ja
DEPEND=github.com/Masterminds/glide

build: init
	go run po2i18n/po2i18n.go -t web_static.json -o new_web_static.json web_static.po
	mv new_web_static.json platform/webapp/i18n/${LOCALE}.json
	go run po2i18n/po2i18n.go -t platform.json -o new_platform.json platform.po
	mv new_platform.json platform/i18n/${LOCALE}.json
	zip -r mattermost-i18n-${LOCALE}.zip platform
	
init: depend
	mkdir -p platform/webapp/i18n
	mkdir -p platform/i18n
	curl -o web_static.json https://raw.githubusercontent.com/mattermost/platform/master/webapp/i18n/en.json
	curl -o platform.json https://raw.githubusercontent.com/mattermost/platform/master/i18n/en.json
	curl -o web_static.po "http://translate.mattermost.com/export/?path=/${LOCALE}/mattermost/web_static.po"
	curl -o platform.po "http://translate.mattermost.com/export/?path=/${LOCALE}/mattermost/platform.po" -v

depend:
	go get  -v $(DEPEND)
	glide install
