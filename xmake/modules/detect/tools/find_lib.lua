--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        find_lib.lua
--

-- imports
import("lib.detect.find_program")
import("lib.detect.find_programver")

-- find lib 
--
-- @param opt   the argument options, .e.g {version = true}
--
-- @return      program, version
--
-- @code 
--
-- local lib = find_lib()
-- 
-- @endcode
--
function main(opt)

    -- init options
    opt = opt or {}
    
    -- find program
    local verinfo = nil
    local program = find_program(opt.program or "lib.exe", opt.pathes, opt.check or function (program) 
      
        -- make an stub source file
        local libraryfile = os.tmpfile() .. ".lib"
        local objectfile  = os.tmpfile() .. ".obj"
        local sourcefile  = os.tmpfile() .. ".c"
        io.writefile(sourcefile, "int test(void)\n{return 0;}")

        -- check it
        os.run("cl -c -Fo%s %s", objectfile, sourcefile)
        os.run("link -lib -out:%s %s", libraryfile, objectfile)
        verinfo = os.iorun("%s -list %s", program, libraryfile)

        -- remove files
        os.rm(objectfile)
        os.rm(sourcefile)
        os.rm(libraryfile)
    end)

    -- find program version
    local version = nil
    if program and opt and opt.version then
        version = find_programver(program, function () return verinfo end,
                                           function (output) return output:match("Version (%d+%.?%d*%.?%d*.-)%s") end)
    end

    -- ok?
    return program, version
end

