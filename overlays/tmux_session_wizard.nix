self: super: {
  tmuxPlugins = (builtins.removeAttrs super.tmuxPlugins [ "mkDerivation" ]) // {
    tmux-session-wizard = super.tmuxPlugins.mkTmuxPlugin {
      name = "tmux-session-wizard";
      pluginName = "tmux-session-wizard";
      rtpFilePath = "session-wizard.tmux";
      src = super.fetchFromGitHub {
        owner = "27medkamal";
        repo = "tmux-session-wizard";
        rev = "c410604c01ea9c80c629ad8916ccf1fec3c9f203";
        sha256 = "u+X5ZmaAft8YGHa5PIyW2DLTPXn1oqS0ev6fl4nlOvs=";
      };
    };
  };
}
