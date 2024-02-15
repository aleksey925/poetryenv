pre-commit-install:
	pip install pre-commit

lint:
	pre-commit run --all
