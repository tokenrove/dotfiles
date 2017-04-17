{ pkgs }:
{
  allowUnfree = true;

  dwm = pkgs.dwm.override { patches = [ ./dwm-mod4.patch ]; };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  zathura.useMupdf = true;

  packageOverrides = super: let pkgs = super.pkgs; in with pkgs; rec {
    rustPackages = pkgs.callPackage /home/julian/.nixpkgs/rust-nightly-nix {};

    cargoNightly = rustPackages.cargo {};
    rustcNightly = rustPackages.rustc {};

    rustNightly = rustPackages.rustcWithSysroots {
      rustc = rustcNightly;
      sysroots = [
        (rustPackages.rust-std { })
        (rustPackages.rust-std { system = "x86_64-unknown-linux-musl"; })
      ];
    };

    base = {
      paths = [
        curl
        git gnupg gnupg1
        nox
        pass
        screen silver-searcher
        zsh
      ];
    };

    desktop = {
      paths = [
        dmenu dwm
        emacs
        firefox
        mpv
        neomutt
        pinentry python35Packages.youtube-dl
        redshift
        scrot st sxiv
        unclutter
        xsel
        zathura
      ];
    };

    devel = {
      paths = [
        cargoNightly cppcheck
        erlangR19
        gcc6 gdb glibcInfo gnumake
        man-pages
        ninja
        opam
        posix_man_pages
        rebar3 rustNightly
        sbcl shellcheck
        valgrind
      ];
    };

    all = buildEnv {
      name = "all";
      paths = base.paths ++ desktop.paths ++ devel.paths;
    };
  };
}
