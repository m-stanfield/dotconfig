# NixOS Modular Configuration

This directory contains modular NixOS configuration options that can be enabled or disabled per host.

## Structure

```
modules/
├── features/         # System-level features
│   ├── autorandr.nix       # Automatic monitor configuration
│   ├── desktop-i3.nix      # i3 window manager + XFCE desktop
│   ├── docker.nix          # Docker containerization
│   └── virtualbox.nix      # VirtualBox virtualization
└── programs/        # Application programs
    ├── code-cursor.nix     # Cursor AI editor
    ├── libreoffice.nix     # LibreOffice suite
    ├── obs.nix             # OBS Studio
    └── steam.nix           # Steam gaming platform
```

## Usage

To enable features in a host configuration, add them to the `features` attribute:

```nix
# In hosts/<hostname>/configuration.nix
{
  features = {
    # Simple features (just enable/disable)
    desktop-i3.enable = true;
    docker.enable = true;
    steam.enable = true;
    obs.enable = true;
    code-cursor.enable = true;
    libreoffice.enable = true;

    # Features with additional options
    virtualbox = {
      enable = true;
      users = [ "matt" ];  # Users who can access VirtualBox
    };

    autorandr = {
      enable = true;
      profiles = {
        "my-profile" = {
          fingerprint = {
            DP-1 = "...";
          };
          config = {
            DP-1 = {
              enable = true;
              mode = "1920x1080";
              position = "0x0";
            };
          };
        };
      };
    };
  };
}
```

## Available Features

### Desktop & Window Management

- **desktop-i3**: i3 tiling window manager with XFCE desktop environment
- **autorandr**: Automatic monitor configuration with custom profiles

### Development Tools

- **docker**: Docker containerization platform
- **virtualbox**: VirtualBox virtualization (with configurable user access)
- **code-cursor**: Cursor AI code editor

### Applications

- **steam**: Steam gaming platform
- **obs**: OBS Studio for recording and streaming
- **libreoffice**: LibreOffice office suite

## Adding New Features

To add a new feature module:

1. Create a new file in `features/` or `programs/`
2. Define the module with options:

```nix
{ config, lib, pkgs, ... }:

with lib;

{
  options.features.my-feature = {
    enable = mkEnableOption "My Feature description";
  };

  config = mkIf config.features.my-feature.enable {
    # Your configuration here
  };
}
```

3. Add the import to `modules/default.nix`
4. Enable it in your host configuration

## Example: Different Configurations per Host

**Desktop** (full workstation):
```nix
features = {
  desktop-i3.enable = true;
  docker.enable = true;
  steam.enable = true;
  obs.enable = true;
  code-cursor.enable = true;
  libreoffice.enable = true;
  virtualbox.enable = true;
  autorandr.enable = true;
};
```

**Laptop** (portable development):
```nix
features = {
  desktop-i3.enable = true;
  docker.enable = true;
  code-cursor.enable = true;
  libreoffice.enable = true;
};
```

**Server** (headless):
```nix
features = {
  docker.enable = true;
};
```
