# 🦅 Simorgh — Telegram Guardian Bot

> **قدرت، امنیت و مدیریت هوشمند در یک ربات**
>
> Simorgh is the Guardian/administration bot track built around PediGuardian. It is designed for secure Telegram group administration, role-aware controls, lightweight games, Voice Chat utilities, AI access, and Supabase-backed state/audit.

![Version](https://img.shields.io/badge/version-4.7.0-0ea5e9)
![Telegram](https://img.shields.io/badge/platform-Telegram-229ED9)
![Java](https://img.shields.io/badge/runtime-Java%2021-orange)
![Supabase](https://img.shields.io/badge/backend-Supabase-3ECF8E)
![Security](https://img.shields.io/badge/security-RBAC%20%2B%20native%20permissions-success)

## ✨ What is Simorgh?

Simorgh is a Telegram group guardian and administration controller. Its design separates **Bot Owner authority**, **Group Owner authority**, and ordinary administrative roles, while checking Telegram's current native permissions before privileged operations.

The 4.7.0 track is deliberately lightweight: media/music remains a separate service, while Guardian responsibilities stay focused on moderation, security, administration, games, Voice Chat utilities, AI gateway access, and persistent configuration/audit.

## 🧭 Core capabilities

### 👑 Role & permission system

Simorgh supports role-aware access including:

- `BOT_OWNER`
- `GROUP_OWNER`
- `SENIOR_ADMIN`
- `ADMIN`
- `MODERATOR`
- `HELPER`
- `MEMBER`
- `RESTRICTED`

Important security rule: a database role is not treated as sufficient proof of Telegram authority. Privileged actions must be checked against the current Telegram membership/admin state.

### 🛡️ Group security & moderation

The command engine includes the administration/security family for:

- warnings and warning limits
- mute / unmute
- ban / unban
- kick / delete
- pin / unpin
- locks / unlocks
- anti-spam
- anti-link
- anti-raid controls
- security status
- admin listing and permission management
- notes and filters
- welcome/rules configuration
- audit/reporting hooks

Actual command availability is role- and permission-dependent; the Glass panel is intended to expose only controls that the current actor is authorized to use.

### 🪟 Glass Panel

The Glass Panel is the operator-facing control surface. It is designed around:

`Role + Permission + Current Telegram State + Persisted Group Settings`

rather than a static menu that exposes every administrative operation to everyone.

### 🎮 Games

Simorgh keeps lightweight, non-gambling entertainment inside the Guardian experience:

#### ✈️ Air Raider

A browser Mini App inspired by the visual language of classic river-flight arcade games, implemented as an original lightweight game.

#### 🎲 Backgammon

A browser Mini App with a responsive board, dice, legal movement, hit/re-entry, bear-off and lightweight AI. It has **no betting or monetary mechanics**.

#### 🎡 Voice Chat Wheel

A fair random selection utility for members who are **currently present in the Voice Chat at invocation time**.

Design rules:

- no betting
- no money
- no historical weighting
- no attendance-history scoring
- no fabricated participants
- current Voice Chat roster is the source for selection
- the worker resolves the internal group ID to the Telegram chat ID before MTProto operations

### 🎙️ Voice Worker

Voice Chat operations that require MTProto are isolated into a separate persistent worker. The worker is not a second Guardian and does not own Telegram Bot API updates.

Production separation:

```text
Telegram Bot API
      │
      ▼
Supabase Edge Function / Guardian Core
      │
      ├── PostgreSQL
      ├── audit/access/config
      └── Voice job queue
                │
                ▼
        Railway Voice Worker
                │
                └── MTProto Voice Chat roster
```

### 🤖 AI Gateway

AI access is designed as a gateway rather than embedding provider secrets in the bot source. Provider integrations/fallbacks can be enabled independently while keeping credentials outside Git.

### 🗄️ Supabase integration

Supabase is used for persistent application state, access/configuration, queues and audit-oriented data.

The important data model distinction is:

- `groups.id` → internal database primary key
- `groups.telegram_chat_id` → Telegram chat identifier

Internal foreign keys should use `groups.id`; Telegram API calls use `telegram_chat_id`.

### 🎵 Media/Music separation

Music/media playback is intentionally **not part of the Guardian core**. A separate music/media bot or worker can operate independently so that media failures cannot take down Guardian administration and security.

## 📋 Command families

The 4.7 command engine is designed around these command families:

| Area | Commands / examples |
|---|---|
| General | `/start`, `/help`, `/version`, `/id`, `/profile`, `/language`, `/status` |
| Panel | `/panel`, `/settings` |
| Moderation | `/warn`, `/warnings`, `/clearwarnings`, `/mute`, `/unmute`, `/ban`, `/unban`, `/kick`, `/del` |
| Messages | `/pin`, `/unpin` |
| Locks | `/lock`, `/unlock`, `/lockall`, `/unlockall`, `/locks` |
| Security | `/antispam`, `/antilink`, `/security`, `/antiraid` |
| Admin/RBAC | `/admins`, `/addadmin`, `/removeadmin`, `/grantperm`, `/revokeperm`, `/perms` |
| Rules/notes | `/rules`, `/setrules`, `/note`, `/notes`, `/delnote` |
| Welcome/filter | `/welcome`, `/setwelcome`, `/filter`, `/filters`, `/badword` |
| AI | `/ai`, `/aistatus` |
| Games | `/game`, `/emoji`, `/wheel` / voice-order flow |
| Voice | `/voiceorder` |
| Group access | `/trial`, `/extend`, `/groups` |
| Reports | `/report`, `/reports` |

> Exact aliases and UI callbacks can vary by deployed command-engine build. The server remains authoritative for authorization.

## 🔐 Security model

Simorgh follows a defense-in-depth model:

1. **Actor identification** — identify the Telegram user and chat.
2. **Role resolution** — resolve the application role.
3. **Telegram-native verification** — verify the user's current membership/admin state when an action requires it.
4. **Permission check** — verify the requested capability.
5. **Target validation** — validate target user/chat/resource.
6. **Action execution** — call Telegram/Supabase only after authorization.
7. **Audit** — record security-sensitive actions where configured.

This prevents a stale database role from becoming permanent administrative access after a user is demoted or removed in Telegram.

## 🌐 Production architecture

```text
                         ┌──────────────────────┐
                         │       Telegram       │
                         └──────────┬───────────┘
                                    │ Webhook
                                    ▼
                    ┌────────────────────────────┐
                    │ Supabase Edge / Guardian   │
                    │ Telegram Update Owner      │
                    └────────────┬───────────────┘
                                 │
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                  ▼
        PostgreSQL          Queue / Jobs        Admin API
              │                  │
              │                  ▼
              │          Railway Voice Worker
              │                  │
              │                  ▼
              │          MTProto Voice Chat
              │
              └──── config / RBAC / audit

        Mini Apps: Air Raider / Backgammon / Wheel

        Media/Music → separate service
```

## 🧪 Deployment principles

- Keep secrets in environment variables or platform secret stores.
- Never commit bot tokens, Telegram user-session strings, Supabase service-role keys, AI provider keys, or webhook secrets.
- Back up `.env` before a Termux upgrade.
- Do not run two independent production Telegram Update owners for the same bot token.
- Prefer the Serverless/Supabase webhook as the production update owner when deployed.
- Keep the Java controller available for development/recovery rather than allowing competing polling/webhook processes.

## 📱 Termux recovery/development

The Java package can be used for development or emergency recovery on Termux. The release updater is backup-first and is designed to preserve the existing `.env`.

Example activation pattern:

```bash
cd ~/PediGuardian/PediGuardianJava && \
set -a && . ./.env && set +a && \
DEPLOYMENT_MODE=local java -jar pedi-guardian-java-4.7.0.jar
```

Before switching production ownership, verify the Telegram webhook state and stop any competing local polling/webhook process.

## 📦 Release artifacts

The validated 4.7.0 release track includes:

- `pedi-guardian-java-4.7.0.jar`
- `PediGuardian-4.7.0-java-source.zip`
- backup-first Termux updater
- Supabase webhook/game integration track
- Voice Worker integration track
- Air Raider and Backgammon Mini Apps

## 🖼️ Branding

Recommended Telegram BotFather profile image:

- square canvas
- high-contrast Simorgh phoenix emblem
- minimal small text
- blue/gold identity
- readable at small avatar size

Recommended BotFather command/menu organization:

```text
/start      شروع
/help       راهنما
/panel      پنل مدیریت
/status     وضعیت
/security   امنیت
/game       بازی‌ها
/ai         هوش مصنوعی
/rules      قوانین
```

For the bot profile/avatar, prioritize the emblem over detailed text because Telegram renders the image at small sizes.

## 🧩 Repository structure

The repository contains the Simorgh release track and upgrade documentation. The larger PediGuardian production architecture is maintained separately so that Simorgh can remain operationally isolated.

Suggested production layout:

```text
Simorgh/
├── PediGuardianJava/
│   ├── pedi-guardian-java-4.7.0.jar
│   ├── PediGuardian-4.7.0-java-source.zip
│   └── UPDATE-4.7.0.sh
├── docs/
├── games/
└── README.md
```

## ⚠️ Operational boundaries

Simorgh is a group guardian, not a replacement for Telegram itself. Telegram remains the authority for live membership and administrator permissions. Supabase stores application state and audit/configuration data but must not silently override Telegram's current authorization state.

Games are entertainment features only. The Voice Chat wheel is a random selection utility and is not a gambling mechanism.

## 🚀 Roadmap

- complete command-engine parity across all deployed surfaces
- automated integration tests against a staging bot
- webhook health/ownership verification
- stronger callback replay/idempotency tests
- complete Mini App deployment URLs and signed launch validation
- Voice Worker production health/claim monitoring
- owner dashboard and group inventory
- expanded audit observability

## 📜 Release

**Current documented release:** `4.7.0`

The release artifact hashes and upgrade contract are recorded in `RELEASE-4.7.0.md`.

---

### 🦅 Simorgh

**یک ربات؛ امنیت، مدیریت و سرگرمی هوشمند برای گروه.**
