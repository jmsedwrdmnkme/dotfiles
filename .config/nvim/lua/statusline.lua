-- Source/inspiration for this statusline
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
-- Lookup table: Neovim's internal mode codes -> human-readable labels
local modes = {
  -- Normal mode
  ["n"] = "NORMAL",
  -- Operator-pending (e.g. after typing d or y)
  ["no"] = "NORMAL",
  -- Characterwise visual mode
  ["v"] = "VISUAL",
  -- Linewise visual mode (V)
  ["V"] = "VISUAL LINE",
  -- Blockwise visual mode (key is a literal Ctrl-V character)
  [""] = "VISUAL BLOCK",
  -- Characterwise select mode
  ["s"] = "SELECT",
  -- Linewise select mode
  ["S"] = "SELECT LINE",
  -- Blockwise select mode (key is a literal Ctrl-S character)
  [""] = "SELECT BLOCK",
  -- Insert mode
  ["i"] = "INSERT",
  -- Insert mode with completion menu active
  ["ic"] = "INSERT",
  -- Replace mode (R)
  ["R"] = "REPLACE",
  -- Virtual replace mode (gR)
  ["Rv"] = "VISUAL REPLACE",
  -- Command-line mode (after :)
  ["c"] = "COMMAND",
  -- Vim Ex mode (gQ)
  ["cv"] = "VIM EX",
  -- Normal Ex mode (Q)
  ["ce"] = "EX",
  -- Hit-enter prompt
  ["r"] = "PROMPT",
  -- The -- more -- pager prompt
  ["rm"] = "MOAR",
  -- A confirm query of some sort
  ["r?"] = "CONFIRM",
  -- An external shell command is running
  ["!"] = "SHELL",
  -- Terminal mode (typing into a :terminal)
  ["t"] = "TERMINAL",
-- End of modes table
}

-- Returns the current mode label padded with spaces, e.g. " NORMAL "
local function mode()
  -- Ask Neovim for the current mode code (e.g. "n", "i", "v")
  local current_mode = vim.api.nvim_get_mode().mode
  -- Look up the label, pad it with spaces and uppercase it
  return string.format(" %s ", modes[current_mode]):upper()
-- End of mode()
end

-- Returns the highlight group for the mode block, so each mode gets its own colour
local function update_mode_colors()
  -- Get the current mode code
  local current_mode = vim.api.nvim_get_mode().mode
  -- Default highlight group if no branch below matches
  local mode_color = "%#StatusLineAccent#"
  -- Normal mode...
  if current_mode == "n" then
      -- ...uses the blue accent
      mode_color = "%#StatuslineAccent#"
  -- Insert mode (plain or with completion)...
  elseif current_mode == "i" or current_mode == "ic" then
      -- ...uses the green accent
      mode_color = "%#StatuslineInsertAccent#"
  -- Any visual mode (char, line, or block via literal Ctrl-V)...
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
      -- ...uses the mauve accent
      mode_color = "%#StatuslineVisualAccent#"
  -- Replace mode...
  elseif current_mode == "R" then
      -- ...uses the red accent
      mode_color = "%#StatuslineReplaceAccent#"
  -- Command-line mode...
  elseif current_mode == "c" then
      -- ...uses the peach accent
      mode_color = "%#StatuslineCmdLineAccent#"
  -- Terminal mode...
  elseif current_mode == "t" then
      -- ...uses the teal accent
      mode_color = "%#StatuslineTerminalAccent#"
  -- End of the if/elseif chain
  end
  -- Hand back the %#Group# string for the statusline to switch colour
  return mode_color
-- End of update_mode_colors()
end

