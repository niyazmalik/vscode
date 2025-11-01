vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.laststatus = 0
vim.opt.signcolumn = "no"
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 0
vim.opt.numberwidth = 1

-- Set <leader> to space
vim.g.mapleader = " "

-- Map "kj" in insert mode to escape
vim.keymap.set("i", "kj", "<Esc>", { noremap = true })

vim.opt.tabstop = 4       -- number of visual spaces per TAB
vim.opt.shiftwidth = 4    -- spaces for each indentation level
vim.opt.expandtab = true  -- convert TAB to spaces
vim.opt.smartindent = true -- auto-indent new lines

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "cpp", "c"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim", tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
          local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        mappings = {
          n = {
            -- in normal mode: use 'q' to close (safer, doesn't conflict with navigation)
            ["q"] = actions.close,
          },
        },
      },
    })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

})

-- Set background
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#181a1b", fg = "#FFFFFF" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "#1a1a1a" })
vim.opt.termguicolors = true

-- Custom highlight groups (define BEFORE autocmd)
vim.api.nvim_set_hl(0, "CppWhiteTypes", { fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "CppBlueTypes", { fg = "#82acfa" })
vim.api.nvim_set_hl(0, "CppPinkTypes", { fg = "#ff85ff" })
vim.api.nvim_set_hl(0, "CppGreenStrings", { fg = "#6efa7a" })

-- Wait for Treesitter to load, then set custom colors
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Comments
    vim.api.nvim_set_hl(0, "@comment", { fg = "#fc5365" })

    -- Keywords
    vim.api.nvim_set_hl(0, "@keyword", { fg = "#82acfa" })
    vim.api.nvim_set_hl(0, "@storageclass", { fg = "#82acfa" })

    -- Types
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#ff85ff" })
    vim.api.nvim_set_hl(0, "@type", { fg = "#ff85ff" })

    -- Operators and punctuation
    vim.api.nvim_set_hl(0, "@operator", { fg = "#ffec96" })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#ffec96" })
    vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#ffec96" })

    -- Numbers
    vim.api.nvim_set_hl(0, "@number", { fg = "#51c7d6" })

    -- Strings
    vim.api.nvim_set_hl(0, "@string", { fg = "#6efa7a" })

    -- Variables
    vim.api.nvim_set_hl(0, "@variable", { fg = "#FFFFFF" })

    -- Functions
    vim.api.nvim_set_hl(0, "@function", { fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "@function.call", { fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "@function.builtin", { fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "@method", { fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "@method.call", { fg = "#FFFFFF" })

    -- Preprocessor
    vim.api.nvim_set_hl(0, "@keyword.directive", { fg = "#fc5d5d" })
    vim.api.nvim_set_hl(0, "@keyword.directive.define", { fg = "#fc5d5d" })
    vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#fc5d5d" })

    -- Macro names should be white
    vim.api.nvim_set_hl(0, "@constant.macro", { fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "@constant.builtin", { fg = "#FFFFFF" })
  end,
})

-- Pattern matching for specific type names
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.fn.matchadd("CppWhiteTypes", "\\<\\(string\\|pair\\|tuple\\)\\>", 11)
    vim.fn.matchadd("CppBlueTypes", "\\<\\(bool\\|char\\|double\\|signed\\|unsigned\\|void\\)\\>", 11)
    vim.fn.matchadd("CppBlueTypes", "\\<\\(auto\\|using\\)\\>", 12)

    vim.fn.matchadd("CppPinkTypes", "\\<Niaz_Malique\\>", 13)

    vim.fn.matchadd("CppGreenStrings", '"[^"]*"', 14)

    -- Match just the <...> or "..." part after #include
    vim.fn.matchadd("CppWhiteTypes", "\\(#include\\s\\+\\)\\@<=<[^>]*>", 12)
    vim.fn.matchadd("CppWhiteTypes", '\\(#include\\s\\+\\)\\@<="[^"]*"', 12)
  end,
})

-- LuaSnip configuration
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cpp", {
  s("code", {
    t({
      "#include <bits/stdc++.h>",
      "",
      "using namespace std;",
      "",
      "template<typename A, typename B>",
      "ostream& operator<<(ostream &os, const pair<A, B> &p) {",
      "    return os << '(' << p.first << \", \" << p.second << ')';",
      "}",
      "",
      "template<typename... Args> ostream& operator<<(ostream& os, const tuple<Args...>& t) {",
      "    os << '(';",
      "    apply([&os](const Args&... args) {",
      "        size_t n = 0;",
      "        ((os << args << (++n != sizeof...(Args) ? \", \" : \"\")), ...);",
      "    }, t);",
      "    return os << ')';",
      "}",
      "",
      "/* Generic printing (works with any STL container except strings) */",
      "template < typename T_container, typename T = typename enable_if< !is_same<T_container, string>::value,",
      "typename T_container::value_type >::type > ostream& operator<<(ostream &os, const T_container &v) {",
      "    os << '{';",
      "    string sep;",
      "    for (const T &x : v) os << sep << x, sep = \", \";",
      "    return os << '}';",
      "}",
      "",
      "#ifdef DEBUG_MODE",
      "",
      "#define C_RESET \"\\033[0m\"",
      "#define C_GREEN \"\\033[32m\"",
      "#define C_BLUE \"\\033[34m\"",
      "",
      "template<typename... Args>",
      "void _debug_out(const char* names, Args&&... args) {",
      "    cerr << C_BLUE << names << C_RESET \" = \";",
      "    const char* sep = \"\";",
      "    ((cerr << args << sep, sep = \", \"), ...);",
      "    cerr << endl;",
      "}",
      "",
      "#define dbg(...) \\",
      "   cerr << C_GREEN \"[DEBUG]\" C_RESET \" (\" << __FUNCTION__ << \":\" << __LINE__ << \") \", _debug_out(#__VA_ARGS__, __VA_ARGS__)",
      "",
      "#else",
      "#define dbg(...) 98",
      "#endif",
      "",
      "#define endl '\\n'",
      "",
      "/*",
      "   Recursive lambda (combinator) — from @neal",
      "   lets you do:",
      "   (Type) dfs = combinator([&]((Type) self, int u){ ... self(v); ... });",
      "*/",
      "template<class Fun>",
      "class recursive_lambda {",
      "    Fun fun_;",
      "public:",
      "    template<class T> explicit recursive_lambda(T &&fun): fun_(std::forward<T>(fun)) {}",
      "    template<class ...Args>",
      "    decltype(auto) operator()(Args &&...args) {",
      "        return fun_(std::ref(*this), std::forward<Args>(args)...);",
      "    }",
      "};",
      "template<class Fun>",
      "decltype(auto) combinator(Fun &&fun) {",
      "    return recursive_lambda<std::decay_t<Fun>>(std::forward<Fun>(fun));",
      "}",
      "",
      "const int32_t INF32 = numeric_limits<int32_t>::max();",
      "const int64_t INF64 = numeric_limits<int64_t>::max();",
      "",
      "const int32_t NINF32 = numeric_limits<int32_t>::min();",
      "const int64_t NINF64 = numeric_limits<int64_t>::min();",
      "",
      "/* run-length encoding utility turns something like [1,1,2,2,2,3] -> [(1,2),(2,3),(3,1)]",
      "   works with any iterable container",
      "*/",
      "template<typename Iterable>",
      "auto run_length_encoding(const Iterable &items) {",
      "    using T = typename Iterable::value_type;",
      "    std::vector<std::pair<T, int>> runs;",
      "",
      "    T previous = T();",
      "    int count = 0;",
      "",
      "    for (const T &item : items) {",
      "        if (item == previous) {",
      "            count++;",
      "        } else {",
      "            if (count > 0)",
      "                runs.emplace_back(previous, count);",
      "            previous = item;",
      "            count = 1;",
      "        }",
      "    }",
      "    if (count > 0)",
      "        runs.emplace_back(previous, count);",
      "",
      "    return runs;",
      "}",
      "",
      "template <typename T>",
      "void print(const std::vector<T>& vec) {",
      "    for (const auto& element : vec) cout << element << \" \";",
      "    cout << endl;",
      "}",
      "",
      "void Niaz_Malique() {",
      "    ",
    }),
    i(1),
    t({
      "",
      "}",
      "",
      "bool __cases = true;",
      "",
      "signed main() {",
      "    ios::sync_with_stdio(false);",
      "    cin.tie(nullptr);",
      "",
      "    int cases = 1;",
      "    if (__cases) cin >> cases;",
      "    while (cases--) {",
      "       Niaz_Malique();",
      "    }",
      "    return 0;",
      "}",
    })
  })
})

-- Keybindings for snippets
vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump(1) end)
vim.keymap.set({"i", "s"}, "<C-k>", function() ls.jump(-1) end)
vim.keymap.set({"i", "s"}, "jj", function() ls.expand() end)
