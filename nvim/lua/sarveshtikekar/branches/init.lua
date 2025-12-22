--Logic for branching and checkpoint tree

local M = {}
M.BRANCH_STORE = {}

local DATA_PATH = vim.fn.stdpath("data") .. "/sarvim_branches/"
if vim.fn.isdirectory(DATA_PATH) == 0 then
    vim.fn.mkdir(DATA_PATH, "p")
end

local function current_buf()
    return vim.api.nvim_get_current_buf()
end

local function get_safe_path()
   local path = vim.api.nvim_buf_get_name(current_buf())
    if path == "" then return nil end
    return DATA_PATH .. path:gsub("[\\/:]", "%%") .. ".json"
end

local function save_to_disk()
    local buf = current_buf()
    local path = get_safe_path()
    if path and M.BRANCH_STORE[buf] then
        local file = io.open(path, "w")
        if file then
            file:write(vim.fn.json_encode(M.BRANCH_STORE[buf]))
            file:close()
        end
    end
end

local function load_from_disk()
    local buf = current_buf()
    local path = get_safe_path()
    if path and vim.fn.filereadable(path) == 1 then
        local file = io.open(path, "r")
        if file then
            local data = file:read("*a")
            file:close()
            local success, decoded = pcall(vim.fn.json_decode, data)
            if success then M.BRANCH_STORE[buf] = decoded end
        end
    end
end

local function get_current_seq()
    local undoInfo = vim.fn.undotree()
    if undoInfo and undoInfo.seq_cur then 
        return undoInfo.seq_cur
    end    
    return 1
end

local function ensure_buffer_state()
    local buf = current_buf()
    if not M.BRANCH_STORE[buf] then
        load_from_disk()
        if not M.BRANCH_STORE[buf] then
            M.BRANCH_STORE[buf] = {
                root = "buffer-main",
                branches = {
                    ["dev"] = {
                        checkpoints = {
				["dev-init"] = {

					["seq_no"] = get_current_seq(),
        				["time_and_date"] = os.date("%c")
				}
			},
                        history = {"dev-init"},
                    },
                },
                active_branch = "dev",
		active_checkpoint_on_branch = "dev-init",
            }
        end
    end
    return M.BRANCH_STORE[buf]
end

local function search_checkpoint(checkpoint_history, ckpName)
    if not checkpoint_history or type(checkpoint_history) ~= "table" then
        return false
    end
    for _, name in ipairs(checkpoint_history) do
        if name == ckpName then 
            return true
        end
    end
    return false
end

M.get_active_branch = function()
	local state = ensure_buffer_state()
	return state.active_branch
end

M.get_active_checkpoint = function()
	local state = ensure_buffer_state()
	return state.active_checkpoint_on_branch
end

M.create_branch = function(branch_name)
    if not branch_name or branch_name == "" then
        vim.notify("Branch name required", vim.log.levels.ERROR)
        return
    end
    local state = ensure_buffer_state()
    if state.branches[branch_name] then
        vim.notify("Branch already exists: " .. branch_name, vim.log.levels.WARN)
        return
    end
    state.branches[branch_name] = {
        checkpoints = {},
        history = {},
    }
    state.active_branch = branch_name
    save_to_disk()
    vim.notify("Created and switched to branch: " .. branch_name)
end

M.get_branches_list = function()
    local state = ensure_buffer_state()
    local list = {}
    for name, _ in pairs(state.branches) do
        table.insert(list, name)
    end
    table.sort(list)
    local stringified = table.concat(list, ", ")
    vim.notify("The branches currently in the workflow are: " .. stringified)
end

M.create_checkpoint_from_current_branch = function()
    vim.cmd("w!")    
    local ckpName = vim.fn.input("Enter a name for the checkpoint: ")
    if ckpName == "" or ckpName == nil then 
        vim.notify("Checkpoint name not specified.")
        return
    end
    local state = ensure_buffer_state()
    local currBranchName = state.active_branch
    local currBranchInfo = state.branches[currBranchName]
    if search_checkpoint(currBranchInfo.history, ckpName) then
        vim.notify("Checkpoint already exists in this branch.")
        return
    end
    local checkPoint = {
        ["seq_no"] = get_current_seq(),
        ["time_and_date"] = os.date("%c")
    }
    currBranchInfo.checkpoints[ckpName] = checkPoint
    table.insert(currBranchInfo.history, ckpName)
    state.active_checkpoint_on_branch = ckpName
    save_to_disk()
    vim.notify(ckpName .. " checkpoint created successfully on branch " .. currBranchName)
