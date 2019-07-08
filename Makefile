.PHONY: deploy
deploy:
	@echo 'Start deploying dotfiles...'
	@bash scripts/deploy.sh
	@echo 'Finish deploying dotfiles!!!'

.PHONY: init
init:
	@echo 'Start initializing...'
	@bash scripts/init.sh
	@echo 'Finish initializing!!!'
