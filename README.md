# Proton Mail Bridge Docker container

```bash
docker pull ghcr.io/travis-fm/proton-bridge:latest
```

This is an **unofficial** Docker container that implements the Proton Mail Bridge application, allowing it to be used by other containerized applications without having to use the host networking mode.

Core work is based off of [shenxn's protonmail-bridge-docker](https://github.com/shenxn/protonmail-bridge-docker) image, with some tweaks by myself to help simplify and automate the build process.

Automatic updates and telemetry are disabled by default in the image so that versioning can be handled via image tags instead.

## Image Tags

Images are currently built for `amd64`, `arm64`, and `riscv64`. Feel free to open an Issue if other architectures are needed.

Tags folow the following formats:

   Tag    | Description | Example
----------|-------------|---------
`latest` | The latest Bridge release (**includes pre-releases**) | `latest`
`v<major>` | The latest release in major version | `v3`
`<major>.<minor>` | The latest major/minor version | `3.24`
`<major>.<minor>.<patch>` | Specific version release | `3.24.2`
`edge` | Build based on latest `proton-bridge` submodule commit. Checked and updated daily | `edge`
`edge-<commit SHA>` | Build based on a specific `proton-bridge` commit. | `edge-0521645d`

If needed, a specific architecture can also be specified at the end of the tag, such as `latest-arm64` or `edge-0521645d-riscv64`.

## Usage

### Setup

1. Copy the [`docker-compose.yml`](docker-compose.yml) file into a directory.

2. Initialize the Bridge vault and enter the CLI:

    ```bash
    docker compose run --rm proton-bridge init
    ```

3. Enter `login`, then add your credentials. Once logged in, Bridge should start syncing your email.

4. Enter `info` to get the username/password needed to access the SMTP/IMAP server.
  
    4a. The [`docker-compose.yml`](docker-compose.yml) file exposes and maps 1025 and 1143 to regular ports 25 and 143 by default. Feel free to change this if desired.

5. (Optional) You can type `help` to check out other commands.
6. Once done, enter `exit` to leave the CLI.

### Running

Now start up the container as usual:

```bash
docker compose up -d
```

Bridge should now be ready to use!
