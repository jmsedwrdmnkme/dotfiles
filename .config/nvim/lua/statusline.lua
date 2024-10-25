local function vim_mode()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    return "NORMAL"
  elseif mode == "v" then
    return "VISUAL"
  elseif mode == "V" then
    return "V-LINE"
  elseif mode == "i" then
    return "INSERT"
  elseif mode == "R" then
    return "REPLACE"
  elseif mode == "s" then
    return "SELECT"
  elseif mode == "t" then
    return "TERMINAL"
  elseif mode == "c" then
    return "COMMAND"
  elseif mode == "!" then
    return "SHELL"
  else
    return "V-BLOCK"
  end
end

local function statusline()
  local set_color_1 = "%#TermCursorNC#"
  local mode = vim_mode()
  local set_color_2 = "%#CursorLine#"
  local set_color_3 = "%#LineNr#"
  local file_name = " %f"
  local modified = " %m"
  local align_right = "%="
  local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
  local fileformat = " [%{&fileformat}]"
  local filetype = " %y"
  local set_color_4 = "%#TermCursorNC#"
  local percentage = " %p%%"
  local linecol = " %l:%c"

  return string.format(
    "%s %s %s%s%s%s%s%s%s %s%s%s ",
    set_color_1,
    mode,
    set_color_3,
    file_name,
    modified,
    align_right,
    filetype,
    fileencoding,
    fileformat,
    set_color_4,
    percentage,
    linecol
  )
end

vim.opt.statusline = statusline()

vim.api.nvim_create_autocmd("ModeChanged", {  
  pattern = "*",
  group =  group,
  callback = function()
    vim.opt.statusline = statusline()
  end,
})
