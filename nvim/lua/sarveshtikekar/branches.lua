local M = {}

local BRANCH_STORE = {}

local function current_buf()
    return vim.api.nvim_get_current_buf()
end

local function ensure_buffer_state()
    local buf = current_buf()

    if not BRANCH_STORE[buf] then
        BRANCH_STORE[buf] = {
            root = "buffer-main",
            branches = {
                dev = {
                    checkpoints = {},
                },
            },
            active_branch = "dev",
        }
    end

    return BRANCH_STORE[buf]
end

M.get_active_branch = function()
    local state = ensure_buffer_state()
    return state.active_branch
end

M.create_branch = function(branch_name)
    if not branch_name or branch_name == "" then
        vim.notify("Branch name required", vim.log.levels.ERROR)
        return
    end

    local state = ensure_buffer_state()

    if state.branches[branch_name] then
        vim.notify("Branch already exists: " .. branch_name, vim.log.levels.ERROR)
        return
    end

    state.branches[branch_name] = {
        checkpoints = {},
    }

    state.active_branch = branch_name
    vim.notify("Switched to branch: " .. branch_name)
end

M.switch_branch = function(branch_name)
    if not branch_name or branch_name == "" then
        vim.notify("Branch name required", vim.log.levels.ERROR)
        return
    end

    local state = ensure_buffer_state()

    if not state.branches[branch_name] then
        vim.notify("Branch does not exist: " .. branch_name, vim.log.levels.ERROR)
        return
    end

    state.active_branch = branch_name
    vim.notify("Switched to branch: " .. branch_name)
end

M.get_branches_list = function()
    local state = ensure_buffer_state()
    local list = {}

    for name, _ in pairs(state.branches) do
        table.insert(list, name)
    end

    table.sort(list)
    return list
end

vim.api.nvim_create_autocmd("BufWipeout", {
    callback = function(args)
        BRANCH_STORE[args.buf] = nil
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	
	callback = function()
		ensure_buffer_state()
		vim.notify("Branches are created and currently at: " .. BRANCH_STORE[current_buf()].active_branch)
	end
})
return M

