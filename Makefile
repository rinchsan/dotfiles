.PHONY: deploy
deploy:
	@echo 'deploying dotfiles...'
	@bash scripts/deploy.sh
	@echo 'deploy finished'

.PHONY: init
init:
	@echo 'initializing dotfiles...'
	@bash scripts/init.sh
	@echo 'initialize finished'
