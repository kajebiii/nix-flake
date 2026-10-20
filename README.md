# nix-flake

`kajebiii.lab`은 개인 로그인 정보와 데이터를 넣지 않는 AI 작업 전용 macOS 환경입니다. nix-darwin과 Home Manager로 설정을 관리하고, 처음 추가할 애플리케이션과 도구는 아래 여덟 개로 제한합니다.

## 설치 대상

| Homebrew 패키지 | 용도 |
|---|---|
| `codex` | Codex CLI |
| `claude-code@latest` | Claude Code CLI (latest 채널) |
| `google-chrome` | Chrome 브라우저 |
| `opera` | Opera 브라우저 |
| `alfred` | 런처 (`Control + Space`) |
| `chatgpt` | ChatGPT 데스크톱 앱 |
| `gh` (formula) | GitHub CLI. Orca의 이슈·PR·CI 확인에 사용 |
| `stablyai/orca/orca` | 여러 AI 코딩 에이전트를 worktree별로 실행하는 Orca (`stablyai/orca` tap) |

Git·Vim·zsh는 이미 설치된 것을 사용합니다. Git·Vim·zsh 추가 패키지, jq·fd·ripgrep, 언어 SDK, IDE, 컨테이너·DB·클라우드 도구, 글꼴, 셸 테마·플러그인은 기본 목록에 없습니다. 필요한 도구만 나중에 추가합니다. Nix·nix-darwin·Home Manager가 작동하는 데 필요한 기반 패키지와 전이 의존성은 별도입니다.

`ripgrep`의 실행 명령은 `rg`이며 파일 **내용**을 검색합니다. `fd`는 파일명·경로를 검색합니다. `zsh`는 터미널에서 명령을 해석하는 셸이며 macOS의 `/bin/zsh`를 사용합니다.

`make apply`는 Homebrew 앱 목록을 갱신하고 설치된 앱을 최신 버전으로 업그레이드합니다. 앱 자체 업데이트 기능이 있는 cask(Chrome·Orca 등)는 Homebrew가 건너뛰고 앱이 직접 업데이트합니다. 자동 삭제는 꺼져 있어 목록에서 제외된 기존 앱이나 파일을 지우지 않습니다.

## macOS 기본 설정

`modules/system/defaults.nix`에서 기존 `main`의 macOS 기본 설정을 유지하고, 키 반복·한영 전환 설정을 추가로 관리합니다.

| 항목 | 설정 |
|---|---|
| Finder | 창 제목에 전체 경로 표시, 확장자 표시, 확장자 변경 경고 끄기, 종료 메뉴 추가, 경로·상태 막대 표시 |
| Dock | 오른쪽 배치, 자동 숨김, 최근 사용 앱 표시 끄기, 데스크톱 공간의 최근 사용 순서 자동 재정렬 끄기 |
| 메뉴 막대 시계 | 날짜 항상 표시, 초 표시 |
| sudo Touch ID | 관리자 명령 실행 시 지문 인증 허용 |
| 키 반복 | 속도 `KeyRepeat = 2`, 시작 대기 시간 `InitialKeyRepeat = 15` |

키 반복 값은 현재 Mac의 설정을 그대로 사용합니다. `make apply`로 적용하며, 키 반복 설정은 로그아웃 후 다시 로그인해야 반영될 수 있습니다.

단축키는 다음과 같이 설정합니다.

| 기능 | 단축키 | 관리 방법 |
|---|---|---|
| 한영 전환 (이전 입력 소스 선택, ID 60) | `Command + Space` | `make apply` |
| Spotlight 검색 (ID 64) | `Option + Space` | `make apply` |
| Alfred | `Control + Space` | Alfred 환경설정에서 직접 지정 |

적용 시 주 사용자의 ID 60·64 항목만 갱신하고 다른 단축키는 보존합니다. 한국어·영어 입력 소스가 등록되어 있어야 하며, 단축키가 바로 반영되지 않으면 로그아웃 후 다시 로그인합니다. 다른 기능에 이미 같은 단축키를 지정했다면 충돌할 수 있으며, 그 단축키를 자동으로 변경하지는 않습니다.

Alfred 단축키는 기기별로 생성되는 Alfred 설정 폴더에 저장되어 Nix로 관리하지 않습니다. 처음 실행 후 Alfred Preferences → General → Alfred Hotkey에서 `Control + Space`를 지정합니다. `Control + Space`는 macOS 기본값에서 한영 전환 단축키였지만, 위 설정으로 한영 전환을 `Command + Space`로 옮겼으므로 비어 있습니다.

## 사용자와 기기

`flake.nix`에 다음 값을 사용합니다.

```nix
username = "jongbeom.kim";
configurationName = "macbook-m5-jongbeomkim";
```

확인 명령:

```bash
id -un
scutil --get LocalHostName
```

`username`은 실제 macOS 계정명입니다. `configurationName`은 Nix 구성 선택용 이름이며, 실제 기기 이름을 바꾸지는 않습니다. 이 flake는 새 macOS 계정을 만들거나 기존 개인정보를 삭제하는 도구가 아닙니다.

## 처음 적용

