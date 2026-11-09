{
  # GUI app, so kept out of the core `secrets` feature and opted into by GUI users.
  home.modules.password-manager = {
    programs.keepassxc.enable = true;
  };
}
