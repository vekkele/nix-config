{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    username = "vlad";
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      system = {
        # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
        activationScripts.postUserActivation.text = ''
          # activateSettings -u will reload the settings from the database and apply them to the current session,
          # so we do not need to logout and login again to make the changes take effect.
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';

        defaults = {
          dock = {
            autohide = true;
            autohide-delay = 0.1;
            autohide-time-modifier = 0.5;
            expose-group-apps = true;
            mineffect = "scale";
            mru-spaces = false;
            persistent-apps = [];
            persistent-others= [ "/Users/${username}/Downloads" ];
            show-process-indicators = true;
            show-recents = false;

            # bottom-right corner action. 
            wvous-br-corner = 4; # show desktop
          };

          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            CreateDesktop = false;
            FXPreferredViewStyle = "clmv";
            FXRemoveOldTrashItems = true;
            NewWindowTarget = "Home";
            ShowExternalHardDrivesOnDesktop = false;
            ShowPathbar = true;
            ShowRemovableMediaOnDesktop = false;
            ShowStatusBar = true;
          };

          hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";

          loginwindow.GuestEnabled = false;

          controlcenter.BatteryShowPercentage = true;
          controlcenter.Bluetooth = true;

          menuExtraClock.Show24Hour = true;

          trackpad = {
            ActuationStrength = 0;
            FirstClickThreshold = 0;
          };

          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            "com.apple.sound.beep.feedback" = 0;
          };

          CustomUserPreferences = {
            "com.apple.dock" = {
              showMissionControlGestureEnabled = 1;
              showAppExposeGestureEnabled = 1;
            };
            "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
              TrackpadFourFingerVertSwipeGesture = 0;
              TrackpadThreeFingerVertSwipeGesture = 2;
            };
            "com.apple.AppleMultitouchTrackpad" = {
              TrackpadFourFingerVertSwipeGesture = 0;
              TrackpadThreeFingerVertSwipeGesture = 2;
            };
          };
        };
      };

      homebrew = {
        enable = true;
        casks = [
          "bitwarden"
          "zen-browser"
          "firefox"
          "google-chrome"
          "wezterm"
          "iina"
          "qbittorrent"
          "appcleaner"
          "visual-studio-code"
          "keepingyouawake"
          "obsidian"
          "karabiner-elements"
          "raycast"
          "raindropio"
          "notion"
          "discord"
          "twingate"
          "jordanbaird-ice"
          "keycastr"
          "telegram"
        ];
        masApps = {
          "hidemynameVPN" = 1200692581;
        };
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;

            autoMigrate = true;
          };
        }
      ];
    };
  };
}
