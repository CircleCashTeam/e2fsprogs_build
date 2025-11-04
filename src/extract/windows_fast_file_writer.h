#ifndef __WINDOWS_FAST_FILE_WRITER_H
#define __WINDOWS_FAST_FILE_WRITER_H

/*
    On windows ofstream is very slow to create file
    Instead we using win32api write to file.
*/

#include <string>
#include <cstdint>
#include <sys/types.h>

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>

class WindowsFastFileWriter
{
private:
    HANDLE hFile;
    char *writeBuffer;
    size_t bufferSize;
    size_t bufferPos;

public:
    WindowsFastFileWriter() : hFile(INVALID_HANDLE_VALUE), bufferSize(64 * 1024), bufferPos(0)
    {
        writeBuffer = new char[bufferSize];
    }

    ~WindowsFastFileWriter()
    {
        close();
        delete[] writeBuffer;
    }

    // no copy
    WindowsFastFileWriter(const WindowsFastFileWriter &) = delete;
    WindowsFastFileWriter &operator=(const WindowsFastFileWriter &) = delete;

    bool open(const std::string &filename);
    bool write(const char *data, size_t size);
    bool flush();
    bool close();
    bool is_open() const;
};

#endif