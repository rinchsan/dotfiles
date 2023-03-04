.PHONY: deploy
deploy:
	bash etc/scripts/deploy.sh

.PHONY: init
init:
	bash etc/scripts/init.sh

.PHONY: lint
lint:
	bash etc/scripts/lint.sh