Homebrew와 Nix가 이미 설치되어 있다면 설치 단계는 생략합니다. Git과 `/usr/bin/vim`, `/bin/zsh`도 사용 가능해야 합니다.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sh <(curl -L https://nixos.org/nix/install)
```

다른 Mac에서 clone하려면 먼저 `kajebiii.lab` 브랜치를 원격 저장소에 push해야 합니다. 이미 로컬 저장소가 있다면 clone은 생략합니다.

```bash
git clone --branch kajebiii.lab git@github.com:kajebiii/nix-flake.git
cd nix-flake
make build
make apply
```

`make build`는 시스템을 적용하지 않고 빌드합니다. `make apply`는 먼저 일반 사용자 권한으로 빌드한 뒤, 성공한 결과에 포함된 `darwin-rebuild`로 관리자 권한의 `switch`를 실행합니다. Homebrew 앱 설치는 `apply` 단계에서 수행합니다. `make build` 성공만으로 Homebrew 앱 설치까지 검증되는 것은 아닙니다.

기본 구성은 `macbook-m5-jongbeomkim`입니다. 다른 이름을 사용하면 `make apply CONFIG=새구성이름`으로 지정합니다. Nix 의존성 갱신은 `make update`를 실행합니다. Codex·Claude Code 등 Homebrew 앱은 `make apply` 때 함께 업그레이드됩니다.

Claude Code는 stable 채널보다 새 버전이 빨리 나오는 `claude-code@latest`를 사용합니다. 두 cask는 같은 `claude` 명령을 설치해 함께 설치할 수 없습니다. 이전에 `claude-code`를 설치했다면 `brew uninstall --cask claude-code` 후 `make apply`를 실행합니다.

적용 후 확인:

```bash
codex --version
claude --version
```

## AI 계정과 Git 설정

AI 서비스와 브라우저에는 작업 전용 계정으로 로그인합니다. 개인 Apple 계정·브라우저 동기화·SSH 키·클라우드 인증을 이 계정으로 가져오지 않습니다. 로그인 토큰과 API 키는 저장소나 Nix 표현식에 넣지 않습니다.

기존 Git 실행 파일을 사용하면서 `.gitconfig`만 Home Manager로 관리합니다. 전역 작성자는 이름 `Jongbeom Kim`, 이메일 `kajebiii.lab@gmail.com`입니다. 이름은 기존 Mac과 같게 두고, 이메일로 커밋을 GitHub `kajebiii-lab` 계정에 연결합니다. 커밋 서명은 사용하지 않습니다.

Git 작성자와 push 권한은 별개입니다. push는 SSH 키(`~/.ssh/id_ed25519_github_lab`)로 인증된 `kajebiii-lab` 계정의 권한을 따르므로, 작업할 저장소마다 `kajebiii-lab`을 협업자로 추가해야 합니다. 공개 저장소도 협업자가 아니면 push할 수 없습니다.

셸에는 Nix·Homebrew 경로를 연결하는 `.zshenv`와 `.zprofile`만 둡니다. 별도 zsh 패키지, `.zshrc`, 플러그인, Terraform 자동 설치 훅, direnv 설정은 배포하지 않습니다. 기존 `.gitconfig`·`.zshenv`·`.zprofile`이 있으면 Home Manager가 파일 충돌을 보고할 수 있습니다. 기존 파일을 강제로 덮어쓰지는 않습니다.

## GitHub API 요청 한도에 걸릴 때

공개 의존성은 토큰 없이 가져올 수 있습니다. GitHub API 요청 한도에 걸릴 때만 AI 계정의 토큰을 저장소 밖 Nix 사용자 설정 파일에 둡니다.

```bash
task_nix_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nix"
mkdir -p "$task_nix_config_dir"
chmod 700 "$task_nix_config_dir"
touch "$task_nix_config_dir/github-token.conf"
chmod 600 "$task_nix_config_dir/github-token.conf"
```

편집기로 `github-token.conf`에 아래 형식의 토큰을 저장합니다. 실제 토큰을 채팅이나 셸 명령에 붙여 넣지 않습니다.

```ini
access-tokens = github.com=<AI_ACCOUNT_GITHUB_TOKEN>
```

같은 디렉터리의 `nix.conf`에 다음 줄을 추가합니다. 기존 설정은 보존합니다.

```ini
!include github-token.conf
```

Makefile은 `NIX_USER_CONF_FILES`에 파일 경로만 담아 빌드와 관리자 적용에 전달합니다. 다른 위치를 사용하면 `make apply NIX_USER_CONF_FILES=/절대/경로/nix.conf`로 지정합니다. 토큰 내용은 Nix 표현식에서 읽지 않습니다. 파일은 같은 macOS 계정으로 실행하는 프로그램이 읽을 수 있습니다.

## 필요한 도구 추가

| 수정 내용 | 파일 |
|---|---|
| 앱·CLI 추가 | `modules/apps/homebrew.nix` |
| Homebrew 동작 정책 | `modules/base/homebrew.nix` |
| Git 설정 | `modules/apps/git.nix` |
| macOS 기본 설정·키 반복·한영 전환·Spotlight 단축키 | `modules/system/defaults.nix` |
| 사용자·최소 셸 연결 | `modules/system/home.nix` |
| 계정명·구성 이름 | `flake.nix` |

Homebrew 명령줄 도구는 `homebrew.brews`에, cask는 `homebrew.casks`에 추가합니다. tap은 `homebrew.taps`에 추가합니다. 현재는 Orca 개발사의 공식 tap `stablyai/orca`만 사용합니다. Chrome은 Homebrew 공식 cask가 고정 SHA를 제공하지 않아 해당 cask에만 `require_sha = false`를 지정합니다. 다른 cask에는 SHA 필수 정책을 유지합니다.
