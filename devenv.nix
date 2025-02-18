{pkgs, ...}: let
  erlang = pkgs.beam.packages.erlangR26;
  elixir = erlang.elixir_1_15;
  elixir-ls = erlang.elixir-ls.override {elixir = elixir;};
in {
  env.LANG = "en_US.UTF-8";
  env.ERL_AFLAGS = "-kernel shell_history enabled";

  enterShell = ''
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export PATH=$PATH:$(pwd)/_build/pip_packages/bin
  '';

  packages = with pkgs; [
    inotify-tools
  ];

  languages.elixir = {
    enable = true;
    package = elixir;
  };

  services.postgres = {
    enable = true;
    initialScript = ''
      CREATE USER postgres WITH ENCRYPTED PASSWORD 'postgres' CREATEDB CREATEROLE;
    '';
  };
}
