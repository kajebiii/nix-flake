# nix-flake

`kajebiii.lab`은 개인 로그인 정보와 데이터를 넣지 않는 AI 작업 전용 macOS 환경입니다. nix-darwin과 Home Manager로 설정을 관리하고, 처음 추가할 애플리케이션은 네 개로 제한합니다.

## 설치 대상

| Homebrew cask | 용도 |
|---|---|
| `codex` | Codex CLI |
| `claude-code` | Claude Code CLI |
| `google-chrome` | Chrome 브라우저 |
| `opera` | Opera 브라우저 |

Git·Vim·zsh는 이미 설치된 것을 사용합니다. Git·Vim·zsh 추가 패키지, gh·jq·fd·ripgrep, 언어 SDK, IDE, 컨테이너·DB·클라우드 도구, 글꼴, 셸 테마·플러그인은 기본 목록에 없습니다. 필요한 도구만 나중에 추가합니다. Nix·nix-darwin·Home Manager가 작동하는 데 필요한 기반 패키지와 전이 의존성은 별도입니다.

`ripgrep`의 실행 명령은 `rg`이며 파일 **내용**을 검색합니다. `fd`는 파일명·경로를 검색합니다. `zsh`는 터미널에서 명령을 해석하는 셸이며 macOS의 `/bin/zsh`를 사용합니다.

Homebrew의 자동 업데이트·전체 업그레이드·자동 삭제는 꺼져 있습니다. 브라우저 자체의 업데이트 기능은 별개입니다. 제외된 기존 앱이나 파일을 자동으로 지우지 않습니다.

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

기본 구성은 `macbook-m5-jongbeomkim`입니다. 다른 이름을 사용하면 `make apply CONFIG=새구성이름`으로 지정합니다. Nix 의존성 갱신은 `make update`, AI CLI 갱신은 필요할 때 `brew upgrade --cask codex claude-code`를 실행합니다.

적용 후 확인:

```bash
codex --version
claude --version
```

## AI 계정과 Git 설정

AI 서비스와 브라우저에는 작업 전용 계정으로 로그인합니다. 개인 Apple 계정·브라우저 동기화·SSH 키·클라우드 인증을 이 계정으로 가져오지 않습니다. 로그인 토큰과 API 키는 저장소나 Nix 표현식에 넣지 않습니다.

기존 Git 실행 파일을 사용하면서 `.gitconfig`만 Home Manager로 관리합니다. 전역 작성자 이름·이메일은 비워 두고 `user.useConfigOnly = true`를 설정합니다. 작업 저장소에서 AI용 Git 작성자를 명시합니다. 기존 저장소에 이미 설정된 작성자는 별도로 확인합니다.

```bash
git config --local user.name '<AI_ACCOUNT_NAME>'
git config --local user.email '<AI_ACCOUNT_NOREPLY_EMAIL>'
```

꺾쇠 부분은 실제 AI 계정의 값으로 바꿉니다. GitHub noreply 주소는 해당 계정의 이메일 설정에서 확인합니다. Git 작성자와 push 인증은 별개입니다.

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
| 사용자·최소 셸 연결 | `modules/system/home.nix` |
| 계정명·구성 이름 | `flake.nix` |

Homebrew 명령줄 도구는 `homebrew.brews`에, cask는 `homebrew.casks`에 추가합니다. 현재 별도 tap은 필요하지 않습니다. Chrome은 Homebrew 공식 cask가 고정 SHA를 제공하지 않아 해당 cask에만 `require_sha = false`를 지정합니다. 다른 cask에는 SHA 필수 정책을 유지합니다.
