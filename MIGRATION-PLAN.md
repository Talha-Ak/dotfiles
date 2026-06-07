# Refactoring to the Dendritic Pattern — Migration Plan

## Context

This repository is a Nix flake managing two environments:

| Host | OS | Purpose |
|---|---|---|
| **caelid** | NixOS | Laptop (Intel + NVIDIA Optimus, Hyprland) |
| **limgrave** | WSL (Windows) | No NixOS, only home-manager under Debian |

Both are used by a single user (`talha`). The current code has the right skeleton but doesn't follow the Dendritic pattern properly.

## What is the Dendritic Pattern?

The Dendritic pattern ([doc](https://github.com/Doc-Steve/dendritic-design-with-flake-parts/wiki/Basics), [reference](https://github.com/mightyiam/dendritic)) is a way to structure Nix configurations around **features** rather than hosts. Key principles:

1. **Every `.nix` file** under `modules/` is a flake-parts module (top-level module). No exceptions.
2. **Auto-import** via `vic/import-tree` — files are discovered automatically, no manual `import` chains.
3. **Feature-centric** — a "hyprland" feature defines both NixOS config and home-manager config in one place (co-located), even though they evaluate separately.
4. **Hosts are thin** — a host file is just an `imports` list of features.
5. **No `specialArgs` pass-through** — values are shared through the flake module system.

## Current Architecture (Before)

```
flake.nix → import-tree ./modules/
  ├─ modules/hosts/caelid/
  │   ├─ default.nix           → nixosConfigurations.caelid
  │   │                           (thin, delegates to caelidConfiguration)
  │   ├─ configuration.nix     → 211-line monolith (every system setting)
  │   └─ hardware.nix          → filesystems + kernel modules
  ├─ modules/home/
  │   └─ default.nix           → homeConfigurations for both hosts
  ├─ nixos/hosts/caelid/       ← OUTSIDE modules/ — not flake-parts modules
  │   ├─ nvidia.nix
  │   └─ laptop.nix
  └─ home/                     ← OUTSIDE modules/ — not flake-parts modules
      ├─ modules/
      │   ├─ default.nix       → shared home base (bash, git, direnv, nvim)
      │   └─ nvim.nix
      └─ talha/
          ├─ caelid.nix        → per-host home config (DMS, hypr, gtk, apps)
          └─ limgrave.nix      → per-host home config (WSL, SSH agent, PS1)
```

### Problems

1. **Files outside `modules/` are NOT flake-parts modules** — `nixos/` and `home/` files are plain NixOS/home-manager modules with no dendritic aspect registration. They're imported via brittle relative paths (`../../../`).

2. **No cross-cutting features** — Hyprland system config is in `configuration.nix`, Hyprland user config is in `home/talha/caelid.nix`. No connection between them. Adding Hyprland to a new host means remembering both places.

3. **Monolithic host composition** — `configuration.nix` (211 lines) is a flat blob of everything. Hosts should be an `imports` list of named features.

4. **Separate concerns, not features** — Files are organized by **config class** (`nixos/` vs `home/`) rather than by **feature** (`hyprland/`, `bluetooth/`, `pipewire/`).

5. **Home-manager uses traditional API** — `home-manager.lib.homeManagerConfiguration` instead of composing from `flake.modules.homeManager.*` aspects.

### Current approach (deviations from canonical Dendritic)

The following deliberate deviations were made during migration to keep things working with minimal infrastructure:

| Deviation | Reason |
|---|---|
| `flake.modules.nixos.*` → `flake.nixosModules.*` → **`flake.modules.nixos.*`** (now reverted) | `flake.modules` requires importing `inputs.flake-parts.flakeModules.modules`. Now handled in `flake.nix`. |
| `flake.modules.homeManager.*` → `flake.homeManagerModules.*` → **`flake.modules.homeManager.*`** (now reverted) | Same as above. Now uses canonical pattern. |
| `system` hardcoded in host `let` blocks | Not available in flake-parts module scope; host files need it for `nixosSystem`/`legacyPackages`. |
| `pkgs-unstable` destructured in home-manager module signatures | Required by Nix function semantics; `extraSpecialArgs` only makes it available, doesn't inject. |
| `flake.homeConfigurations` option declared manually | Not a standard flake-parts option; cross-file merge requires explicit `lazyAttrsOf` declaration.

## Target Architecture (After)

```
flake.nix → import-tree ./modules/
│
├── users/
│   └── talha.nix             → flake.modules.homeManager.talha (shared identity + base)
│
├── hosts/
│   ├── caelid/
│   │   ├── default.nix       → nixosConfigurations.caelid + homeConfigurations."talha@caelid"
│   │   └── _hardware.nix     → UUIDs, kernel modules, microcode (IGNORED by import-tree)
│   └── limgrave.nix          → homeConfigurations."talha@limgrave"
│
├── hyprland.nix              → flake.modules.nixos.hyprland + flake.modules.homeManager.hyprland (Multi Context Aspect)
├── hardware/
│   ├── nvidia-optimus.nix    → NVIDIA Prime (offload) — reusable
│   └── laptop.nix            → TLP, thermald, libinput — reusable
│
├── boot.nix                  → systemd-boot, plymouth, quiet kernel
├── nix-settings.nix          → nix config, nh, experimental-features
├── networking.nix            → hostname, NetworkManager, iwd
├── locale.nix                → timezone, locale, keymap
├── bluetooth.nix
├── graphics.nix              → Intel media driver, VA-API
├── docker.nix
├── power.nix                 → upower, power-profiles-daemon
├── printing.nix              → avahi, cups
├── pipewire.nix              → pipewire, rtkit
├── tailscale.nix
├── flatpak.nix
├── greetd.nix                → greetd + tuigreet
├── steam.nix
├── adb.nix
├── system-packages.nix       → kitty, vim, wl-clipboard, pciutils
├── fonts.nix                 → nerd-fonts
├── nix-ld.nix
├── user.nix                  → talha user (NixOS side: extraGroups, isNormalUser)
│
├── shell.nix                 → home: bash aliases, packages (git, vim, curl, wget, btop)
├── git.nix                   → home: git config
├── direnv.nix                → home: direnv + nix-direnv
├── yazi.nix                  → home: yazi
├── nvim.nix                  → home: neovim
├── gtk.nix                   → home: catppuccin gtk theme
├── desktop-apps.nix          → home: discord, vesktop, spotify, bitwarden, nautilus, chromium, thunderbird, grim/slurp/satty
└── wsl.nix                   → home: npiperelay + socat SSH agent, custom PS1
```

### Key Characteristics

- **Every file (with one exception) is a flake-parts module** — the exception is `hosts/<name>/_hardware.nix`. The `_` prefix tells import-tree to skip it. The host's `default.nix` imports it manually as a plain NixOS module. This means `nixos-generate-config --show-hardware-config > _hardware.nix` works with zero modification.
- **Features, not config classes** — a feature like `hyprland.nix` defines both `flake.modules.nixos.hyprland` and `flake.modules.homeManager.hyprland` in one file. They still evaluate separately (host picks NixOS aspects, homeConfig picks homeManager aspects).
- **Hosts own everything** — `hosts/caelid/default.nix` defines the full machine: both `nixosConfigurations.caelid` (composed from nixos aspects) and `homeConfigurations."talha@caelid"` (composed from homeManager aspects). `hosts/limgrave.nix` defines only `homeConfigurations."talha@limgrave"` since there's no NixOS system.
- **User as a reusable aspect** — `users/talha.nix` defines the shared user identity (username, homeDirectory) that both hosts import. Not the host-specific home composition — that belongs in the host file.

## Migration Phases

### Tier 2 — Pattern Adoption

**Goal**: Add dendritic patterns that improve maintainability but aren't strictly required.

#### Phase 2.1 — Add shared constants (Generic Aspect)

**`modules/system-constants.nix`**
```nix
{ lib, ... }: {
  options.systemConstants = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.systemConstants = {
    username = "talha";
    email = "git@talhaak.com";
    hostPlatform = "x86_64-linux";
  };

  flake.modules.generic.systemConstants = {
    options.systemConstants = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };

    config.systemConstants = {
      username = "talha";
      email = "git@talhaak.com";
      hostPlatform = "x86_64-linux";
    };
  };
}
```

Then create a `system-default` feature that imports it and makes it available to both NixOS and HM contexts.

#### Phase 2.2 — Create mkNixos / mkHome helper functions

Add a `modules/lib.nix` that provides:
- `mkNixos` — wraps `nixpkgs.lib.nixosSystem` with sensible defaults
- `mkHome` — wraps `home-manager.lib.homeManagerConfiguration`

These reduce boilerplate in host files.

#### Phase 2.3 — Use Inheritance Aspect for layered features

Create a feature hierarchy:
- `system-cli.nix` → `imports = [ nix-settings locale shell git direnv yazi nvim ];`
- `system-desktop.nix` → `imports = [ system-cli boot networking bluetooth graphics docker power printing pipewire tailscale flatpak greetd steam adb system-packages fonts nix-ld user hyprland ];`

Then hosts can just import `system-desktop` instead of listing 20+ features.

### Tier 3 — Polish

**Goal**: Nice-to-haves that align with the reference repos.

#### Phase 3.1 — Adopt `vic/flake-file`

Lets individual modules declare their own flake inputs. For example, `hyprland.nix` would declare:
```nix
flake-file.inputs.dms = {
  url = "github:AvengeMedia/DankMaterialShell/stable";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

This removes the need to centrally manage inputs in `flake.nix`. Run `nix run .#write-flake` to regenerate `flake.nix` after changes.

#### Phase 3.2 — Add devShells, formatter, checks

```nix
flake.devShells.default = { pkgs, ... }: {
  packages = [ pkgs.nixfmt pkgs.nil ];
};
flake.formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
```

#### Phase 3.3 — Use `_` prefix for disabled modules

import-tree ignores any file with `_` in its path. Temporary disable by prepending `_` (e.g., `_broken-feature.nix` or `_experiments/`).

## Important Notes on import-tree Behavior

`vic/import-tree` ignores any file or directory with `_` as a path component. This means:

- `hosts/caelid/_hardware.nix` — **skipped** by import-tree, perfect for `nixos-generate-config` output
- `_disabled-feature.nix` — skipped, good for WIP modules
- `_experiments/something.nix` — entire directory skipped

This is the canonical way to keep non-flake-parts files inside the `modules/` tree without breaking auto-import.

## Risks and Notes

1. **`pkgs-unstable`** — The caelid host needs to pass `pkgs-unstable` to HM for `dgop` (in DMS). The host file handles this with `extraSpecialArgs`.

2. **`input.dms` and `inputs.catppuccin`** — These are currently imported in `home/talha/caelid.nix`. After migration, the host file needs to handle these. Either:
   - Define them globally in `flake.nix` (current approach, simplest)
   - Or use `flake-file` (Phase 3.1) to let modules declare their own inputs

3. **Catppuccin** — Referenced in `home/talha/caelid.nix` as `inputs.catppuccin.homeModules.catppuccin`. Move this into `modules/gtk.nix`:
   ```nix
   flake.modules.homeManager.gtk = { inputs, ... }: {
     imports = [ inputs.catppuccin.homeModules.catppuccin ];
     # ... gtk config
   };
   ```

4. **Symlinked dotfiles** — `dots/.config/{foot,hypr,uwsm,yazi,nvim}` are symlinked via `mkOutOfStoreSymlink`. These don't live under `modules/` and don't need to move. They're assets, not Nix config.

5. **Wallpaper** — `wall/wallhaven-2keqwx.png` is referenced by absolute path in the DMS config. This is fine as-is.

6. **Test the migration** — After completing a phase, run:
   ```bash
   nix flake check
   nix build .#nixosConfigurations.caelid.config.system.build.toplevel
   nix build .#homeConfigurations."talha@caelid".activationPackage
   nix build .#homeConfigurations."talha@limgrave".activationPackage
   ```

## File Map: Before → After

| Before | After |
|---|---|
| `flake.nix` | `flake.nix` (unchanged structurally) |
| `modules/hosts/caelid/default.nix` | `modules/hosts/caelid/default.nix` (rewritten) |
| `modules/hosts/caelid/configuration.nix` | _deleted_ (content → feature files) |
| `modules/hosts/caelid/hardware.nix` | `modules/hosts/caelid/_hardware.nix` (renamed) |
| `modules/home/default.nix` | _deleted_ (content → `modules/hosts/*.nix`) |
| `nixos/hosts/caelid/nvidia.nix` | `modules/hardware/nvidia-optimus.nix` |
| `nixos/hosts/caelid/laptop.nix` | `modules/hardware/laptop.nix` |
| `home/modules/default.nix` | `modules/shell.nix`, `modules/git.nix`, `modules/direnv.nix`, `modules/yazi.nix` |
| `home/modules/nvim.nix` | `modules/nvim.nix` |
| `home/talha/caelid.nix` | `modules/hyprland.nix` (hypr part), `modules/gtk.nix`, `modules/desktop-apps.nix` |
| `home/talha/limgrave.nix` | `modules/wsl.nix` |
| — | `modules/users/talha.nix` (new) |
| — | `modules/boot.nix` (new) |
| — | `modules/nix-settings.nix` (new) |
| — | `modules/networking.nix` (new) |
| — | `modules/locale.nix` (new) |
| — | (plus all other extracted feature files) |
