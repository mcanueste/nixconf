{ lib, ... }:
{
  home-manager.users.mcst = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = false;
      settings = {
        add_newline = false;
        scan_timeout = 10;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$kubernetes"
          "$directory"
          "$vcsh"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$docker_context"
          "$package"
          "$buf"
          "$c"
          "$cmake"
          "$container"
          "$golang"
          "$haskell"
          "$helm"
          "$lua"
          "$python"
          "$rust"
          "$terraform"
          "$vagrant"
          "$nix_shell"
          "$memory_usage"
          "$aws"
          "$gcloud"
          "$openstack"
          "$azure"
          "$env_var"
          "$custom"
          "$sudo"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$battery"
          "$time"
          "$status"
          "$shell"
          "$character"
        ];
      };
    };
  };
}
