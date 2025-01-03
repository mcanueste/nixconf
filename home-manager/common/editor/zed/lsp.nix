{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.zed-editor = {
    extraPackages = [
      # bash
      pkgs.shellcheck
      pkgs.shfmt

      # ansible
      # pkgs.ansible-lint # FIX: failing on nix

      # go
      pkgs.gopls

      # rust
      pkgs.rust-analyzer
      pkgs.clippy

      # nix
      pkgs.nixd
      pkgs.alejandra
    ];

    extensions = [
      # theme
      "catppuccin"

      # aux tools
      "snippets"
      "log"
      "csv"
      "mermaid"
      "sql"
      "tmux"
      "toml"

      # bash
      "basher"
      "fish"

      # makefile & just
      "make"
      "just"

      # docker & k8s
      "dockerfile"
      "docker-compose"
      "helm"

      # ansible
      "ansible"

      # terraform
      "terraform"

      # nix
      "nix"

      # lua
      "lua"

      # python - `pyright` native | TODO: based-pyright?
      "ruff"

      # go
      "golangci-lint"

      # rust
      "cargo-tom"

      # web & javascript - TODO
      "html"
      "graphql"

      # c/c++
      "meson"
      "neocmake"

      # godot
      "gdscript"

      # other
      "groovy"
    ];

    userSettings = {
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      inlay_hints.enabled = true;

      inline_completions.disabled_globs = [
        # disable completions from these files
        ".env"
        ".venv"
        ".direnv"
      ];

      load_direnv = "shell_hook"; # load direnv automatically

      file_types = {
        Dockerfile = ["Dockerfile.*"];

        Ansible = [
          "**.ansible.yml"
          "**.ansible.yaml"
          "**/defaults/*.yml"
          "**/defaults/*.yaml"
          "**/meta/*.yml"
          "**/meta/*.yaml"
          "**/tasks/*.yml"
          "**/tasks/*.yml"
          "**/tasks/*.yaml"
          "**/handlers/*.yml"
          "**/handlers/*.yaml"
          "**/group_vars/*.yml"
          "**/group_vars/*.yaml"
          "**/playbooks/*.yaml"
          "**/playbooks/*.yml"
          "**playbook*.yaml"
          "**playbook*.yml"
        ];

        Helm = [
          "**/templates/**/*.tpl"
          "**/templates/**/*.yaml"
          "**/templates/**/*.yml"
          "**/helmfile.d/**/*.yaml"
          "**/helmfile.d/**/*.yml"
        ];
      };

      lsp = {
        ansible-language-server.settings = {
          executionEnvironment.enabled = false;
          validation = {
            enabled = true;
            lint = {
              enabled = true;
              path = "ansible-lint";
            };
          };
        };

        rust-analyzer.settings = {
          check.command = "clippy";
          inlayHints = {
            maxLength = null;
            lifetimeElisionHints = {
              enable = "skip_trivial";
              useParameterNames = true;
            };
            closureReturnTypeHints.enable = "always";
          };
        };

        terraform-ls.initialization_options.experimentalFeatures.prefillRequiredFields = true;

        nixd = {
          settings = {
            diagnostic.suppress = ["sema-extra-with"];
            formatting.command = ["alejandra"];
            nixpkgs.expr = "import (builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").inputs.nixpkgs { }";
            options = {
              nixos.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").nixosConfigurations.nixos.options";
              home-manager.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").homeConfigurations.\"${config.nixconf.username}@nixos\".options";
            };
          };
        };

        cargotom.initialization_options = {
          offline = false;
          stable = false;
          per_page_web = 50;
        };
      };

      languages = {
        Nix.language_servers = ["nixd" "!nil"];

        # TODO: shellharden
      };
    };
  };
}
