{
  home.modules.minecraft = {
    # The nixpkgs prismlauncher wrapper already bundles JDKs 8/17/21/25 and the runtime libs
    # Minecraft needs (GL, GLFW, OpenAL, PulseAudio/PipeWire, xrandr, gamemode, controller support).
    programs.prismlauncher = {
      enable = true;
      settings = {
        MinMemAlloc = 1024;
        MaxMemAlloc = 4096;
        EnableFeralGamemode = true;
      };
    };
  };
}
