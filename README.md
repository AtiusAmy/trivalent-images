# trivalent-images &nbsp; [![bluebuild build badge](https://github.com/atiusamy/trivalent-images/actions/workflows/build.yml/badge.svg)](https://github.com/atiusamy/trivalent-images/actions/workflows/build.yml)

This is basically a custom image of Aurora, Bluefin, and Bazzite that provides Trivalent alongside SELinux confinement

We currently provide

- [Bluefin(-dx)](https://projectbluefin.io/) (LTS,GDX,GTS,Stable,Latest)
- [Bazzite(-deck)](https://bazzite.gg/)
- [Aurora(-dx)](https://getaurora.dev/) (Stable,latest)

Aurora LTS will be added once it is ready, as well as [glacialis](https://github.com/glacialis-os/glacialis)

## Rationale

Flatpak Chromium browser currently doesn't work with the Chromium sandbox due to usernamespace limitations. It uses a hack called zypak that fakes part of the Chromium sandbox. Zypak is also maintained by a single person, which does not give confidence for the security issue. 

So I ended up using Trivalent from [secureblue](https://secureblue.dev/) due to the fastness of upgrade and the hardening inspired by Vanadium. Using SELinux confinement to achieve some of the security benefits of sandboxed apps.

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/atiusamy/<image_name>:latest
  ```
  ```
  bootc switch ghcr.io/atiusamy/<image_name>:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/atiusamy/<image_name>:latest
  ```
  ```
  bootc switch --enforce-container-sigpolicy ghcr.io/atiusamy/<image_name>:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/atiusamy/trivalent-images
```
