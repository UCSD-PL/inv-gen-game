THIRD_PARTY_DEPS=bootstrap.min.css \
								 bootstrap.min.js \
								 bootstrap-theme.min.css \
								 jquery-1.12.0.min.js \
								 jquery.jsonrpcclient.js

all: $(THIRD_PARTY_DEPS)

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

clean:
	rm $(THIRD_PARTY_DEPS)
