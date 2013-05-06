REPORTER = list

BROWSERIFY ?= ./node_modules/browserify/bin/cmd.js
MOCHA ?= ./node_modules/.bin/mocha
SRC = index.js lib/ansi.js lib/character.js lib/csi.js lib/osc.js lib/sgr.js lib/term_buffer.js lib/term_diff.js lib/util.js

all: dist/terminal.js

dist:
	@echo "MKDIR      $@"
	@mkdir dist;

dist/terminal.js: $(SRC) node_modules dist
	@echo "BROWSERIFY $@"
	@$(BROWSERIFY) -s 'terminal'  $< > $@ \
		|| { rm $@; exit 1; }

test:
	@$(MOCHA) \
		--require test/common \
		--reporter $(REPORTER) \
		$(TESTS)

test-browser: dist/terminal.js node_modules
	@echo visit http://127.0.0.1:3000/
	@./node_modules/.bin/serve test/

clean:
	@echo "RM         dist"
	@rm -r dist || true

mrproper: clean
	@echo "RM         node_modules"
	@rm -r node_modules || true

.PHONY: test test-browser clean mrproper
