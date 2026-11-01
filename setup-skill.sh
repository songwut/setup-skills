#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Enterprise AI Agent Skills & OWASP Guardrails Installer
# Profiles: Web | Mobile Native (iOS / Android) | Cross-Platform (Flutter / RN)
# ==============================================================================

# ANSI Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ------------------------------------------------------------------------------
# 1. Pre-flight Checks
# ------------------------------------------------------------------------------
check_dependencies() {
  if ! command -v npx >/dev/null 2>&1; then
    log_error "npx not found. Please install Node.js (LTS 18+) before running this script."
    exit 1
  fi
}

# ------------------------------------------------------------------------------
# 2. Core Skills (Shared across all profiles: Plan + Design Core + SAST)
# ------------------------------------------------------------------------------
install_core_skills() {
  log_info "Installing Core Enterprise Skills (Superpowers, Impeccable, Semgrep, Trail of Bits)..."

  # Planning, Architecture & TDD Workflow
  npx -y skills add https://github.com/obra/superpowers

  # Design System Polish & Anti-Slop Heuristics
  npx -y impeccable install

  # Security & OWASP SAST (Semgrep + Trail of Bits)
  npx -y skills add https://github.com/semgrep/skills --skill "code-security"
  npx -y skills add https://github.com/semgrep/skills --skill "llm-security"
  npx -y skills add https://github.com/trailofbits/skills --skill "insecure-defaults"
  npx -y skills add https://github.com/trailofbits/skills --skill "differential-review"
  npx -y skills add https://github.com/trailofbits/skills --skill "supply-chain-risk-auditor"

  log_success "Core Enterprise Skills installed successfully."
}

# ------------------------------------------------------------------------------
# 3. Native Sub-Installers (iOS & Android)
# ------------------------------------------------------------------------------
install_ios_skills() {
  log_info "Installing Native iOS (Swift / SwiftUI) Skills..."
  npx -y skills add https://github.com/twostraws/swiftui-agent-skill
  npx -y skills add https://github.com/AvdLee/SwiftUI-Agent-Skill --skill "swiftui-expert-skill"
  npx -y skills add https://github.com/FloWritesCode/fwc-swiftui-skills
  npx -y skills add https://github.com/conorluddy/ios-simulator-skill
}

install_android_skills() {
  log_info "Installing Native Android (Kotlin / Jetpack Compose) Skills..."
  npx -y skills add https://github.com/JetBrains/kotlin-agent-skills
  npx -y skills add https://github.com/skydoves/android-agent-skills
  npx -y skills add https://github.com/google/android-skills
}

# ------------------------------------------------------------------------------
# 4. Profile Installers
# ------------------------------------------------------------------------------
install_web_profile() {
  log_info "Installing Profile 1: Web Application Enterprise Pack..."
  install_core_skills

  # Frontend Taste & Layout Heuristics
  npx -y skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"

  # Token-Efficient Playwright CLI & Skills
  if ! command -v playwright-cli >/dev/null 2>&1; then
    log_info "Installing @playwright/cli globally..."
    npm install -g @playwright/cli@latest
  fi
  playwright-cli install --skills

  generate_owasp_rules "web"
  log_success "Web Application Enterprise Profile installation complete."
}

install_native_profile() {
  local sub_target="${1:-prompt}"

  if [ "$sub_target" = "prompt" ]; then
    echo ""
    echo "Select Native Mobile Target:"
    echo "  1) iOS Only     (Swift / SwiftUI + iOS Simulator + Maestro)"
    echo "  2) Android Only (Kotlin / Jetpack Compose + ADB/Emulator + Maestro)"
    echo "  3) Both         (Full Native iOS & Android Stack)"
    read -rp "Select option [1-3] (default: 3): " native_choice
    native_choice=${native_choice:-3}
  else
    native_choice="$sub_target"
  fi

  install_core_skills

  # Footgun Prevention for Native Cryptography & Low-level APIs
  npx -y skills add https://github.com/trailofbits/skills --skill "sharp-edges"

  case "$native_choice" in
    1|ios)
      install_ios_skills
      ;;
    2|android)
      install_android_skills
      ;;
    3|both|*)
      install_ios_skills
      install_android_skills
      ;;
  esac

  # Mobile E2E Flow Testing (Maestro)
  npx -y skills add aibot88/sec_skill_store --skill "mobile-flows-maestro"

  generate_owasp_rules "native"
  log_success "Mobile Native Enterprise Profile installation complete."
}

