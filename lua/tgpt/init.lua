local M = {}

local createBuffer = function ()
    WIDTH = vim.api.nvim_get_option_value("columns",{})
    HEIGHT = vim.api.nvim_get_option_value("lines", {})
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
            relative = 'editor',
            width = math.floor(WIDTH / 5),
            height = math.floor(HEIGHT / 1.1),
            col = WIDTH,
            row = 0,
            anchor = "NE",
            style = 'minimal',
            border = 'single'
    })
end

local InteractiveChat = function ()
    createBuffer()
    vim.api.nvim_command("startinsert")
    vim.fn.termopen("pytgpt interactive --provider DDG", {on_exit = function ()
        local win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win_id, true)
    end})
end

local RateMyCode = function ()
   -- local file = vim.api.nvim_buf_get_name(0)
   -- local prompt = "cat " .. file .. " | tgpt 'Rate the code' "
   local prompt = 'pytgpt generate --provider DDG "{{copied}} code를 한국어로 평가해 줘."'
   createBuffer()
   vim.fn.termopen(prompt)
end

local CheckForBugs = function ()
   -- local file = vim.api.nvim_buf_get_name(0)
   -- local prompt = "cat " .. file .. " | tgpt 'Check for bugs' "
   local prompt = 'pytgpt generate --provider DDG "{{copied}} code에 버그가 있는지를 한국어로 평가해 줘."'
   createBuffer()
   vim.fn.termopen(prompt)
end


function M.setup()
    local result = vim.fn.executable("tgpt")
    if result == 1 then
        vim.api.nvim_create_user_command("Chat", InteractiveChat
        , {
            nargs = 0,
        })
        vim.api.nvim_create_user_command("Ratecode",
           RateMyCode
        , {
            nargs = 0,
        })
        vim.api.nvim_create_user_command("Checkbug",
            CheckForBugs
        , {
            nargs = 0,
        })
    else
        print("[tgpt.nvim] tgpt is not installed on you system\nplease visit the tgpt github page for instructions https://github.com/aandrew-me/tgpt")
    end
end

return M
