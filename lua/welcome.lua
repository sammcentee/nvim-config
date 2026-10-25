local api = vim.api
local group = api.nvim_create_augroup("WelcomeWithoutCharity", { clear = true })

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
      "│ ╲ ││",
      "││╲╲││",
      "││ ╲ │",
      "",
      "NVIM v" .. version.major .. "." .. version.minor .. "." .. version.patch,
      string.rep("─", 44),
      "Nvim is open source and freely distributable",
      "https://neovim.io/#chat",
      string.rep("─", 44),
      "type  :help nvim<Enter>     if you are new! ",
      "type  :checkhealth<Enter>   to optimize Nvim",
      "type  :q<Enter>             to exit         ",
      "type  :help<Enter>          for help        ",
      string.rep("─", 44),
      string.format("type  :help news<Enter>     for v%d.%d notes ", version.major, version.minor),
      string.rep("─", 44),
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

    local namespace = api.nvim_create_namespace("WelcomeWithoutCharity")
    for i, line in ipairs(lines) do
      local highlight = i <= 3 and "Special" or i == 5 and "String"
        or line:find("─", 1, true) and "NonText"
      if highlight then
        api.nvim_buf_set_extmark(buffer, namespace, i - 1, 0, { end_col = #line, hl_group = highlight })
      end
      if i <= 3 then
        local diagonal = line:find("╲", 1, true)
        api.nvim_buf_set_extmark(buffer, namespace, i - 1, diagonal - 1,
          { end_col = #line, hl_group = "String", priority = 101 })
      end
      local first, last = line:find(":.-<Enter>")
      if first then
        api.nvim_buf_set_extmark(buffer, namespace, i - 1, first - 1,
          { end_col = first, hl_group = "SpecialKey" })
        api.nvim_buf_set_extmark(buffer, namespace, i - 1, first,
          { end_col = last - #"<Enter>", hl_group = "Identifier" })
        api.nvim_buf_set_extmark(buffer, namespace, i - 1, last - #"<Enter>",
          { end_col = last, hl_group = "SpecialKey" })
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
