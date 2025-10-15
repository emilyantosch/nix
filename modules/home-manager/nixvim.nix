{inputs, ...}:
{
	programs.nixvim = {
	enable = true;

	modules = [
		inputs.nyx.nvixPlugins.common
	];
};
}
