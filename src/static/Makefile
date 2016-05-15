THIRD_PARTY_DEPS=bootstrap.min.css \
								 bootstrap.min.js \
								 bootstrap-theme.min.css \
								 jquery-1.12.0.min.js \
								 jquery.jsonrpcclient.js\
								 jquery.color-2.1.2.min.js\
								 esprima.js\
								 jquery-ui-1.11.4\
								 help-icon.png
#								 crafty-min.js\

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

esprima.js:
	wget https://cdn.rawgit.com/jquery/esprima/2.7.1/esprima.js

#crafty-min.js:
#	wget https://github.com/craftyjs/Crafty/releases/download/0.7.0/crafty-min.js

jquery-ui-1.11.4:
	wget http://jqueryui.com/resources/download/jquery-ui-1.11.4.zip
	unzip jquery-ui-1.11.4.zip

help-icon.png:
	wget http://cseweb.ucsd.edu/~r1jha/images/help-icon.png

clean:
	rm -r $(THIRD_PARTY_DEPS) jquery-ui-1.11.4.zip*
