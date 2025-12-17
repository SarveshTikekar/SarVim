local M = {}
M.BRANCH_STORE = {}

-- Local functions 

local function current_buf()
    return vim.api.nvim_get_current_buf()
end

local function get_current_seq()
	
	local undoInfo = vim.fn.undotree()

	if undoInfo and undoInfo.seq_cur then 
		return undoInfo.seq_cur
	end	
	vim.notify("Error in undotree functionality")
	return 1
end


local function ensure_buffer_state()
    local buf = current_buf()

    if not M.BRANCH_STORE[buf] then
        M.BRANCH_STORE[buf] = {
            root = "buffer-main",
            branches = {
                ["dev"] = {
                    checkpoints = {},
		    history = {}
                },
            },
            active_branch = "dev",
        }
    end
    return M.BRANCH_STORE[buf]
end


local function search_checkpoint(checkpoint_history, ckpName)	
	for _, name in ipairs(checkpoint_history) do
		
		if name == ckpName then 
			return true
		end
	end
	return false
end

-- Module level functions -- 

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

-- Checkpoint functions

M.create_checkpoint_from_current_branch = function()
	
	vim.cmd("w!")	
	local ckpName = vim.fn.input("Enter a name for the checkpoint: ")

	if ckpName == "" or ckpName == nil then 
		vim.notify("Checkpoint name is not specified so reverting...")
		return
	end

	local branchData = ensure_buffer_state()
	local currBranchName = branchData.active_branch
	local currBranchInfo = branchData.branches[currBranchName]
	
	if search_checkpoint(currBranchInfo.history, ckpName) then
		vim.notify("Current checkpoint name already exists in the branch, so reverting...")
		return
	end
	-- Checkpoint creation
	local currSeq = get_current_seq()

	local checkPoint = {
		["seq_no"] = currSeq,
		["time_and_date"] = os.date("%c"),
	}

	-- Insert into checkpoints
	currBranchInfo.checkpoints[ckpName] = checkPoint

	-- Store names of checkpoints in chron order in history
	table.insert(currBranchInfo.history, ckpName)

	vim.notify( ckpName .. " checkpoint created successfully on branch " .. currBranchName)
end

M.jump_to_checkpoint_on_curr_branch = function()
	
	local checkpointName = vim.fn.input("Enter checkpoint name: ")

	if checkpointName=="" or checkpointName == nil then 
		vim.notify("Please enter a name")
		return
	end
	
	local branchData = ensure_buffer_state()
	local currBranchName = branchData.active_branch
	local currBranchInfo = branchData.branches[currBranchName]
	
	if not search_checkpoint(currBranchInfo.history, checkpointName) then
		vim.notify("Current checkpoint name doesnt exist on curr branch, so reverting...")
		return
	end
	
	local seqNumber = currBranchInfo.checkpoints[checkpointName].seq_no
	vim.cmd("undo " .. seqNumber)
	vim.notify("Jumped to savepoint " .. checkpointName .. " on current branch")
end

M.jump_to_checkpoint_on_other_branch = function()
	
	local branchName = vim.fn.input("Enter the branch name: ") 
	
	if branchName=="" or branchName == nil then 
		vim.notify("Please enter a name")
		return
	end

	local checkpointName = vim.fn.input("Enter checkpoint name: ")

	if checkpointName=="" or checkpointName == nil then 
		vim.notify("Please enter a name")
		return
	end
	
	local branchData = ensure_buffer_state()
	local branchInfo = branchData.branches[branchName]

	if branchInfo == nil then 
		vim.notify("Branch doesnt exist so reverting...")
		return
	end
	
	if not search_checkpoint(branchInfo.history, checkpointName) then
		vim.notify("Current checkpoint name doesnt exist on curr branch, so reverting...")
		return
	end
	
	local seqNumber = branchInfo.checkpoints[checkpointName].seq_no
	vim.cmd("undo " .. seqNumber)
	branchData.active_branch = branchName
	vim.notify("Jumped to savepoint " .. checkpointName .. " on branch " .. branchName)
end	

M.list_all_checkpoints = function()
	local branchStore = ensure_buffer_state()
	local currBranch = branchStore.active_branch

	local stringified = vim.inspect(branchStore.branches[currBranch].history)
	vim.notify("The checkpoints in branch " .. currBranch .. " are: " .. stringified)
end
-- Automation commands for events

vim.api.nvim_create_autocmd("BufWipeout", {
    callback = function(args)
        M.BRANCH_STORE[args.buf] = nil
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		ensure_buffer_state()
	end
})
return M

