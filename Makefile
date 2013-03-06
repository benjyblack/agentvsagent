REPORTER = spec
all: test

clean:
	rm -rf gen

test:
	./node_modules/mocha/bin/mocha --reporter $(REPORTER)

test-cov: lib-cov
	@$(MAKE) REPORTER=html-cov > gen/coverage.html

lib-cov:
	jscoverage hearts hearts-cov

stats:
	gitstats . gen/stats

setup:
	npm install
	brew install haskell-platform
	brew install thrift --with-haskell
	gem install thrift


.PHONY: test stats clean all
