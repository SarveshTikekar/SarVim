local scripts = {}

local commFunction = function (script)
		
	local handle = io.popen(script)

	if not handle then return 0 end

	local out = handle:read("*a")
	handle:close()

	return tonumber(out) or 0

end

scripts.commits_till_date = function ()
	
	return commFunction("~/.config/nvim/lua/sarveshtikekar/scripts/commits_till_date.sh 2> /dev/null")
end

scripts.commits_today = function ()
	return commFunction("~/.config/nvim/lua/sarveshtikekar/scripts/commits_today.sh 2> /dev/null")	
end

scripts.streak_count = function ()

	return commFunction("~/.config/nvim/lua/sarveshtikekar/scripts/streak_count.sh 2> /dev/null")	
end

scripts.dominant_languages = function ()
	
	local handle = io.popen("~/.config/nvim/lua/sarveshtikekar/scripts/dominant_languages.sh 2> /dev/null")

	if not handle then return {} end

	local out = handle:read("*a")
	out = out and out:gsub("%s+$", "")

  	if not out or out == "" or out == "-" then return {} end

  	local langs = {}
  	for lang in out:gmatch("%S+") do
    		table.insert(langs, lang)
  	end

  	return langs
end

return scripts
