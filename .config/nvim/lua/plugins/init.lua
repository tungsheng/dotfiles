return {
  -- NvChad completion engine
  { import = "nvchad.blink.lazyspec" },

  -- Seamless navigation between vim and tmux panes (Ctrl+h/j/k/l)
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" },

  -- Code formatting on save
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    version = "^1.0.0",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Git UI (magit-style)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    config = true,
  },

  -- Git worktree management via Telescope
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "git_worktree"
    end,
  },

  -- Fuzzy finder with sensible ignore patterns
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "%.lock",
          "package%-lock%.json",
          "yarn%.lock",
          "pnpm%-lock%.yaml",
          "dist/",
          "build/",
          ".next/",
          ".nuxt/",
          "%.min%.js",
          "%.min%.css",
          "vendor/",
          "__pycache__/",
          "%.pyc",
          ".venv/",
          "target/",
          "%.class",
        },
      },
    },
  },

  -- Auto-close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "markdown",
        "bash",
        "dockerfile",
      },
    },
  },
}
