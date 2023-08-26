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
from mod.tools import ninja

DAWN_URL = 'https://dawn.googlesource.com/dawn'
DAWN_REF = 'db46be1539c3e7784c87ea9c0b4e8568c6b1c179'

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

# get the build directory for a specific mode (Debug or Release)
def get_build_dir(fips_dir, mode):
    return get_out_dir(fips_dir) + '/' + mode

# fetch Dawn source repository to fips-sdks/dawn/dawn
def fetch_dawn(fips_dir):
    sdk_dir = get_sdk_dir(fips_dir)
    make_dirs(sdk_dir)
    dawn_dir = get_dawn_dir(fips_dir)
    if not os.path.isdir(dawn_dir):
        log.info('>> cloning Dawn sources to {}'.format(dawn_dir))
        subprocess.call(f'git clone {DAWN_URL}', cwd=sdk_dir, shell=True)
        subprocess.call(f'git checkout {DAWN_REF}', cwd=dawn_dir, shell=True)
    else:
        log.info('>> Dawn sources already cloned to {}'.format(dawn_dir))

# run cmake
def cmake(fips_dir, mode, args):
    cmd = [ 'cmake' ]
    cmd.extend(args)
    print(f'{" ".join(cmd)}')
    build_dir = get_build_dir(fips_dir, mode)
    make_dirs(build_dir)
    subprocess.call(cmd, cwd = build_dir)

# bootstrap the build
# FIXME: currently hardwired to the Metal backend
def bootstrap(fips_dir):
    log.colored(log.YELLOW, "=== bootstrapping build...".format(get_sdk_dir(fips_dir)))
    dawn_dir = get_dawn_dir(fips_dir)
    log.info('>> generating debug build files')
    common_args = [
        '-G', 'Ninja',
        '-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13',
        '-DDAWN_FETCH_DEPENDENCIES=ON',
        '-DDAWN_ENABLE_NULL=OFF',
        '-DDAWN_BUILD_SAMPLES=OFF',
        '-DTINT_BUILD_SAMPLES=OFF',
        '-DTINT_BUILD_DOCS=OFF',
        '-DTINT_BUILD_TESTS=OFF',
    ]
    debug_args = [ *common_args, '-DCMAKE_BUILD_TYPE=Debug', '../..' ]
    release_args = [ *common_args, '-DCMAKE_BUILD_TYPE=Release', '../..' ]
    cmake(fips_dir, 'Debug', debug_args)
    log.info('>> generating release build files')
    cmake(fips_dir, 'Release', release_args)
    log.info('>> building debug version...')
    cmake(fips_dir, 'Debug', ['--build', '.'])
    log.info('>> building release version...')
    cmake(fips_dir, 'Release', ['--build', '.'])
    # create dummy link directories so that Xcode doesn't complain
    #log.info('>> creating dummy link dirs...')
    #for mode in ['Debug', 'Release']:
    #    for dir in ['/src/dawn',
    #                '/src/dawn_native',
    #                '/third_party/shaderc/libshaderc_spvc',
    #                '/third_party/tint/src',
    #                '/third_party/glfw/src']:
    #        dummy_dir = get_build_dir(fips_dir, mode) + dir + '/' + mode
    #        log.info('    {}'.format(dummy_dir))
    #        make_dirs(dummy_dir)

# install and build the "Dawn SDK" into fips-sdks/dawn
def install(fips_dir):
    log.colored(log.YELLOW, "=== installing Dawn SDK".format(get_sdk_dir(fips_dir)))
    if not ninja.check_exists(fips_dir):
        log.error('ninja build tool is needed to build Dawn')
    fetch_dawn(fips_dir)
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
