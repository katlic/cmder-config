-- custom script for clink

-- default prompt character
local char_lamba = "λ"

-- additional characters
-- powerline fonts only
-- standard
-- extended

-- settings
-- replace character
local replace_char = false
local char_prompt = char_lambda
-- add timestamp
local add_time = true
local time_format = "%H:%M:%S"
-- add proxy
local add_proxy = true
local use_proxy_value = false

-- modify default prompt
function custom_prompt_filter()
	local custom_prompt = clink.prompt.value
	
	-- replace character
	if replace_char then
		custom_prompt = string.gsub(custom_prompt, char_lamba, char_prompt)
	end
	
	-- add timestamp
	if add_time then
		local cur_time = os.date(time_format)
		custom_prompt = "\x1b[1;36;40m["..cur_time.."] "..custom_prompt
	end
	
	-- add proxy placeholder before git_prompt_filter
	if add_proxy then
		custom_prompt = string.gsub(custom_prompt, "{git}", "{proxy}{git}")
	end
	
	clink.prompt.value = custom_prompt
end

-- replace proxy placeholder
function proxy_prompt_filter()
	-- get proxy from env
	local proxy_value = clink.get_env("HTTP_PROXY")
	if proxy_value then
		-- proxy is set
		local proxy = ""
		if use_proxy_value then
			proxy = proxy_value
		else
			proxy = "proxy"
		end
		
		clink.prompt.value = string.gsub(clink.prompt.value, "{proxy}", "\x1b[1;35;40m("..proxy..") ")
	else
		-- no proxy set
		clink.prompt.value = string.gsub(clink.prompt.value, "{proxy}", "")
	end
	
	return false
end

-- run custom_prompt_filter after cmder prompt
clink.prompt.register_filter(custom_prompt_filter, 2)
-- run proxy_prompt_filter before other cmder filters
clink.prompt.register_filter(proxy_prompt_filter, 10)
