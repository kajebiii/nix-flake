# nix-flake

한 Mac 안에서 개인 관리자 계정과 AI 작업 전용 표준 계정을 함께 운영하는 macOS 환경입니다. nix-darwin으로 시스템을, Home Manager(standalone)로 사용자별 홈을 관리합니다.

| macOS 계정 | 권한 | 용도 | GitHub | Git 이메일 | 적용 명령 |
|---|---|---|---|---|---|
| `jongbeom.kim` | 관리자 | 개인 사용, 시스템 관리 | `kajebiii` | `kajebiii@gmail.com` | `make apply`, `make home` |
| `kajebiii.lab` | 표준(sudo 없음) | AI 에이전트 작업 | `kajebiii-lab` | `kajebiii.lab@gmail.com` | `make home` |

AI 계정에는 sudo·관리자 그룹·NOPASSWD sudoers를 주지 않습니다. 개인 Apple 계정, 브라우저 동기화, 개인 SSH 키, 클라우드 인증도 AI 계정에 넣지 않습니다. 로그인 토큰과 API 키는 저장소나 Nix 표현식에 넣지 않습니다. Nix store는 모든 사용자가 읽을 수 있습니다.

## 구조

| 구성 | 내용 | 실행 권한 |
|---|---|---|
| `darwinConfigurations.macbook-m5-jongbeomkim` | Homebrew 앱, Nix 설정, sudo Touch ID | root (`make apply`, 관리자만) |
| `homeConfigurations."jongbeom.kim"` | 공통 홈 + 개인 Git 설정 | 관리자 본인 (`make home`) |
| `homeConfigurations."kajebiii.lab"` | 공통 홈 + AI Git 설정 | AI 계정 본인 (`make home`) |

```
modules/
  darwin/          # 시스템: nix.nix, homebrew.nix, security.nix
  home/
    common/        # 두 계정 공통: 셸, macOS 기본 설정, 단축키
    personal/      # jongbeom.kim 전용 (Git)
    lab/           # kajebiii.lab 전용 (Git)
```

`system.primaryUser`는 `jongbeom.kim`입니다. `/opt/homebrew`가 이 계정 소유이므로 Homebrew 설치·업그레이드는 관리자만 할 수 있습니다. AI 계정은 설치된 앱과 명령을 실행만 합니다.

## 설치 대상

시스템(`modules/darwin/homebrew.nix`)에서 두 계정이 함께 쓰는 앱을 설치합니다.

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

Git·Vim·zsh는 macOS에 있는 것을 사용합니다. 언어 SDK, IDE, 컨테이너·DB·클라우드 도구, 글꼴, 셸 테마·플러그인은 기본 목록에 없습니다. 사용자별 CLI 도구가 필요하면 Homebrew formula 대신 해당 계정 홈의 `home.packages`에 Nix 패키지로 추가합니다. 그러면 AI 계정도 `make home`으로 혼자 설치할 수 있습니다.

`make apply`는 Homebrew 앱 목록을 갱신하고 설치된 앱을 최신 버전으로 업그레이드합니다. 앱 자체 업데이트 기능이 있는 cask(Chrome·Orca 등)는 Homebrew가 건너뛰고 앱이 직접 업데이트합니다. 자동 삭제는 꺼져 있어 목록에서 제외된 기존 앱이나 파일을 지우지 않습니다.

Claude Code는 stable 채널보다 새 버전이 빨리 나오는 `claude-code@latest`를 사용합니다. 두 cask는 같은 `claude` 명령을 설치해 함께 설치할 수 없습니다.

## macOS 기본 설정과 단축키

`modules/home/common/`에서 두 계정에 같은 값을 적용합니다. 계정별 설정이므로 각자 `make home`으로 적용합니다.

| 항목 | 설정 |
|---|---|
| Finder | 창 제목에 전체 경로 표시, 확장자 표시, 확장자 변경 경고 끄기, 종료 메뉴 추가, 경로·상태 막대 표시 |
| Dock | 오른쪽 배치, 자동 숨김, 최근 사용 앱 표시 끄기, 데스크톱 공간의 최근 사용 순서 자동 재정렬 끄기 |
| 메뉴 막대 시계 | 날짜 항상 표시, 초 표시 |
| 키 반복 | 속도 `KeyRepeat = 2`, 시작 대기 시간 `InitialKeyRepeat = 15` (시스템 설정 슬라이더 최대) |

