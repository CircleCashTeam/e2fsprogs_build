#include "extract.h"
#include <fmt/format.h>

// When percent is larger than last update, it will print new precent
// This is avoid slow print on windows console
void progress_plus()
{
    const int32_t percent = (++extract_config.processed_files * 100) /
                            extract_config.total_files;
    if (percent > extract_config.last_percent)
    {
        std::cout << fmt::format("[{:3d}%] Processing ...\r",
                                 percent)
                  << std::flush;
        extract_config.last_percent++;
    }
    if (percent > 99) {
        std::cout << fmt::format("[{:3d}%] Processing ... Done!",
                                 percent) << std::endl;
    }
}