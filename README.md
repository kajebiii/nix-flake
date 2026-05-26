# nix-flake

macOS (Apple Silicon) 개발 환경을 nix-darwin + home-manager로 선언적으로 관리하는 flake.

## 트러블슈팅 (Troubleshooting)

### GitHub API Rate Limit (403 Error)

`make apply` 실행 중 GitHub API 403 에러가 발생하면, GitHub 인증 토큰(PAT)이 필요합니다.

1. `.env.example` 파일을 복사하여 `.env` 파일을 만듭니다.
2. [GitHub Personal Access Token](https://github.com/settings/tokens)을 생성합니다. (권한은 필요 없음)
3. `.env` 파일의 `GITHUB_TOKEN`에 토큰 값을 넣습니다.
4. 아래 명령어로 적용합니다:
   ```bash
   source .env
   make apply
   ```

## 어디를 봐야 하나?

내 환경을 커스터마이징하고 싶으면 아래 파일만 보면 됩니다.

| 하고 싶은 것 | 파일 |
|---|---|
| CLI 도구 / GUI 앱(nix) 추가·제거 | `modules/apps/pkgs.nix` |
| Homebrew cask 앱 추가·제거 | `modules/apps/homebrew.nix` |
| Homebrew tap 추가 | `modules/base/homebrew.nix` |
| Git 설정 변경 | `modules/apps/git.nix` |
| zsh 설정 (alias, plugin 등) | `modules/cli/zsh.nix` |
| 폰트 추가 | `modules/system/fonts.nix` |
| JetBrains IDE 플러그인 | `modules/apps/jetbrains.nix` |
| 환경변수 추가 | `modules/base/env.nix` |

## 구조

```
flake.nix                  # 진입점 — 호스트명, 시스템 기본값, overlay
modules/
  default.nix              # 모듈 import 목록
  base/
    env.nix                # 전역 환경변수 (PATH 등)
    nix.nix                # nix 자체 설정
    homebrew.nix           # Homebrew 초기화, tap, 업데이트 정책
  system/
    fonts.nix              # 시스템 폰트
    home.nix               # home-manager 연결 (유저, 쉘, xdg)
  apps/
    homebrew.nix           # Homebrew cask/brew/masApps 목록
    pkgs.nix               # nix 패키지 목록 (CLI 도구, SDK 등)
    git.nix                # Git 설정
    jetbrains.nix          # JetBrains 플러그인
    vscode.nix             # VS Code 설정 (현재 비활성)
  cli/
    zsh.nix                # zsh 설정
    direnv.nix             # direnv 설정
overlays.nix               # nixpkgs-unstable overlay
```

## 처음 세팅

### 1. 사전 준비

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Apple 계정 로그인 (brew mas 사용을 위해)
```

### 2. Nix 설치 및 적용

```bash
sh <(curl -L https://nixos.org/nix/install)
git clone git@github.com:kajebiii/nix-flake.git
cd nix-flake
```

자기 환경에 맞게 수정:
- `modules/apps/git.nix` — userName, userEmail
- `flake.nix`, `modules/system/home.nix` — `macstudio-jongbeomkim`을 자기 유저명으로 변경 (`echo $HOME`으로 확인)

```bash
make apply
```

### 3. 적용 후

```bash
cs setup --jvm graalvm-java21:21   # sbt, scala-cli 등
rustup default stable               # cargo 버전 선택

# Steam (Apple Silicon — Rosetta 필요)
softwareupdate --install-rosetta --agree-to-license
```

## 패키지 추가 예시

**nix 패키지** — `modules/apps/pkgs.nix`의 `home.packages` 리스트에 추가:

```nix
home.packages = (with pkgs; [
  # ...기존 패키지들
  새패키지
]);
```

**Homebrew cask** — `modules/apps/homebrew.nix`의 `casks`에 추가. tap이 필요하면 `modules/base/homebrew.nix`의 `taps`에도 추가:

```nix
# modules/base/homebrew.nix
taps = [ "homebrew/services" "some-org/tap" ];

# modules/apps/homebrew.nix
casks = [ "some-org/tap/app-name" ];
```

## 참고

- Spotlight/Alfred 대신 Raycast 사용
- https://search.nixos.org/packages
