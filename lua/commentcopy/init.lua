local M = {}

function M.comment_copy_range(is_visual)
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  -- Track exact starting cursor {row, col}
  local orig_cursor = vim.api.nvim_win_get_cursor(win)
  local start_line, end_line

  if is_visual then
    -- Cleanly exit visual mode to commit current marks to buffer
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', true)

    -- Extract row numbers from visual marks
    start_line = vim.api.nvim_buf_get_mark(buf, '<')[1]
    end_line = vim.api.nvim_buf_get_mark(buf, '>')[1]
  else
    -- Single line for normal mode
    start_line = orig_cursor[1]
    end_line = orig_cursor[1]
  end

  -- Safeguard for uninitialized marks
  if start_line == 0 or end_line == 0 then return end

  -- 1. Fetch the target lines BEFORE modifying anything (0-indexed API bounds)
  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
  local count = #lines

  -- 2. Comment out the active selection first
  -- Neovim's built-in toggle_lines expects 1-indexed boundaries for this operation
  require('vim._comment').toggle_lines(start_line, end_line)

  -- 3. Insert the raw uncommented copy directly UNDER the newly commented lines
  vim.api.nvim_buf_set_lines(buf, end_line, end_line, false, lines)

  -- 4. Shift cursor down matching the original offset within the clean block
  local final_line = orig_cursor[1] + count
  local final_col = orig_cursor[2]

  local total_lines = vim.api.nvim_buf_line_count(buf)
  if final_line <= total_lines then
    vim.api.nvim_win_set_cursor(win, { final_line, final_col })
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