install_cross_profile() {
  local sub_target="${1:-prompt}"

  if [ "$sub_target" = "prompt" ]; then
    echo ""
    echo "Select Cross-Platform Framework:"
    echo "  1) Flutter             (Official Dart/Flutter + UI Polish)"
    echo "  2) React Native / Expo (Official Expo + Vercel + Software Mansion)"
    echo "  3) Both                (Flutter + React Native)"
    read -rp "Select option [1-3] (default: 1): " fw_choice
    fw_choice=${fw_choice:-1}
  else
    fw_choice="$sub_target"
  fi

  install_core_skills

  case "$fw_choice" in
    1|flutter)
      npx -y skills add flutter/skills --skill "*"
      npx -y skills add kamranbekirovyz/skills --skill "flutter-improve-design"
      ;;
    2|rn)
      npx -y skills add expo/skills
      npx -y skills add vercel-labs/agent-skills --skill "react-native-skills"
      npx -y skills add software-mansion-labs/skills
      ;;
    3|both|*)
      npx -y skills add flutter/skills --skill "*"
      npx -y skills add kamranbekirovyz/skills --skill "flutter-improve-design"
      npx -y skills add expo/skills
      npx -y skills add vercel-labs/agent-skills --skill "react-native-skills"
      npx -y skills add software-mansion-labs/skills
      ;;
  esac

  # Cross-Platform E2E Testing (Maestro + Simulator Control)
  npx -y skills add aibot88/sec_skill_store --skill "mobile-flows-maestro"
  npx -y skills add https://github.com/conorluddy/ios-simulator-skill

  generate_owasp_rules "cross"
  log_success "Mobile Cross-Platform Enterprise Profile installation complete."
}

