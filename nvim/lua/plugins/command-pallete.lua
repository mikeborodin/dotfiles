return {
    'AtleSkaanes/command-palette.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    version = "*",
    opts = {
        commands = {
            {
                name = 'compile main',
                category = 'cpp',
                cmd = 'clang main.cpp -o main.exe',
            }
        },
    },
}
