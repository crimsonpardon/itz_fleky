<div align="center">

# ⚡ EVM Bot V2

**Invite-based VPS Discord bot — LXD containers, SSH in seconds, slash + prefix commands.**

![Python](https://img.shields.io/badge/PYTHON-3776AB?style=for-the-badge&logo=python&logoColor=white)
![discord.py](https://img.shields.io/badge/DISCORD.PY-5865F2?style=for-the-badge&logo=discord&logoColor=white)
![Ubuntu](https://img.shields.io/badge/UBUNTU_24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLITE-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Commands](https://img.shields.io/badge/COMMANDS-41-0B8FD4?style=for-the-badge)
![Prefix](https://img.shields.io/badge/PREFIX-*-0B8FD4?style=for-the-badge)

</div>

---

## 💫 About Bot:

Invite people → they earn credits → they claim a VPS plan → the bot builds an Ubuntu 24.04 LXD container and DMs the SSH login.

- 🎟️ Invite tracking with leaderboard
- 🖥️ One-click VPS claim with plan dropdown
- 🔐 SSH over Pinggy tunnel, credentials sent by DM only
- 🌐 SSHX browser terminal
- 🛠️ Admin tools: create, delete, suspend, unsuspend, expiry
- ⚡ **Every command works as `/slash` and `*prefix`**
- 🎨 Blue `About` and `Help` menus with live statistics

---

## 🚀 Quick Start:

```bash
git clone https://github.com/crimsonpardon/evm-bot.git
cd evm-bot
sudo bash install.sh
```

Then configure and run:

```bash
nano .env
.venv/bin/python bot.py
```

Set `DISCORD_TOKEN` and `OWNER_ID` in `.env`. Keep `ENABLE_LXD_PROVISIONING=false` until LXD storage quotas, networking and firewall are tested.

**Run in background (optional):**

```bash
nohup .venv/bin/python bot.py > bot.log 2>&1 &
```

**Update later:**

```bash
cd evm-bot && git pull && .venv/bin/pip install -r requirements.txt
```

---

## ⚙️ Discord Setup:

In the Discord Developer Portal enable:

- ✅ **Message Content Intent**
- ✅ **Server Members Intent**

Invite the bot with the `bot` and `applications.commands` scopes. For invite tracking it needs **Manage Server**.

---

## 📚 Commands:

Use `/command` or `*command`. Open the menu with `*help`.

| Category | Commands |
|---|---|
| 🏠 General | `home` `help` `quickhelp` `ping` `about` `faq` `info` `invite` `developer` `setprefix` |
| 🖥️ VPS | `vps create` `vps info` `manage` `ssh` `console` `web` `password` `pin` `upgrade` `changeos` `share` `unshare` |
| 🎟️ Invites | `invites` `invites top` `invited` `inviter` `claim` `plans` `addinvite` |
| 📈 Monitoring | `dashboard` `live` `top` `graph` `status` `serverstats` `vps-stats` `vpsusage` |
| 🔢 Ports | `ports list` `ports add` `ports remove` |
| 🐋 Nodes | `node` |
| 🛠️ Admin | `setplan` `delplan` `claimstatus` `vpsadmin` |

### 🛠️ VPS management

- `*manage` — list your VPS
- `*manage 7` — DM connection details
- `*manage 7 start | stop | restart` — power controls
- `*manage 7 sshx` — private browser terminal link by DM
- `*manage 7 reinstall CONFIRM` — ⚠️ wipes the container and rebuilds it

### 👑 Admin VPS commands

- `*vpsadmin create @member PLAN [days]` — expiry defaults to 30 days, `0` = never
- `*vpsadmin delete <claim_id>`
- `*vpsadmin suspend <claim_id>` / `unsuspend <claim_id>`
- `*vpsadmin expiry <claim_id> <days>`

---

## 🔌 How SSH Works:

Containers are published through a **Pinggy TCP tunnel**, so no public IPv4 is needed. The login DM contains the hostname, port, username, password and a ready-to-paste Termux command.

- Needs the OpenSSH client on the host and outbound access to `free.pinggy.io:443`
- Free tunnels can change or expire — keep the bot running
- Pinggy publishes SSH only, not game ports

---

## 🧪 LXD Image:

```bash
lxc image list ubuntu:
lxc launch ubuntu:24.04 evm-test
lxc exec evm-test -- cat /etc/os-release
```

---

## ⚠️ Safety Notes:

- LXD creates **containers**, not full KVM virtual machines.
- The `lxc` command must work for the same Linux user that runs the bot.
- Passwords are stored in SQLite so they can be re-sent — protect `evm_bot.db` and `.env`.
- SSHX links grant a root terminal. Never share them.
- Use only infrastructure you own or are allowed to administer.

---

## 🌐 Socials:

![Discord](https://img.shields.io/badge/DISCORD-5865F2?style=for-the-badge&logo=discord&logoColor=white)
![Instagram](https://img.shields.io/badge/INSTAGRAM-E4405F?style=for-the-badge&logo=instagram&logoColor=white)
![YouTube](https://img.shields.io/badge/YOUTUBE-FF0000?style=for-the-badge&logo=youtube&logoColor=white)
![Email](https://img.shields.io/badge/EMAIL-D14836?style=for-the-badge&logo=gmail&logoColor=white)

---

## 💻 Tech Stack:

![Python](https://img.shields.io/badge/PYTHON-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/SHELL-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLITE-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![LXD](https://img.shields.io/badge/LXD-333333?style=for-the-badge&logo=linuxcontainers&logoColor=white)
![Ubuntu](https://img.shields.io/badge/UBUNTU-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

---

## 📊 GitHub Stats:

<div align="center">

<img src="https://github-readme-stats.vercel.app/api?username=crimsonpardon&show_icons=true&theme=dark&hide_border=true" alt="GitHub Stats" height="170" />
<img src="https://github-readme-stats.vercel.app/api/top-langs/?username=crimsonpardon&layout=compact&theme=dark&hide_border=true" alt="Top Languages" height="170" />

<img src="https://streak-stats.demolab.com/?user=crimsonpardon&theme=dark&hide_border=true" alt="Streak" />

</div>

---

## 🏆 GitHub Trophies:

<div align="center">

<img src="https://github-profile-trophy.vercel.app/?username=crimsonpardon&theme=onedark&no-frame=true&column=7" alt="Trophies" />

</div>

---

<div align="center">

**Developed by mowaz_official** • Made with ❤️ for Discord hosting communities

![Views](https://komarev.com/ghpvc/?username=crimsonpardon&label=Profile%20views&color=0B8FD4&style=flat)

</div>
