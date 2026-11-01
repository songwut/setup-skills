# Enterprise Agent Skills & OWASP Guardrails Installer

A production-grade shell utility that bootstraps AI Agent workspaces (Claude Code, Cursor, Windsurf, Aider) with battle-tested skills, architectural patterns, and strict OWASP security guardrails.

Supports **Web**, **Mobile Native (iOS/Android)**, and **Mobile Cross-Platform (Flutter/React Native)** environments.

---

## Features

- **Standardized Engineering Workflow:** Integrates planning, TDD, and architectural brainstorming before code execution.
- **Strict OWASP Guardrails:** Automatically provisions `OWASP-SECURITY-RULES.md` and links it directly into `CLAUDE.md` and `AGENTS.md`.
- **Platform-Tailored Tooling:**
  - **Web:** Token-efficient `playwright-cli`, Semgrep SAST, and design heuristics.
  - **Native iOS / Android:** SwiftUI architecture rules, Kotlin/Compose performance patterns, SF Symbols & Material 3 enforcement, and `Maestro` mobile E2E testing.
  - **Cross-Platform:** Official Flutter & React Native/Expo performance skills with secure hardware storage policies.
- **Zero-Dependency Bootstrap:** Runs directly on macOS/Linux with standard `bash` and `Node.js (>=18)`.

---

## Quick Start

### 1. Run Directly via `curl`

To bootstrap your current working directory without cloning the repository:

```bash
curl -fsSL [https://raw.githubusercontent.com/](https://raw.githubusercontent.com/)<YOUR-USERNAME>/<YOUR-REPO>/main/setup-skills.sh | bash -s -- --web

```

*(Replace `--web` with `--ios`, `--android`, `--flutter`, or `--rn` depending on your stack).*

---

### 2. Manual Installation

Clone the repository and make the script executable:

```bash
git clone [https://github.com/](https://github.com/)<YOUR-USERNAME>/<YOUR-REPO>.git
cd <YOUR-REPO>
chmod +x setup-skills.sh

# Move to your local PATH for global access
mkdir -p ~/.local/bin
cp setup-skills.sh ~/.local/bin/

```

---

## CLI Usage

Run the script in any directory (including an empty folder for greenfield projects):

```bash
# Interactive menu
setup-skills.sh

# Web Application (Next.js / Vite / SaaS)
setup-skills.sh --web

# Mobile Native
setup-skills.sh --native      # Interactive prompt for iOS/Android
setup-skills.sh --ios         # iOS (Swift / SwiftUI + Simulator)
setup-skills.sh --android     # Android (Kotlin / Jetpack Compose)

# Mobile Cross-Platform
setup-skills.sh --cross       # Interactive prompt for Flutter/RN
setup-skills.sh --flutter     # Flutter only
setup-skills.sh --rn          # React Native / Expo only

# Generate Security & Architecture Rules only (No skill installation)
setup-skills.sh --rules-only web
setup-skills.sh --rules-only native
setup-skills.sh --rules-only cross

```

---

## Profile Matrix

| Category | Web Profile (`--web`) | Native Profile (`--ios` / `--android`) | Cross-Platform (`--flutter` / `--rn`) |
| --- | --- | --- | --- |
| **Workflow** | `superpowers` (Plan & TDD) | `superpowers` (Plan & TDD) | `superpowers` (Plan & TDD) |
| **Design System** | `impeccable` + `taste-skill` | `impeccable` + HIG / Material 3 | `impeccable` + Flutter/RN Design |
| **Icons** | Lucide + Simple Icons | SF Symbols 6+ / Material Symbols | Lucide (`flutter_lucide` / RN) |
| **Security (SAST)** | Semgrep + Trail of Bits | Semgrep + Trail of Bits (`sharp-edges`) | Semgrep + Trail of Bits |
| **E2E & Verification** | `playwright-cli` (`--skills`) | `ios-simulator-skill` + `Maestro` | `Maestro` + Simulator Control |

---

## OWASP Guardrails Enforced

When executed, the script creates `OWASP-SECURITY-RULES.md` and binds it to `CLAUDE.md` and `AGENTS.md`. The rules strictly enforce:

1. **Zero Plaintext Storage (MASVS-STORAGE-1 / OWASP A02):**
* **Web:** Tokens exclusively in `HttpOnly`, `Secure`, `SameSite=Strict/Lax` cookies. No JWTs in `localStorage`.
* **iOS:** iOS Keychain (`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`). No `@AppStorage` for secrets.
* **Android:** Android Keystore with Encrypted DataStore. No plain `SharedPreferences`.
* **Cross-Platform:** `flutter_secure_storage` or `expo-secure-store`.


2. **Strict Input & Deep-Link Validation (MASVS-PLATFORM / OWASP A03):** All incoming URLs, Universal Links, App Links, and API payloads must pass schema validation before navigation or processing.
3. **No Hardcoded Secrets (OWASP A02):** Automated Semgrep checks to prevent committing API keys, tokens, or credentials in client bundles.
4. **Log Sanitization (OWASP A09):** Removal of all debug print statements containing session headers or PII in release builds.

---

## Contributing

Pull requests are welcome! If you want to add or improve skills for other frameworks (e.g., Go, Rust, Tauri), feel free to open an issue or submit a PR.

---

## License

Licensed under the **Apache License, Version 2.0** (the "License"). You may obtain a copy of the License at:

```
[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

```
