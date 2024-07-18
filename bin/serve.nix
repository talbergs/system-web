{
  pkgs,
  nixpkgs,
  name,
  ...
}:
pkgs.writeShellApplication {
  inherit name;
  text = ''
    set +u
    if [ -z "$1" ];then
        echo " choose port number \$1"
        echo " choose cwd \$2"
        exit 1
    fi

    port="$1"
    cwd="$2"
    cmd="php -d post_max_size=16M -d max_execution_time=300 -S 0.0.0.0:$port"

    nixenv="/tmp/running-$(basename "$0").nix"
    cat >"$nixenv" <<EOF
    { ... }:
    let
        pkgs = import <nixpkgs> {};
    in
    pkgs.mkShell {
        packages = with pkgs; [ php ];
        shellHook = '''
        cd "$cwd"
        eval "$cmd"
        exit
        ''';
      }
    EOF

    ${pkgs.nix}/bin/nix-shell \
      -I nixpkgs="${nixpkgs}" \
      "$nixenv"
  '';
}
