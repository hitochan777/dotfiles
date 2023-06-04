---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

local fzf_all = function()
  require'telescope.builtin'.grep_string{ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' }
end

local find_word = function ()
  require'telescope.builtin'.grep_string{}
end

M.telescope = {
  n = {
    ["<leader>sg"] = { fzf_all, "[S]earch by [G]rep'" },
    ["<leader>fp"] = { find_word, "[S]earch current [W]ord" },
  }
}


-- more keybinds!

return M