| 기능 | 단축키 | 관리 방법 |
|---|---|---|
| 한영 전환 (이전 입력 소스 선택, ID 60) | `Command + Space` | `make home` |
| Spotlight 검색 (ID 64) | `Option + Space` | `make home` |
| Alfred | `Control + Space` | 계정마다 Alfred 환경설정에서 직접 지정 |

단축키는 ID 60·64 항목만 갱신하고 다른 단축키는 보존합니다. 적용 후 설정을 다시 읽게 하므로 단축키는 바로 동작합니다. 키 반복은 로그아웃 후 다시 로그인해야 반영됩니다. 시스템 설정 창이 열려 있으면 적용한 값을 덮어쓸 수 있으니 닫고 적용합니다.

sudo Touch ID는 시스템 설정이라 `modules/darwin/security.nix`에 있습니다.

## Git과 GitHub

Git 실행 파일은 macOS 것을 쓰고 `.gitconfig`만 Home Manager로 관리합니다. 작성자 이름은 두 계정 모두 `Jongbeom Kim`이고, 이메일로 커밋을 GitHub 계정에 연결합니다. 커밋 서명은 사용하지 않습니다.

Git 작성자와 push 권한은 별개입니다. push는 SSH 키로 인증된 GitHub 계정의 권한을 따릅니다. AI 계정의 SSH 키는 `kajebiii.lab` 홈에만 두고, AI가 작업할 저장소마다 `kajebiii-lab`을 협업자로 추가합니다. 공개 저장소도 협업자가 아니면 push할 수 없습니다.

셸에는 Nix·Homebrew 경로를 연결하는 `.zshenv`와 `.zprofile`만 둡니다. `.zshrc`, 플러그인, 별도 zsh 패키지는 배포하지 않습니다.

## 처음 적용

