 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#18120c',
    base01 = '#251e17',
    base02 = '#302921',
    base03 = '#9f8e7d',
    base04 = '#d7c3b0',
    base05 = '#eee0d5',
    base06 = '#eee0d5',
    base07 = '#eee0d5',
    base08 = '#ffb4ab',
    base09 = '#c0cf61',
    base0A = '#e9bf90',
    base0B = '#ffb960',
    base0C = '#c0cf61',
    base0D = '#ffb960',
    base0E = '#e9bf90',
    base0F = '#ffddb8',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#eee0d5',          bg = '#18120c' })
  hi('TelescopeBorder',         { fg = '#9f8e7d',             bg = '#18120c' })
  hi('TelescopePromptNormal',   { fg = '#eee0d5',          bg = '#18120c' })
  hi('TelescopePromptBorder',   { fg = '#9f8e7d',             bg = '#18120c' })
  hi('TelescopePromptPrefix',   { fg = '#ffb960',             bg = '#18120c' })
  hi('TelescopePromptCounter',  { fg = '#d7c3b0',  bg = '#18120c' })
  hi('TelescopePromptTitle',    { fg = '#18120c',             bg = '#ffb960' })
  hi('TelescopePreviewTitle',   { fg = '#18120c',             bg = '#e9bf90' })
  hi('TelescopeResultsTitle',   { fg = '#18120c',             bg = '#c0cf61' })
  hi('TelescopeSelection',      { fg = '#eee0d5',          bg = '#302921' })
  hi('TelescopeSelectionCaret', { fg = '#ffb960',             bg = '#302921' })
  hi('TelescopeMatching',       { fg = '#ffb960',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#eee0d5',          bg = '#18120c' })
  hi('MiniPickBorder',         { fg = '#9f8e7d',             bg = '#18120c' })
  hi('MiniPickPrompt',   { fg = '#eee0d5',          bg = '#18120c' })
  hi('MiniPickPromptPrefix',   { fg = '#ffb960',             bg = '#18120c' })
  hi('MiniPickBorderText',    { fg = '#18120c',             bg = '#ffb960' })
  hi('MiniPickMatchCurrent',      { fg = '#eee0d5',          bg = '#302921' })
  hi('MiniPickPromptCaret', { fg = '#ffb960',             bg = '#302921' })
  hi('MiniPickMatchRanges',       { fg = '#ffb960',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