-- Returns the directory part of the current file's path
local function filepath()
  -- Expand % (current file), then :~ (home -> ~), :. (relative to cwd), :h (drop filename, keep dir)
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  -- If the file has no directory part (no file, or it's in the cwd)...
  if fpath == "" or fpath == "." then
      -- ...just return a single space
      return " "
  -- End of the if
  end

  -- %< marks where to truncate if the window is too narrow; %% escapes the % in string.format
  return string.format(" %%<%s/", fpath)
-- End of filepath()
end

-- Returns the current file's name (without directory)
local function filename()
  -- %:t = 'tail' of the path, i.e. just the filename
  local fname = vim.fn.expand "%:t"
  -- If the buffer has no name (e.g. a new unsaved buffer)...
  if fname == "" then
      -- ...show nothing
      return ""
  -- End of the if
  end
  -- Otherwise show the filename followed by a space
  return fname .. " "
-- End of filename()
end

-- Returns coloured counts of LSP diagnostics (errors/warnings/hints/info) for the current buffer
local function lsp()
  -- Will hold the number of diagnostics for each level
  local count = {}
  -- Maps our count keys -> vim.diagnostic severity names
  local levels = {
    -- Errors
    errors = "Error",
    -- Warnings
    warnings = "Warn",
    -- Informational messages
    info = "Info",
    -- Hints
    hints = "Hint",
  -- End of levels table
  }

  -- Loop over each severity level
  for k, level in pairs(levels) do
    -- Count diagnostics in buffer 0 (the current buffer) with that severity
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  -- End of loop
  end

  -- Text segment for errors (empty unless there are some)
  local errors = ""
  -- Text segment for warnings
  local warnings = ""
  -- Text segment for hints
  local hints = ""
  -- Text segment for info
  local info = ""

  -- Only show errors if there are any...
  if count["errors"] ~= 0 then
    -- ...as an error icon + count, coloured with the DiagnosticError highlight
    errors = " %#DiagnosticError# " .. count["errors"]
  -- End of the if
  end
  -- Only show warnings if there are any...
  if count["warnings"] ~= 0 then
    -- ...as a warning icon + count, coloured with DiagnosticWarn
    warnings = " %#DiagnosticWarn# " .. count["warnings"]
  -- End of the if
  end
  -- Only show hints if there are any...
  if count["hints"] ~= 0 then
    -- ...as a hint icon + count, coloured with DiagnosticHint
    hints = " %#DiagnosticHint# " .. count["hints"]
  -- End of the if
  end
  -- Only show info if there are any...
  if count["info"] ~= 0 then
    -- ...as an info icon + count, coloured with DiagnosticInfo
    info = " %#DiagnosticInfo# " .. count["info"]
  -- End of the if
  end

  -- Join the segments, then reset the colour back to Normal
  return errors .. warnings .. hints .. info .. "%#Normal#"
-- End of lsp()
end

-- Returns the buffer's filetype in uppercase, e.g. " LUA "
local function filetype()
  -- vim.bo.filetype is the current buffer's 'filetype' option
  return string.format(" %s ", vim.bo.filetype):upper()
-- End of filetype()
end

-- Returns the cursor position info
local function lineinfo()
  -- On the alpha dashboard (start screen)...
  if vim.bo.filetype == "alpha" then
    -- ...show nothing, since cursor position is meaningless there
    return ""
  -- End of the if
  end
  -- %P = percentage through file (Top/Bot/All/NN%), %l = line number, %c = column number
  return " %P %l:%c "
-- End of lineinfo()
end

-- Defines the statusline highlight groups using Catppuccin colours
local function set_highlights()
  -- Try to load the Catppuccin palette module without erroring if it's missing
  local ok, palettes = pcall(require, "catppuccin.palettes")
  -- If Catppuccin isn't installed...
  if not ok then
    -- ...bail out and leave the highlights undefined
    return
  -- End of the if
  end
  -- Get the colour table for the active Catppuccin flavour
  local c = palettes.get_palette()
  -- Short alias for the highlight-setting function
  local set = vim.api.nvim_set_hl
  -- Normal-mode block: dark text on blue, bold
  set(0, "StatuslineAccent", { fg = c.base, bg = c.blue, bold = true })
  -- Insert-mode block: dark text on green, bold
  set(0, "StatuslineInsertAccent", { fg = c.base, bg = c.green, bold = true })
  -- Visual-mode block: dark text on mauve, bold
  set(0, "StatuslineVisualAccent", { fg = c.base, bg = c.mauve, bold = true })
  -- Replace-mode block: dark text on red, bold
  set(0, "StatuslineReplaceAccent", { fg = c.base, bg = c.red, bold = true })
  -- Command-line block: dark text on peach, bold
  set(0, "StatuslineCmdLineAccent", { fg = c.base, bg = c.peach, bold = true })
  -- Terminal-mode block: dark text on teal, bold
  set(0, "StatuslineTerminalAccent", { fg = c.base, bg = c.teal, bold = true })
  -- Right-hand section (filetype/position): muted text on a subtle surface colour
  set(0, "StatusLineExtra", { fg = c.subtext0, bg = c.surface0 })
-- End of set_highlights()
end

-- Create the highlight groups once when this file loads
set_highlights()
-- Re-create them whenever the colourscheme changes (which would otherwise clear them)
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

-- Global table so the functions are reachable from Vimscript via v:lua.Statusline
Statusline = {}

-- Statusline used for the currently focused window
Statusline.active = function()
  -- Join all the pieces below into one statusline string
  return table.concat {
    -- Start with the default statusline highlight
    "%#Statusline#",
    -- Switch to the mode-specific colour
    update_mode_colors(),
    -- Draw the mode label, e.g. " NORMAL "
    mode(),
    -- Switch back to Normal colours and add a gap
    "%#Normal# ",
    -- Directory of the current file
    filepath(),
    -- Name of the current file
    filename(),
    -- Ensure Normal colours before the diagnostics
    "%#Normal#",
    -- LSP diagnostic counts
    lsp(),
    -- %= pushes everything after it to the right edge; then switch to the muted right-side colour
    "%=%#StatusLineExtra#",
    -- Filetype, e.g. " LUA "
    filetype(),
    -- Percentage through file and line:column
    lineinfo(),
  -- End of the table passed to table.concat
  }
-- End of Statusline.active()
end

-- Statusline used for unfocused windows
function Statusline.inactive()
  -- %F = full path of the file in that window
  return " %F"
-- End of Statusline.inactive()
end

-- Minimal statusline for the NvimTree file explorer
function Statusline.short()
  -- Use the not-current-window colour and show a tree icon + label
  return "%#StatusLineNC#   NvimTree"
-- End of Statusline.short()
end

-- Run a block of Vimscript to wire the statusline functions to window events
vim.api.nvim_exec([[
  " Create (or reuse) an autocommand group called Statusline
  augroup Statusline
  " Clear existing autocommands in this group so re-sourcing doesn't duplicate them
  au!
  " Entering a window/buffer: use the full active statusline (%! evaluates the Lua function each redraw)
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  " Leaving a window/buffer: switch it to the simple inactive statusline
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  " For NvimTree windows, override with the short statusline
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  " Close the autocommand group
  augroup END
]], false) -- End of the Vimscript block; false = don't capture its output
