# DeepSeek Harness on Docker Compose

This community deployment runs the official `@deepseek-ai/dsh` npm package in a non-root Node.js container. It pins DeepSeek Harness to `0.2.3-alpha.2` and uses separate named volumes for settings and workspace files.

## Start

```sh
git clone https://github.com/bob798/deepseek-harness-docker.git
cd deepseek-harness-docker
docker compose up -d --build
docker compose logs -f harness
```

Open the full startup URL printed in the logs, including its sign-in token, and configure your model provider in the Web UI. Treat that URL like a password. The container starts without model credentials. Sign-in and model availability depend on your provider.

## Run on a NAS

Run the same Compose commands on the NAS. The default port is bound to the NAS loopback interface. To reach it from your computer, forward it over SSH:

```sh
ssh -N -L 3080:127.0.0.1:3080 user@nas
```

Then open the full startup URL from the NAS container logs on your computer. If you change the published port, set `DSH_PORT`, `DSH_PUBLIC_URL`, and `DSH_TRUSTED_HOST` together in a local `.env` file. For example:

```dotenv
DSH_PORT=3081
DSH_PUBLIC_URL=http://localhost:3081
DSH_TRUSTED_HOST=localhost:3081
```

Keep the port on loopback unless you have configured authenticated access. See the [upstream safety notes](https://github.com/deepseek-ai/deepseek-harness/blob/master/SAFETY.md).

## Data and maintenance

- `harness-data` stores the Harness profile, sessions, and configuration under `/home/node/.dsh`.
- `harness-workspace` stores files under `/workspace`, the container's starting directory.
- `docker compose down` stops the stack and preserves both volumes. Back up your volumes before upgrades. The `--volumes` flag deletes them.
- To use a different release, update the `DSH_VERSION` default in the Dockerfile and rebuild with `docker compose up -d --build`.

The container runs the Web UI. LiveShare requires its own configuration and a compatible relay. This deployment was created in response to [upstream discussion #9440](https://github.com/deepseek-ai/deepseek-harness/discussions/9440).

## Build the Intel macOS desktop DMG

Run this on macOS with Xcode Command Line Tools, Node.js 24.22.3 or later in the 24.x series (or 26.13.1 or later), and pnpm 11.28.5. Use a Node.js installation that includes the Node-API development headers. The script clones the pinned upstream release into `.build/upstream` and runs its Intel packaging command.

```sh
./build-macos-intel.sh
```

The upstream packager prints the DMG path when successful. This local build uses ad-hoc app signing and produces an unsigned, unnotarized DMG. DeepSeek also provides an [official Intel macOS download](https://download.deepseek.com/desktop/dsh-latest-macos-x64.dmg). See [discussion #8807](https://github.com/deepseek-ai/deepseek-harness/discussions/8807).
