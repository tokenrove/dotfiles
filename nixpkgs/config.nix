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
        inetutils
        ncat nox
        pass
        psmisc
        screen silver-searcher sysstat
        tcpdump
        unrar unzip
        zsh
      ];
    };

    desktop = {
      paths = [
        dmenu dwm
        emacs
        firefox
        gimp
        imagemagick
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
        autoconf automake
        cargoNightly cppcheck
        erlangR19
        gcc6 gdb glibcInfo gnumake
        libtool
        man-pages mitmproxy musl
        ninja
        opam
        pkgconfig
        posix_man_pages python2 python3
        rebar3 rustNightly
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