Homebrew와 Nix는 관리자 계정에서 설치합니다. 이미 있으면 생략합니다.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sh <(curl -L https://nixos.org/nix/install)
```

관리자(`jongbeom.kim`):

```bash
git clone --branch kajebiii.lab git@github.com:kajebiii/nix-flake.git
cd nix-flake
make apply   # 시스템. 변경 내용을 보여 주고 y/N을 묻습니다.
make home    # 관리자 홈. 마찬가지로 y/N을 묻습니다.
```

AI 계정(`kajebiii.lab`):

```bash
git clone --branch kajebiii.lab https://github.com/kajebiii/nix-flake.git ~/workspace/nix-flake
cd ~/workspace/nix-flake
make home
```

AI 계정에서 직접 한 번씩 설정할 항목입니다. Nix로 관리하지 않습니다.

- SSH 키: 관리자가 `kajebiii.lab` 홈의 `~/.ssh`에 넣어 주거나 이 계정에서 새로 만들어 `kajebiii-lab`에 등록합니다. `ssh -T git@github.com`으로 확인한 뒤 저장소 remote를 SSH로 바꿉니다.
- `gh auth login` → `kajebiii-lab`
- Claude Code, Codex, ChatGPT: AI용 계정으로 로그인
- Chrome, Opera: AI용 Google 계정만 로그인합니다. 개인 계정을 넣으면 동기화로 개인 비밀번호·북마크가 내려옵니다.
- Alfred: Preferences → General → Alfred Hotkey를 `Control + Space`로 지정
- Orca 초기 설정

`make build`는 시스템을 적용하지 않고 빌드만 합니다. 기본 구성은 `macbook-m5-jongbeomkim`이며 다른 이름은 `make apply SYSTEM_CONFIG=이름`으로 지정합니다. Nix 의존성 갱신은 `make update`입니다.

## 운영 규칙

**관리자가 실행하는 코드는 적용 전에 읽습니다.** AI 계정에 sudo가 없어도, AI가 고친 flake를 관리자가 적용하면 그 코드는 root(`make apply`)나 관리자 권한(`make home`)으로 실행됩니다. 예를 들어 활성화 스크립트에 "AI 계정을 admin 그룹에 추가"가 들어가면 적용 한 번에 계정 분리가 무효가 됩니다.

- 검토 대상은 `modules/home/lab/`을 뺀 저장소 전부입니다. `flake.nix`, `flake.lock`, `Makefile`, `modules/darwin/`, `modules/home/common/`, `modules/home/personal/`이 해당합니다.
- `make apply`와 관리자의 `make home`은 마지막으로 적용한 커밋 이후 변경(커밋하지 않은 변경 포함)을 보여 주고 y/N을 묻습니다. diff를 읽지 않고 y를 누르면 의미가 없습니다. 기준 커밋은 `make apply`는 `darwin-version --configuration-revision`, `make home`은 `~/.local/state/nix-flake/last-home-rev`입니다. 기준을 모르면 `git status`만 보여 주므로 작업 트리를 직접 확인합니다.
- **이 확인 프롬프트는 `Makefile` 안에 있어 AI가 고칠 수 있습니다.** 그래서 관리자 계정에서 `git pull`을 할 때 출력되는 파일 목록에 `Makefile`·`flake.nix`·`flake.lock`이 있으면, 적용 전에 그 파일들의 diff를 직접 엽니다.
- GitHub 브랜치 보호와 PR 강제는 지금은 쓰지 않습니다. AI 작업 범위가 커지거나 협업자가 늘면 추가합니다.
- 앱 업데이트는 관리자만 할 수 있습니다. AI 계정에서 Claude Code 등이 "업데이트 가능"을 표시해도 그 계정에서는 설치할 수 없습니다. 관리자가 `make apply`할 때 함께 업그레이드됩니다.
- 새 GUI 앱은 `modules/darwin/homebrew.nix`에 추가하고 관리자가 `make apply`합니다.

## GitHub API 요청 한도에 걸릴 때

공개 의존성은 토큰 없이 가져올 수 있습니다. GitHub API 요청 한도에 걸릴 때만 해당 계정의 토큰을 저장소 밖 Nix 사용자 설정 파일에 둡니다.

```bash
task_nix_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nix"
mkdir -p "$task_nix_config_dir"
chmod 700 "$task_nix_config_dir"
touch "$task_nix_config_dir/github-token.conf"
chmod 600 "$task_nix_config_dir/github-token.conf"
```

편집기로 `github-token.conf`에 아래 형식의 토큰을 저장합니다. 실제 토큰을 채팅이나 셸 명령에 붙여 넣지 않습니다.

```ini
access-tokens = github.com=<GITHUB_TOKEN>
```

같은 디렉터리의 `nix.conf`에 다음 줄을 추가합니다. 기존 설정은 보존합니다.

```ini
!include github-token.conf
```

Makefile은 `NIX_USER_CONF_FILES`에 파일 경로만 담아 빌드와 관리자 적용에 전달합니다. 다른 위치를 사용하면 `make apply NIX_USER_CONF_FILES=/절대/경로/nix.conf`로 지정합니다. 토큰 내용은 Nix 표현식에서 읽지 않습니다.

## 수정할 파일

| 수정 내용 | 파일 |
|---|---|
| 앱·CLI 추가, Homebrew 정책 | `modules/darwin/homebrew.nix` |
| Nix 설정 | `modules/darwin/nix.nix` |
| sudo Touch ID | `modules/darwin/security.nix` |
| 두 계정 공통 셸 | `modules/home/common/shell.nix` |
| macOS 기본 설정·키 반복 | `modules/home/common/macos-defaults.nix` |
| 한영 전환·Spotlight 단축키 | `modules/home/common/hotkeys.nix` |
| 관리자 Git 설정 | `modules/home/personal/git.nix` |
| AI 계정 Git 설정 | `modules/home/lab/git.nix` |
| 계정명·구성 이름 | `flake.nix`, `Makefile` |

Homebrew 명령줄 도구는 `homebrew.brews`에, cask는 `homebrew.casks`에, tap은 `homebrew.taps`에 추가합니다. 현재 tap은 Orca 개발사의 공식 tap `stablyai/orca`뿐입니다. Chrome은 Homebrew 공식 cask가 고정 SHA를 제공하지 않아 해당 cask에만 `require_sha = false`를 지정합니다. 다른 cask에는 SHA 필수 정책을 유지합니다.
