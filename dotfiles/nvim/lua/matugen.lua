 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#121414',
    base01 = '#1e2020',
    base02 = '#282a2b',
    base03 = '#8a9293',
    base04 = '#c0c8c9',
    base05 = '#e2e2e2',
    base06 = '#e2e2e2',
    base07 = '#e2e2e2',
    base08 = '#ffb4ab',
    base09 = '#d3bfe4',
    base0A = '#b9cacc',
    base0B = '#a3ced4',
    base0C = '#d3bfe4',
    base0D = '#a3ced4',
    base0E = '#b9cacc',
    base0F = '#d5e6e8',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#e2e2e2',          bg = '#121414' })
  hi('TelescopeBorder',         { fg = '#8a9293',             bg = '#121414' })
  hi('TelescopePromptNormal',   { fg = '#e2e2e2',          bg = '#121414' })
  hi('TelescopePromptBorder',   { fg = '#8a9293',             bg = '#121414' })
  hi('TelescopePromptPrefix',   { fg = '#a3ced4',             bg = '#121414' })
  hi('TelescopePromptCounter',  { fg = '#c0c8c9',  bg = '#121414' })
  hi('TelescopePromptTitle',    { fg = '#121414',             bg = '#a3ced4' })
  hi('TelescopePreviewTitle',   { fg = '#121414',             bg = '#b9cacc' })
  hi('TelescopeResultsTitle',   { fg = '#121414',             bg = '#d3bfe4' })
  hi('TelescopeSelection',      { fg = '#e2e2e2',          bg = '#282a2b' })
  hi('TelescopeSelectionCaret', { fg = '#a3ced4',             bg = '#282a2b' })
  hi('TelescopeMatching',       { fg = '#a3ced4',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#e2e2e2',          bg = '#121414' })
  hi('MiniPickBorder',         { fg = '#8a9293',             bg = '#121414' })
  hi('MiniPickPrompt',   { fg = '#e2e2e2',          bg = '#121414' })
  hi('MiniPickPromptPrefix',   { fg = '#a3ced4',             bg = '#121414' })
  hi('MiniPickBorderText',    { fg = '#121414',             bg = '#a3ced4' })
  hi('MiniPickMatchCurrent',      { fg = '#e2e2e2',          bg = '#282a2b' })
  hi('MiniPickPromptCaret', { fg = '#a3ced4',             bg = '#282a2b' })
  hi('MiniPickMatchRanges',       { fg = '#a3ced4',             bold = true })
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
