{inputs, ...}:
{
	programs.nixvim = {
	enable = true;

	imports = [
		inputs.nyx.nvixPlugins.common
	];
};
}
