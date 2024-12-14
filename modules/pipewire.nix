{ config, lib, pkgs, ... }:

with lib;

{
  options.pipewire = {
    enable = mkEnableOption "PipeWire access" // { default = false; };
    package = mkOption {
      description = "PipeWire package to use for PulseAudio emulation in sandbox.";
      type = types.package;
      default = pkgs.pipewire;
    };
    snapId = mkOption {
      description = "Snap ID";
      type = types.str;
      default = config.flatpak.appId;
    };
    pulseaudio = mkEnableOption "PipeWire PulseAudio emulation in sandbox" // { default = false; };
    playback = mkEnableOption "PipeWire playback access" // { default = false; };
    capture = mkEnableOption "PipeWire capture access" // { default = false; };
    properties = mkOption {
      type = with types; attrsOf str;
      description = "Extra context properties";
      default = {};
    };
    args = mkOption {
      type = with types; listOf str;
      description = "Arguments to pw-container";
      default = [];
    };
  };
  config.pipewire.properties = {
    #"pipewire.sec.engine" = "org.flatpak";
    #"pipewire.access" = "restricted";
    "pipewire.snap.id" = config.pipewire.snapId;
    "pipewire.snap.audio.playback" = if config.pipewire.playback then "true" else "false";
    "pipewire.snap.audio.record" = if config.pipewire.capture then "true" else "false";
  };
  config.pipewire.args = [
    "--properties=${(builtins.toJSON config.pipewire.properties)}"
  ];
}
