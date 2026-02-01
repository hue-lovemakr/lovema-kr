# Seoul Theme Makefile

# 변수
EXTENSION_NAME := theme-seoul
VERSION := $(shell node -p "require('./package.json').version")
VSIX_NAME := $(EXTENSION_NAME)-$(VERSION).vsix

# 대상
.PHONY: all install package publish dist clean help dryrun


help: ## 이 도움말을 보여줍니다
	@echo '사용법: make [target]'
	@echo ''
	@echo '대상:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: install package ## 의존성을 설치하고 확장 프로그램을 묶습니다

install: ## 필요한 모듈을 설치합니다
	npm install

package: ## .vsix 확장 프로그램을 만듭니다
	mkdir -p dist
	npx vsce package -o dist/$(VSIX_NAME)
	@echo ''
	@echo '-------------------------------------------------------'
	@echo '📦 패키지가 성공적으로 만들어졌습니다: dist/$(VSIX_NAME)'
	@echo '🚀 이 파일을 마켓플레이스에 직접 올려주세요:'
	@echo '👉 https://marketplace.visualstudio.com/manage'
	@echo '-------------------------------------------------------'

publish: ## 마켓플레이스에 배포합니다 (토큰 필요)
	npx vsce publish

dist: package ## 빌드 파일과 미리보기 그림을 서버에 올립니다 (huebie.com)
	@echo '-------------------------------------------------------'
	@echo '📤 dist/$(VSIX_NAME) 파일을 huebie.com 서버에 올리는 중...'
	scp dist/$(VSIX_NAME) hue@huebie.com:/var/www/kr.lovema/seoul/dist/
	@echo '📤 미리보기 그림들을 huebie.com 서버에 올리는 중...'
	scp -r preview hue@huebie.com:/var/www/kr.lovema/seoul/
	@echo '✅ 모두 올라갔습니다!'
	@echo '-------------------------------------------------------'

clean: ## 빌드 결과물을 모두 지웁니다
	rm -f dist/*.vsix
	rm -rf out
	# node_modules는 보통 남겨두지만, 아래 주석을 풀면 완전히 지울 수 있습니다
	# rm -rf node_modules

dryrun: ## 빌드가 잘 되는지 미리 확인합니다
	@echo "--- 시험 삼아 빌드 시작 ---"
	npm install
	mkdir -p dist
	npx vsce package -o dist/$(VSIX_NAME)
	@echo "--- 빌드 확인 완료: dist/$(VSIX_NAME) 만들어짐 ---"