# ------------------------------------------------------------------------------
# 5. Generate OWASP Enterprise Rules & Platform Guardrails
# ------------------------------------------------------------------------------
generate_owasp_rules() {
  local profile_type="$1"
  local rule_file="OWASP-SECURITY-RULES.md"

  log_info "Generating OWASP security and design guardrails ($rule_file)..."

  cat << 'EOF' > "$rule_file"
# Enterprise Architecture, Design & OWASP Security Guardrails

## 1. Core Engineering Workflow (Mandatory)
- **Plan Before Code:** Always run brainstorming and implementation planning before modifying production files.
- **TDD & Verification:** Write or update unit/integration tests before finalizing implementation. Never mark a task complete without executing verification tests or E2E checks.
- **Design System Single Source of Truth:** Respect `DESIGN.md` tokens (OKLCH/HCT color tokens, typography scale, spacing tokens) strictly. Avoid arbitrary magic numbers or unrequested decorative effects.

## 2. Universal OWASP Security Rules (Zero Tolerance)
- **No Hardcoded Secrets (OWASP A02 / MASVS-STORAGE):** Never commit API keys, private tokens, signing keys, or credentials in source code or client-bundled `.env` files.
- **Strict Schema Validation (OWASP A03 / MASVS-PLATFORM):** Every external input (REST/GraphQL payload, URL query, Deep Link, Universal Link, App Link, WebSocket message) must be parsed through strict schema validation before execution.
- **Production Log Sanitization (OWASP A09 / MASVS-STORAGE):** Strip all `console.log`, `print()`, `debugPrint()`, and `Log.d()` statements containing PII, tokens, headers, or session payloads in Release builds.
- **Dependency Hygiene (OWASP A06):** Audit any new third-party package for supply-chain risk and known CVEs before adding to package manifests.
EOF

  if [ "$profile_type" = "web" ]; then
    cat << 'EOF' >> "$rule_file"

## 3. Web Application Specific Rules (OWASP Top 10 + UI Standards)
- **Auth & Session Storage:** Store session and refresh tokens exclusively in `HttpOnly`, `Secure`, `SameSite=Strict/Lax` cookies. Never store JWTs or sensitive tokens in `localStorage` or `sessionStorage`.
- **XSS & CSP Hardening:** Sanitize all dynamic HTML rendering. Enforce strict Content-Security-Policy (CSP), CORS allowlists, and CSRF protection on all state-changing endpoints.
- **Iconography:** Use `lucide` icons for UI controls and `simple-icons` strictly for third-party brand logos. Maintain consistent stroke width (`1.75px` or `2px`) and optical sizing.
- **Visual & E2E Check:** Verify layout states (empty, loading, error, mobile/desktop viewports) using `playwright-cli` before completing UI tasks.
EOF
  elif [ "$profile_type" = "native" ]; then
    cat << 'EOF' >> "$rule_file"

## 3. Native Mobile Specific Rules (OWASP MASVS + HIG / Material 3 Standards)
- **Secure Hardware Storage (MASVS-STORAGE-1):**
  - **iOS:** Store all tokens, credentials, and encryption keys exclusively in **Keychain** (`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`). Never use `UserDefaults` or `@AppStorage` for sensitive data.
  - **Android:** Store all tokens and cryptographic keys using **Android Keystore** with **Jetpack DataStore (Encrypted)** or **EncryptedSharedPreferences**. Never store sensitive data in plain `SharedPreferences` or unencrypted Room/SQLite databases.
- **Component & Intent Hardening (MASVS-PLATFORM-1):**
  - **Android:** Explicitly set `android:exported="false"` on all Activities, Services, and BroadcastReceivers in `AndroidManifest.xml` unless external invocation is required and guarded by custom permissions.
  - **iOS:** Validate all incoming `NSUserActivity` and Universal Link payloads strictly before routing.
- **Network Hardening (MASVS-NETWORK-1):** Enforce TLS 1.3 and HTTPS across all endpoints. Never enable `NSAllowsArbitraryLoads` (iOS) or `usesCleartextTraffic="true"` (Android) outside local debug builds.
- **Native Architecture & UI Performance:**
  - **iOS (SwiftUI):** Use Swift 6 strict concurrency (`async/await`, `@MainActor`, `Sendable`), `@Observable` macro, and **SF Symbols 6+** with Dynamic Type and VoiceOver accessibility labels.
  - **Android (Jetpack Compose):** Follow Unidirectional Data Flow (UDF) with Kotlin Coroutines/`StateFlow`, hoist state properly, ensure `@Stable`/`@Immutable` models to prevent unnecessary recompositions, and use **Material Symbols (Material 3)** with `contentDescription`.
  - **Brand Icons:** Use `simple-icons` exclusively for third-party brand logos.
- **Simulator, Emulator & E2E Verification:** Validate builds and UI flows using `ios-simulator-skill`, ADB, and `Maestro` YAML flows before task completion.
EOF
  elif [ "$profile_type" = "cross" ]; then
    cat << 'EOF' >> "$rule_file"

## 3. Cross-Platform Mobile Specific Rules (OWASP MASVS + Flutter / RN Standards)
- **Secure Storage (MASVS-STORAGE-1):** Use `flutter_secure_storage` (Flutter) or `expo-secure-store` / `react-native-keychain` (RN) for all tokens and secrets. Never store sensitive data in plain `SharedPreferences`, `AsyncStorage`, or unencrypted local databases (Drift/SQLite/MMKV without hardware-backed encryption keys).
- **Deep Link & Intent Hardening (MASVS-PLATFORM-2):** Validate all incoming App Links, Universal Links, and Android Intents against a strict route and parameter schema before navigation.
- **Rendering Performance & Icons:** Prevent unnecessary widget rebuilds or component re-renders. Use `flutter_lucide` / `lucide-react-native` for system icons and `simple-icons` for brand marks.
- **Cross-Platform E2E Verification:** Run and verify critical user journeys via `Maestro` CLI flows on Simulator/Emulator before marking UI tasks done.
EOF
  fi

  # Link OWASP-SECURITY-RULES.md in CLAUDE.md and AGENTS.md idempotently
  for agent_doc in "CLAUDE.md" "AGENTS.md"; do
    if [ -f "$agent_doc" ]; then
      if ! grep -q "$rule_file" "$agent_doc"; then
        printf "\n\n## Security & Architecture Guardrails\nSee @%s for mandatory OWASP security and platform design rules.\n" "$rule_file" >> "$agent_doc"
        log_info "Linked $rule_file in existing $agent_doc."
      fi
    else
      cat << EOF > "$agent_doc"
# Project Agent Instructions

## Security & Architecture Guardrails
See @$rule_file for mandatory OWASP security, architecture, and platform design rules.
EOF
      log_info "Created $agent_doc linked to $rule_file."
    fi
  done
}

