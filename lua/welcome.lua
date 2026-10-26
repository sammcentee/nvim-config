local api = vim.api
local group = api.nvim_create_augroup("Welcome", { clear = true })

api.nvim_create_autocmd("VimEnter", {
  group = group,
  once = true,
  callback = function()
    if vim.g.vscode or vim.fn.argc() > 0 or #api.nvim_list_uis() == 0
      or vim.bo.buftype ~= "" or vim.bo.modified
      or api.nvim_buf_get_name(0) ~= "" or api.nvim_buf_line_count(0) ~= 1
      or api.nvim_get_current_line() ~= "" then
      return
    end

    local version = vim.version()
    local lines = {
      "███╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗",
      "████╗  ██║ ██║   ██║ ██║ ████╗ ████║",
      "██╔██╗ ██║ ██║   ██║ ██║ ██╔████╔██║",
      "██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      "██║ ╚████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      "",
      "v" .. version.major .. "." .. version.minor .. "." .. version.patch,
    }
    if vim.o.columns < 50 or vim.o.lines < #lines + 5 then
      return
    end

    for i, line in ipairs(lines) do
      lines[i] = string.rep(" ", math.floor((44 - vim.fn.strdisplaywidth(line)) / 2)) .. line
    end
    local buffer = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    vim.bo[buffer].modifiable = false
    local window = api.nvim_open_win(buffer, false, {
      relative = "editor",
      row = math.floor((vim.o.lines - #lines - 2) / 2),
      col = math.floor((vim.o.columns - 44) / 2),
      width = 44,
      height = #lines,
      style = "minimal",
      focusable = false,
    })
    vim.wo[window].winhighlight = "NormalFloat:Normal,EndOfBuffer:Normal"

    api.nvim_set_hl(0, "WelcomeLogo", { fg = "#7ABF60", bold = true })
    api.nvim_set_hl(0, "WelcomeVersion", { fg = "#808080" })
    local namespace = api.nvim_create_namespace("Welcome")
    for i, line in ipairs(lines) do
      local highlight = i <= 6 and "WelcomeLogo" or i == 8 and "WelcomeVersion"
      if highlight then
        api.nvim_buf_set_extmark(buffer, namespace, i - 1, 0, { end_col = #line, hl_group = highlight })
      end
    end

    local function close()
      vim.on_key(nil, namespace)
      api.nvim_clear_autocmds({ group = group })
      if api.nvim_win_is_valid(window) then
        api.nvim_win_close(window, true)
      end
      if api.nvim_buf_is_valid(buffer) then
        api.nvim_buf_delete(buffer, { force = true })
      end
    end
    vim.on_key(function(_, typed)
      if typed ~= "" then
        vim.on_key(nil, namespace)
        vim.schedule(close)
      end
    end, namespace)
    api.nvim_create_autocmd({ "BufLeave", "VimResized" }, { group = group, callback = close, once = true })
  end,
})
