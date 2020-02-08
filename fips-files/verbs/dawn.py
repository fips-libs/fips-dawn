#===============================================================================
#   ./fips dawn [cmd]
#       install
#       uninstall
#
#   Bootstrap Google Dawn as SDK for other fips projects (similar
#   to the emscripten or Android SDKs)
#===============================================================================

import os, shutil, subprocess

from mod import log, util, settings
from mod.tools import git, ninja

DAWN_URL = 'https://dawn.googlesource.com/dawn'
DEPOT_TOOLS_URL = 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'

def make_dirs(path):
    if not os.path.isdir(path):
        os.makedirs(path)

# libdawn is treated like an SDK (e.g. emscripten or Android)
def get_sdk_dir(fips_dir):
    return util.get_workspace_dir(fips_dir) + '/fips-sdks/dawn'

# get the dawn repository directory
def get_dawn_dir(fips_dir):
    return get_sdk_dir(fips_dir) + '/dawn'

# get the dawn build output directory
def get_out_dir(fips_dir):
    return get_dawn_dir(fips_dir) + '/out'

# get the depot tools directory
def get_depot_tools_dir(fips_dir):
    return get_out_dir(fips_dir) + '/depot_tools'

# fetch Dawn source repository to fips-sdks/dawn/dawn
def fetch_dawn(fips_dir):
    sdk_dir = get_sdk_dir(fips_dir)
    make_dirs(sdk_dir)
    dawn_dir = get_dawn_dir(fips_dir)
    if not os.path.isdir(dawn_dir):
        log.info('>> cloning Dawn sources to {}'.format(dawn_dir))
        git.clone(DAWN_URL, None, 1, 'dawn', sdk_dir)
    else:
        log.info('>> Dawn sources already cloned to {}'.format(dawn_dir))

# fetch Google build tools to fips-sdks/dawn/dawn/out/depot_tools
def fetch_depot_tools(fips_dir):
    out_dir = get_out_dir(fips_dir)
    make_dirs(out_dir)
    dt_dir = get_depot_tools_dir(fips_dir)
    if not os.path.isdir(dt_dir):
        log.info('>> cloning depot_tools to {}'.format(dt_dir))
        git.clone(DEPOT_TOOLS_URL, None, 1, 'depot_tools', out_dir)
    else:
        log.info('>> depot_tools already cloned to {}'.format(dt_dir))

# run the gclient tool
def gclient(fips_dir, args):
    cmd = [ get_depot_tools_dir(fips_dir) + '/gclient' ]
    cmd.extend(args)
    subprocess.call(cmd, cwd = get_dawn_dir(fips_dir))

# run the gn tool
def gn(fips_dir, args):
    cmd = [ get_depot_tools_dir(fips_dir) + '/gn' ]
    cmd.extend(args)
    subprocess.call(cmd, cwd = get_dawn_dir(fips_dir))

# overwrite the args.gn file in the output directory
def write_build_args(fips_dir, cfg, args):
    args_path = get_out_dir(fips_dir) + '/' + cfg + '/args.gn'
    with open(args_path, 'w') as f:
        for arg in args:
            f.write(arg + '\n')

# bootstrap the build
def bootstrap(fips_dir):
    log.colored(log.YELLOW, "=== bootstrapping build...".format(get_sdk_dir(fips_dir)))
    dawn_dir = get_dawn_dir(fips_dir)
    gclient_src = dawn_dir + '/scripts/standalone.gclient'
    gclient_dst = dawn_dir + '/.gclient'
    if not os.path.isfile(gclient_dst):
        shutil.copy(gclient_src, gclient_dst)
    gclient(fips_dir, ['sync'])
    log.info('>> generating release build files')
    gn(fips_dir, ['gen', 'out/Release'])
    write_build_args(fips_dir, 'Release', ['is_debug=true', 'dawn_complete_static_libs=true'])
    log.info('>> generating debug build files')
    gn(fips_dir, ['gen', 'out/Debug'])
    write_build_args(fips_dir, 'Debug', ['is_debug=false', 'dawn_complete_static_libs=true'])
    out_dir = get_out_dir(fips_dir)
    log.info('>> building debug version...')
    ninja.run_build(fips_dir, None, out_dir + '/Debug', 6)
    log.info('>> building release version...')
    ninja.run_build(fips_dir, None, out_dir + '/Release', 6) 

# install and build the "Dawn SDK" into fips-sdks/dawn
def install(fips_dir):
    log.colored(log.YELLOW, "=== installing Dawn SDK".format(get_sdk_dir(fips_dir)))
    if not ninja.check_exists(fips_dir):
        log.error('ninja build tool is needed to build Dawn')
    fetch_dawn(fips_dir)
    fetch_depot_tools(fips_dir)
    bootstrap(fips_dir)

# delete the "Dawn SDK" in fips-sdks/dawn
def uninstall(fips_dir):
    log.colored(log.YELLOW, "=== uninstalling Dawn SDK".format(get_sdk_dir(fips_dir)))
    sdk_dir = get_sdk_dir(fips_dir)
    if os.path.isdir(sdk_dir):
        if util.confirm(log.RED + "Delete Dawn SDK directory at '{}'?".format(sdk_dir) + log.DEF):
            log.info("Deleting '{}'...".format(sdk_dir))
            shutil.rmtree(sdk_dir)
        else:
            log.info("'No' selected, nothing deleted")
    else:
        log.warn('Dawn SDK is not installed, nothing to do')

#=== fips verb entry points ====================================================
def run(fips_dir, proj_dir, args):
    if len(args) > 0:
        cmd = args[0]
        if cmd == 'install':
            install(fips_dir)
        elif cmd == 'uninstall':
            uninstall(fips_dir)
        else:
            log.error("unknown subcmd '{}', valid subcmds are 'install' and 'uninstall'".format(cmd))

def help():
    log.info(log.YELLOW +
        'fips dawn install\n' +
        'fips dawn uninstall\n' +
        log.DEF +
        '    install and manage Google Dawn SDK')
