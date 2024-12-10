# nix-config

## Installation

- Install `bitwarden`
- Login to apple id

### 1. Create ssh keys for github

#### Generate key

```
mkdir -p ~/.ssh/github
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/github/id_ed25519
```

#### Start ssh-agent

```
eval "$(ssh-agent -s)"
```

#### Insert following to `~/.ssh/config` file 

```
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github/id_ed25519
```

#### Copy public key and insert in github settings

```
pbcopy < ~/.ssh/github/id_ed25519.pub
```


### 2. Install dependencies

```
xcode-select --install
```

### 3. Enable Rosetta

```
softwareupdate --install-rosetta --agree-to-license
```

### 4. Install Nix

Use installer from [Determinate Systems](https://determinate.systems/) for nice defaults and ability to [uninstall](https://zero-to-nix.com/start/uninstall/) nix easily later

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 5. Clone this repo

### 6. Install `nix-darwin` tools
```
nix run nix-darwin -- switch --flake ~/nix-config#simple
```

## Rebuild
For now config should be finished. Then after changing `flake.nix` file run following command to rebuild system
```
darwin-rebuild switch --flake ~/nix-config#simple
```