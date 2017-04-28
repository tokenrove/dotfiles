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
        dict dstat
        file
        git gnupg gnupg1
        htop
        inetutils irssi
        jq
        ncat nox
        parallel pass psmisc
        screen silver-searcher sysstat
        tcpdump
        unrar unzip
        zsh
      ];
    };

    desktop = {
      paths = [
        acpi
        dmenu dwm
        emacs
        firefox
        gimp
        imagemagick ipe
        mpv
        neomutt
        pinentry python35Packages.youtube-dl
        redshift
        scrot st sxiv
        unclutter urlview
        xsel
        zathura
      ];
    };

    devel = {
      paths = [
        autoconf automake
        cargoNightly cppcheck
        erlangR19 exercism
        gcc6 gdb glibcInfo gnumake
        kcov
        libtool
        man-pages mitmproxy musl
        ninja
        opam
        perf-tools pkgconfig posix_man_pages python2 python3
        rebar3 rr rustNightly
        sbcl sbt shellcheck
        valgrind
        zeal zlib zlibStatic
      ];
    };

    all = buildEnv {
      name = "all";
      paths = base.paths ++ desktop.paths ++ devel.paths;
    };
  };
}
