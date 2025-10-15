{
  plugins = {
    neo-tree = {
      enable = true;
      settings = {
        sources = [
          "filesystem"
          "buffers"
          "git_status"
        ];
        open_files_do_not_replace_types = [
          "terminal"
          "Trouble"
          "trouble"
          "qf"
          "Outline"
        ];
        close_if_last_window = true;
        filesystem = {
          follow_current_file.enabled = true;
          use_libuv_file_watcher = true;
          bind_to_cwd = true;
        };
      };
    };
  };
}
