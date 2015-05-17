--!The Automatic Cross-platform Build Tool
-- 
-- XMake is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
-- 
-- XMake is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
-- 
-- You should have received a copy of the GNU Lesser General Public License
-- along with XMake; 
-- If not, see <a href="http://www.gnu.org/licenses/"> http://www.gnu.org/licenses/</a>
-- 
-- Copyright (C) 2009 - 2015, ruki All rights reserved.
--
-- @author      ruki
-- @file        _config.lua
--

-- define module: _config
local _config = _config or {}

-- load modules
local os        = require("base/os")
local utils     = require("base/utils")
local config    = require("base/config")
    
-- done the given config
function _config.done()

    -- the configs
    local configs = config._CONFIGS
    assert(configs and configs.buildir)

    -- make the build directory
    if not os.isdir(configs.buildir) then
        assert(os.mkdir(configs.buildir))
    end

    -- save configs
    if not config.savexconf() then
        return false
    end

    -- ok
    print("configure ok!")
    return true
end

-- return module: _config
return _config