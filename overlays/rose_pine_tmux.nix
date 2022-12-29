self: super: {
  tmuxPlugins = (builtins.removeAttrs super.tmuxPlugins [ "mkDerivation" ]) // {
    rose-pine-tmux = super.tmuxPlugins.mkTmuxPlugin {
      name = "rose-pine-tmux";
      pluginName = "rose-pine-tmux";
      rtpFilePath = "rose-pine-tmux.tmux";
      src = super.fetchFromGitHub {
        owner = "mcanueste";
        repo = "rose-pine-tmux";
        rev = "258db6d25736d881611d412ba4e68bbd559d02d3";
        sha256 = "M32NmmTcFY1cuywTXwDDJO6nh8WuzfHdOaUbUErDPao=";
      };
    };
  };
}
