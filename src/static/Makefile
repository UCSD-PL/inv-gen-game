THIRD_PARTY_DEPS=bootstrap.min.css \
								 bootstrap.min.js \
								 bootstrap-theme.min.css \
								 jquery-1.12.0.min.js \
								 jquery.jsonrpcclient.js\
								 jquery.color-2.1.2.min.js\
								 jquery-ui-1.11.4\
								 notify.js\
								 ion.sound-3.0.7

all: $(THIRD_PARTY_DEPS) ts-files

typings:
	typings install

ts-files: typings
	tsc

bootstrap.min.css:
	wget https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css

bootstrap.min.js:
	wget https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js

bootstrap-theme.min.css:
	wget https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css

jquery-1.12.0.min.js:
	wget http://code.jquery.com/jquery-1.12.0.min.js

jquery.jsonrpcclient.js:
	wget https://raw.githubusercontent.com/Textalk/jquery.jsonrpcclient.js/master/jquery.jsonrpcclient.js

jquery.color-2.1.2.min.js:
	wget http://code.jquery.com/color/jquery.color-2.1.2.min.js

jquery-ui-1.11.4:
	wget http://jqueryui.com/resources/download/jquery-ui-1.11.4.zip
	unzip jquery-ui-1.11.4.zip
	rm jquery-ui-1.11.4.zip

notify.js:
	wget https://rawgit.com/notifyjs/notifyjs/master/dist/notify.js

ion.sound-3.0.7:
	wget http://ionden.com/a/plugins/ion.sound/ion.sound-3.0.7.zip
	unzip ion.sound-3.0.7.zip
	rm ion.sound-3.0.7.zip
	rm -r __MACOSX
	rm ion.sound-3.0.7/.DS_Store

clean:
	rm -r $(THIRD_PARTY_DEPS)
