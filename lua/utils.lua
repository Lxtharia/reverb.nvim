local M = {}

local function finished_playing()
    RUNNING_PROCESSES = RUNNING_PROCESSES -1
end

-- Returns a value between 0.0 and 1.0
local function convert_volume(human_volume)
    human_volume = human_volume or 100
    local clamped_volume = math.max(0, math.min(100, human_volume))
    local normalized_volume = clamped_volume / 100.0
    return normalized_volume
end

-- Play a sound using paplay
M.paplay_play_sound = function(path, human_volume)
    local volume = math.floor(convert_volume(human_volume) * 65536.0)
    vim.system({ 'paplay', path, '--volume', tostring(volume) }, {}, finished_playing)
end

-- Play a sound using pwplay
M.pw_play_play_sound = function(path, human_volume)
    local volume = convert_volume(human_volume)
    vim.system({ 'pw-play', path, '--volume', tostring(volume) }, {}, finished_playing)
end

-- Play a sound using mpv
M.mpv_play_sound = function(path, human_volume)
    local volume = convert_volume(human_volume) * 100.0
    vim.system({ 'mpv', path, '--no-keep-open', '--volume='..tostring(volume) }, {}, finished_playing)
end

-- Good old path exists function
M.path_exists = function(path)
    local ok, err, code = os.rename(path, path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

return M;
