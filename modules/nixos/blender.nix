{pkgs, ...}:
{
  pkgs.blender.override = { cudaSupport = true;};
}