end

M.create_checkpoint_on_new_branch = function()
    local branchName = vim.fn.input("Enter branch: ")
    if branchName == "" or branchName == nil then 
        vim.notify("Invalid branch name.")
        return
    end
    local state = ensure_buffer_state()
    if state.branches[branchName] == nil then 
        M.create_branch(branchName)
        state = ensure_buffer_state()
    else
        state.active_branch = branchName
    end
    vim.cmd("w!")   
    local ckpName = vim.fn.input("Enter checkpoint name: ")

    --If no name specified, we create a default checkpoint called <branchname>-init
    if ckpName == "" or ckpName == nil then 
	    ckpName = branchName .. "-init"
    end
    local currBranchInfo = state.branches[branchName]
    if search_checkpoint(currBranchInfo.history, ckpName) then
        vim.notify("Checkpoint already exists.")
        return
    end
    local checkPoint = {
        ["seq_no"] = get_current_seq(),
        ["time_and_date"] = os.date("%c"),
    }
    currBranchInfo.checkpoints[ckpName] = checkPoint
    currBranchInfo.history = currBranchInfo.history or {}
    table.insert(currBranchInfo.history, ckpName)
    state.active_checkpoint_on_branch = ckpName
    save_to_disk()
    vim.notify(string.format("Checkpoint '%s' created on branch '%s'", ckpName, branchName))
end

M.jump_to_checkpoint_on_curr_branch = function()
    local checkpointName = vim.fn.input("Enter checkpoint name: ")
    if checkpointName == "" or checkpointName == nil then return end
    local state = ensure_buffer_state()
    local currBranchInfo = state.branches[state.active_branch]
    if not search_checkpoint(currBranchInfo.history, checkpointName) then
        vim.notify("Checkpoint not found.")
        return
    end
    local seqNumber = currBranchInfo.checkpoints[checkpointName].seq_no
    vim.cmd("undo " .. seqNumber)
    state.active_checkpoint_on_branch = checkpointName
    save_to_disk()
    vim.notify("Jumped to savepoint " .. checkpointName)
end

M.jump_to_checkpoint_on_other_branch = function()

    local branchName = vim.fn.input("Enter branch name: ") 
    if branchName == "" or branchName == nil then return end
    local checkpointName = vim.fn.input("Enter checkpoint name: ")
    if checkpointName == "" or checkpointName == nil then return end
    local state = ensure_buffer_state()
    local branchInfo = state.branches[branchName]
    if not branchInfo or not search_checkpoint(branchInfo.history, checkpointName) then
        vim.notify("Target not found.")
        return
    end
    local seqNumber = branchInfo.checkpoints[checkpointName].seq_no
    vim.cmd("undo " .. seqNumber)
    state.active_branch = branchName
    state.active_checkpoint_on_branch = checkpointName
    save_to_disk()
    vim.notify("Jumped to " .. checkpointName .. " on branch " .. branchName)
end 

M.list_all_checkpoints = function()
    local state = ensure_buffer_state()
    local currBranch = state.active_branch
    local stringified = vim.inspect(state.branches[currBranch].history)
    vim.notify("Checkpoints in branch " .. currBranch .. ": " .. stringified)
end

local group = vim.api.nvim_create_augroup("SarVimBranching", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave" }, {
    group = group,
    callback = function() save_to_disk() end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
    group = group,
    callback = function()
        -- If the file is gone from the disk, wipe the state
        local file_path = vim.api.nvim_buf_get_name(0)
        if file_path ~= "" and vim.fn.filereadable(file_path) == 0 then
            local state_path = get_safe_path()
            if state_path and vim.fn.filereadable(state_path) == 1 then
                os.remove(state_path)
                M.BRANCH_STORE[current_buf()] = nil
            end
        else
            ensure_buffer_state()
        end
    end
})

vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
        save_to_disk()
        M.BRANCH_STORE[args.buf] = nil
    end,
})

return M
