# Seoul Theme Makefile

# 변수
EXTENSION_NAME := theme-seoul
PACKAGE_VERSION := $(shell node -p "require('./package.json').version")
VSIX_NAME := $(EXTENSION_NAME)-$(PACKAGE_VERSION).vsix
VSIX_PATH := $(CURDIR)/dist/$(VSIX_NAME)
EXTENSION_ID := $(shell node -p "require('./package.json').publisher + '.' + require('./package.json').name")
IDE ?= cursor

# Dancheong-inspired terminal palette
ANSI_RESET := \033[0m
ANSI_BOLD := \033[1m
ANSI_DIM := \033[2m
COLOR_CORAL := \033[38;5;203m
COLOR_SKY := \033[38;5;75m
COLOR_JADE := \033[38;5;78m
COLOR_GOLD := \033[38;5;220m
COLOR_WHITE := \033[38;5;255m
COLOR_GRAY := \033[38;5;246m
DIVIDER := ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 일부 환경의 `cursor`는 GUI를 백그라운드로 띄우는 래퍼일 수 있으므로
# Cursor는 실제 CLI를 우선 사용합니다. 자동 탐색이 안 되면 `IDE_BIN=/경로`로 지정할 수 있습니다.
# `CURSOR_CLI`는 Cursor 자체가 내부 명령 문자열로 사용할 수 있어 변수명에서 제외합니다.
ifeq ($(IDE),cursor)
IDE_NAME := Cursor
IDE_BIN := $(shell if [ -x /usr/share/cursor/bin/cursor ]; then \
	printf '%s' /usr/share/cursor/bin/cursor; \
	else command -v cursor 2>/dev/null; fi)
else ifeq ($(IDE),antigravity)
IDE_NAME := Antigravity
IDE_BIN := $(shell if [ -x /usr/share/antigravity/bin/antigravity ]; then \
	printf '%s' /usr/share/antigravity/bin/antigravity; \
	else command -v antigravity 2>/dev/null; fi)
else
$(error 지원하지 않는 IDE입니다: $(IDE) (cursor 또는 antigravity를 사용하세요))
endif

# `make version 0.1.15`, `make release 0.1.15`와 `VERSION=...` 형식을 지원합니다.
VERSION_GOAL := $(word 2,$(MAKECMDGOALS))
REQUESTED_VERSION := $(if $(VERSION),$(VERSION),$(VERSION_GOAL))

ifneq ($(filter version release,$(MAKECMDGOALS)),)
ifneq ($(VERSION_GOAL),)
.PHONY: $(VERSION_GOAL)
$(VERSION_GOAL):
	@:
endif
endif

# 대상
.PHONY: all install mod-upgrade version release package test publish publish-info dist clean help dryrun
.DEFAULT_GOAL := help


help: ## 이 도움말을 보여줍니다
	@printf '\n%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)$(DIVIDER)$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)  서울 테마 · Extension Toolkit$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_GRAY)$(ANSI_DIM)  전통의 색을 현대적인 에디터 경험으로$(ANSI_RESET)'
	@printf '%b\n\n' '$(COLOR_CORAL)$(ANSI_BOLD)$(DIVIDER)$(ANSI_RESET)'
	@printf '%b  %bmake %b[target]%b\n\n' '$(COLOR_WHITE)$(ANSI_BOLD)사용법$(ANSI_RESET)' '$(COLOR_SKY)$(ANSI_BOLD)' '$(COLOR_GOLD)' '$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_WHITE)$(ANSI_BOLD)명령$(ANSI_RESET)'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[38;5;75m● \033[1m%-18s\033[0m \033[38;5;246m%s\033[0m\n", $$1, $$2}' $(MAKEFILE_LIST)
	@$(MAKE) --no-print-directory publish-info

all: install package ## 의존성을 설치하고 확장 프로그램을 묶습니다

install: ## 필요한 모듈을 설치합니다
	@printf '\n%b\n' '$(COLOR_SKY)$(ANSI_BOLD)◆ Node.js 의존성을 설치합니다$(ANSI_RESET)'
	@npm install
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ 의존성 설치 완료$(ANSI_RESET)'

mod-upgrade: ## 모든 npm 의존성을 최신 버전으로 업그레이드합니다
	@printf '\n%b\n' '$(COLOR_GOLD)$(ANSI_BOLD)⬆ npm 의존성을 최신 버전으로 점검합니다$(ANSI_RESET)'
	@npx --yes npm-check-updates@latest --upgrade
	@npm install
	@npm rebuild @vscode/vsce-sign
	@npm install-scripts prune
	@npm install-scripts ls | grep -Fq 'No packages with unreviewed install scripts.' || { \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ 검토되지 않은 install script가 남아 있습니다.$(ANSI_RESET)'; \
		npm install-scripts ls; \
		exit 1; \
	}
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ 의존성 및 install script 검증 완료$(ANSI_RESET)'

version: ## 패키지 버전을 변경합니다 (예: make version 0.1.15)
	@if [ -z "$(REQUESTED_VERSION)" ]; then \
		printf '%b\n' '$(COLOR_GOLD)$(ANSI_BOLD)사용법$(ANSI_RESET)  $(COLOR_SKY)make version 0.1.15$(ANSI_RESET)'; \
		exit 2; \
	fi
	@printf '%b\n' '$(COLOR_GOLD)◆ 버전을 $(REQUESTED_VERSION)(으)로 변경합니다$(ANSI_RESET)'
	@npm version "$(REQUESTED_VERSION)" --no-git-tag-version --allow-same-version
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ 버전 변경 완료$(ANSI_RESET)'

release: ## 버전 태그를 푸시해 GitHub Release를 생성합니다 (예: make release 1.0.1)
	@if [ -z "$(REQUESTED_VERSION)" ]; then \
		printf '%b\n' '$(COLOR_GOLD)$(ANSI_BOLD)사용법$(ANSI_RESET)  $(COLOR_SKY)make release 1.0.1$(ANSI_RESET)'; \
		exit 2; \
	fi
	@if [ "$(PACKAGE_VERSION)" != "$(REQUESTED_VERSION)" ]; then \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ package.json 버전($(PACKAGE_VERSION))과 릴리스 버전($(REQUESTED_VERSION))이 다릅니다.$(ANSI_RESET)'; \
		exit 1; \
	fi
	@if [ -n "$$(git status --porcelain)" ]; then \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ 커밋되지 않은 변경이 있습니다. 먼저 커밋해 주세요.$(ANSI_RESET)'; \
		exit 1; \
	fi
	@if [ "$$(git branch --show-current)" != "main" ]; then \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ main 브랜치에서만 릴리스할 수 있습니다.$(ANSI_RESET)'; \
		exit 1; \
	fi
	@printf '\n%b\n' '$(COLOR_SKY)$(ANSI_BOLD)◆ origin/main과 릴리스 태그를 확인합니다$(ANSI_RESET)'
	@git fetch origin main --tags
	@if [ "$$(git rev-parse HEAD)" != "$$(git rev-parse origin/main)" ]; then \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ 현재 커밋이 origin/main과 일치하지 않습니다. 먼저 push 또는 pull해 주세요.$(ANSI_RESET)'; \
		exit 1; \
	fi
	@if git rev-parse --verify --quiet "refs/tags/v$(REQUESTED_VERSION)" >/dev/null; then \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ v$(REQUESTED_VERSION) 태그가 이미 존재합니다.$(ANSI_RESET)'; \
		exit 1; \
	fi
	@printf '%b\n' '$(COLOR_GOLD)◆ v$(REQUESTED_VERSION) 태그를 생성하고 GitHub에 푸시합니다$(ANSI_RESET)'
	@git tag -a "v$(REQUESTED_VERSION)" -m "Release v$(REQUESTED_VERSION)"
	@git push origin "v$(REQUESTED_VERSION)"
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ GitHub Release 워크플로가 시작되었습니다: v$(REQUESTED_VERSION)$(ANSI_RESET)'

package: ## .vsix 확장 프로그램을 만듭니다
	@printf '\n%b\n' '$(COLOR_SKY)$(ANSI_BOLD)◆ VSIX 패키지를 생성합니다$(ANSI_RESET)'
	@mkdir -p dist
	@npx vsce package --no-dependencies -o dist/$(VSIX_NAME)
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ 패키지 생성 완료$(ANSI_RESET)  $(COLOR_WHITE)dist/$(VSIX_NAME)$(ANSI_RESET)'
	@$(MAKE) --no-print-directory publish-info

test: package ## VSIX를 패키징하고 IDE에 설치합니다 (기본: cursor, IDE=antigravity 지원)
	@test -n "$(IDE_BIN)" && command -v "$(IDE_BIN)" >/dev/null 2>&1 || { \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ $(IDE_NAME) CLI를 찾을 수 없습니다.$(ANSI_RESET) $(COLOR_GRAY)IDE_BIN=/경로를 지정해 주세요.$(ANSI_RESET)'; \
		exit 1; \
	}
	@printf '%b\n' '$(COLOR_SKY)◆ $(IDE_NAME)에 $(EXTENSION_NAME) $(PACKAGE_VERSION)을 설치합니다$(ANSI_RESET)'
	@"$(IDE_BIN)" --install-extension "$(VSIX_PATH)" --force
	@"$(IDE_BIN)" --list-extensions --show-versions | \
		grep -Fqx "$(EXTENSION_ID)@$(PACKAGE_VERSION)" || { \
		printf '%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)✗ 확장 설치 결과를 확인하지 못했습니다: $(EXTENSION_ID)@$(PACKAGE_VERSION)$(ANSI_RESET)'; \
		exit 1; \
	}
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ $(IDE_NAME)에 설치 완료$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_GOLD)↻ Developer: Reload Window를 실행해 주세요.$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_CORAL)✦ Preferences: Color Theme에서 Seoul 테마를 선택할 수 있습니다.$(ANSI_RESET)'

publish: publish-info ## 수동 배포를 위한 마켓플레이스 URL을 표시합니다

publish-info:
	@printf '\n%b\n' '$(COLOR_CORAL)$(ANSI_BOLD)$(DIVIDER)$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_WHITE)$(ANSI_BOLD)  🚀 수동 배포 안내$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_GRAY)  생성된 VSIX 파일을 아래 관리 페이지에 업로드하세요.$(ANSI_RESET)'
	@printf '\n  %b◆ VS Code Marketplace%b\n' '$(COLOR_SKY)$(ANSI_BOLD)' '$(ANSI_RESET)'
	@printf '    %b%s%b\n' '$(COLOR_SKY)' 'https://marketplace.visualstudio.com/manage' '$(ANSI_RESET)'
	@printf '  %b◆ Open VSX Registry%b\n' '$(COLOR_GOLD)$(ANSI_BOLD)' '$(ANSI_RESET)'
	@printf '    %b%s%b\n' '$(COLOR_GOLD)' 'https://open-vsx.org/user-settings/extensions' '$(ANSI_RESET)'
	@printf '%b\n\n' '$(COLOR_CORAL)$(ANSI_BOLD)$(DIVIDER)$(ANSI_RESET)'

dist: package ## 빌드 파일을 서버에 올립니다 (huebie.com)
	@printf '\n%b\n' '$(COLOR_SKY)$(ANSI_BOLD)◆ huebie.com으로 VSIX 파일을 전송합니다$(ANSI_RESET)'
	@scp dist/$(VSIX_NAME) hue@huebie.com:/var/www/kr.lovema/seoul/dist/
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ VSIX 업로드 완료$(ANSI_RESET)'
	@printf '%b\n' '$(COLOR_GRAY)  미리보기 이미지는 web/app/public/preview에서 관리합니다.$(ANSI_RESET)'

clean: ## 빌드 결과물을 모두 지웁니다
	@printf '\n%b\n' '$(COLOR_GOLD)$(ANSI_BOLD)◆ 빌드 결과물을 정리합니다$(ANSI_RESET)'
	@rm -f dist/*.vsix
	@rm -rf out
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ 정리 완료$(ANSI_RESET)'
	# node_modules는 보통 남겨두지만, 아래 주석을 풀면 완전히 지울 수 있습니다
	# rm -rf node_modules

dryrun: ## 빌드가 잘 되는지 미리 확인합니다
	@printf '\n%b\n' '$(COLOR_GOLD)$(ANSI_BOLD)◇ 시험 빌드를 시작합니다$(ANSI_RESET)'
	@npm install
	@mkdir -p dist
	@npx vsce package --no-dependencies -o dist/$(VSIX_NAME)
	@printf '%b\n' '$(COLOR_JADE)$(ANSI_BOLD)✓ 시험 빌드 완료$(ANSI_RESET)  $(COLOR_WHITE)dist/$(VSIX_NAME)$(ANSI_RESET)'
