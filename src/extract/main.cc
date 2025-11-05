#include "extract.h"
#include <filesystem>
#include <fmt/format.h>

using namespace std;
namespace fs = std::filesystem;

extract_config_t extract_config;

int main(int argc, char **argv)
{
    string file_name;
    errcode_t ret = 0;
    extract_ctx ctx;

    if (argc < 2)
    {
        cerr << "Error: Need to specific system image path." << endl;
        return 1;
    }

    file_name = argv[1];

    init_extract_config();
    init_extract_ctx(&ctx);

    initialize_ext2_error_table();

    ret = ext2fs_open(
        file_name.c_str(),
        EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE | EXT2_FLAG_THREADS | EXT2_FLAG_PRINT_PROGRESS,
        0,
        0,
#ifdef _WIN32
        windows_io_manager,
#else
        unix_io_manager,
#endif
        &ctx.fs);

    if (ret)
    {
        com_err(argv[0], ret, "while opening filesystem");
        return 1;
    }

    // set out image dir
    //extract_config.volume_name = reinterpret_cast<char *>(ctx.fs->super->s_volume_name);
    auto xfile_name = fs::path(file_name).filename().string();
    if (xfile_name[xfile_name.length() - 4] == '.')
        xfile_name = xfile_name.substr(0, xfile_name.length() - 4);

    extract_config.volume_name = xfile_name;
    extract_config.outdir = (fs::path(extract_config.extract_dir) /
                             reinterpret_cast<char *>(ctx.fs->super->s_volume_name))
                                .string();
    extract_config.config_dir = (fs::path(extract_config.extract_dir) / "config").string();

    cout << "Image volume name: " << extract_config.volume_name << endl;
    cout << "Setup extract dir: " << extract_config.extract_dir << endl;
    cout << "Setup image output dir: " << extract_config.outdir << endl;
    cout << "Setup config output dir: " << extract_config.config_dir << endl;

    // count how many file need to be extract
    extract_config.total_files = count_files_recursive(ctx.fs, EXT2_ROOT_INO);
    cout << "Extracting " << extract_config.total_files << " files begin ..." << endl;

    // Extract
    process_directory(ctx.parent_ino, &ctx);

    // configs
    //for (const auto& element : extract_config.configs) {
    //    cout << fmt::format("path: {}, uid: {}, gid: {}, mode: {:#4o}, is_symlink: {}, context: {}, capabilities: 0x{:x}",
    //        element.path, element.uid, element.gid, element.mode & 0777, element.is_symlink, element.context, element.capabilities
    //    ) << endl;
    //}
    extract_fs_config();
    extract_file_contexts();

    ext2fs_close(ctx.fs);
    return 0;
}