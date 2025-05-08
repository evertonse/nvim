push:
	 git add . && git commit -m "$$(date)${MSG}" && git push

.PHONY: push