# ------------------------------------------------------------------------------
# 6. CLI Entrypoint & Interactive Menu
# ------------------------------------------------------------------------------
usage() {
  cat << EOF
Usage: $(basename "$0") [OPTION]

Options:
  --web          Install Web Application Enterprise Profile
  --native       Install Mobile Native Profile (Interactive iOS/Android prompt)
  --ios          Install Mobile Native Profile (iOS Swift/SwiftUI only)
  --android      Install Mobile Native Profile (Android Kotlin/Compose only)
  --cross        Install Cross-Platform Profile (Interactive Flutter/RN prompt)
  --flutter      Install Cross-Platform Profile (Flutter only)
  --rn           Install Cross-Platform Profile (React Native / Expo only)
  --rules-only   Generate OWASP-SECURITY-RULES.md only (web | native | cross)
  -h, --help     Show this help message
EOF
}

check_dependencies

PROFILE_ARG="${1:-}"

case "$PROFILE_ARG" in
  --web)
    install_web_profile
    exit 0
    ;;
  --native)
    install_native_profile "prompt"
    exit 0
    ;;
  --ios)
    install_native_profile "ios"
    exit 0
    ;;
  --android)
    install_native_profile "android"
    exit 0
    ;;
  --cross)
    install_cross_profile "prompt"
    exit 0
    ;;
  --flutter)
    install_cross_profile "flutter"
    exit 0
    ;;
  --rn)
    install_cross_profile "rn"
    exit 0
    ;;
  --rules-only)
    generate_owasp_rules "${2:-web}"
    exit 0
    ;;
  -h|--help)
    usage
    exit 0
    ;;
esac

echo "=========================================================="
echo "  Enterprise Skill Pack & OWASP Guardrails Installer"
echo "=========================================================="
echo "Select a project profile to install:"
echo "  1) Web Application        (Next.js / Vite / SaaS + Playwright CLI)"
echo "  2) Mobile App Native      (SwiftUI / Jetpack Compose + Maestro)"
echo "  3) Mobile Cross-Platform  (Flutter / React Native + Maestro)"
echo "  4) Generate OWASP Rules   (Skip skill installation)"
echo "=========================================================="
read -rp "Enter option [1-4]: " choice

case "$choice" in
  1) install_web_profile ;;
  2) install_native_profile "prompt" ;;
  3) install_cross_profile "prompt" ;;
  4)
    read -rp "Specify target rule set (web / native / cross) [default: web]: " rule_type
    generate_owasp_rules "${rule_type:-web}"
    ;;
  *)
    log_error "Invalid selection. Exiting."
    exit 1
    ;;
esac
